#!/bin/bash
# build_pendrive.sh - monta o pendrive multi-macOS + partição KIT (rodar no Mac de bancada)
# A KIT leva só o que o cliente usa: "Instalar Office.command" (na raiz),
# scripts/install_office.sh e VERSION (este script não vai para o pendrive).
# Uso: sudo bash scripts/build_pendrive.sh diskN [--dry-run]
#      (descubra o diskN com: diskutil list external)
set -eu

MIN_BYTES=120000000000
USO="uso: sudo bash scripts/build_pendrive.sh diskN [--dry-run]"
# "versão:partição" na ordem de gravação; a partição KIT nunca entra aqui
INST=("High Sierra:HS" "Mojave:MOJ" "Catalina:CAT" "Big Sur:BSUR"
      "Monterey:MONT" "Ventura:VEN" "Sonoma:SON" "Sequoia:SEQ")

die() { echo "ERRO: $*" >&2; exit 1; }

# Em --dry-run só imprime o comando destrutivo
run() {
  if [ "$DRY" = 1 ]; then
    printf '[dry-run]'; printf ' %q' "$@"; echo
  else
    "$@"
  fi
}

# Valor de um campo de `diskutil info` (vazio se ausente)
field() { diskutil info "$1" 2>/dev/null | sed -n "s/^ *$2: *//p" | head -n 1; }

# Após o particionamento: /Volumes/<nome> tem de ser do disco-alvo (evita gravar
# num volume homónimo de outro disco, que viraria "/Volumes/<nome> 1")
confere_volume() {
  if [ "$DRY" = 1 ]; then return 0; fi
  [ "$(field "/Volumes/$1" "Part of Whole")" = "$DISK" ] ||
    die "/Volumes/$1 não pertence a $DISK; abortado para não gravar no disco errado."
}

DRY=0
DISK=""
for a; do
  case "$a" in
    --dry-run) DRY=1 ;;
    *) [ -z "$DISK" ] || die "$USO"; DISK="$a" ;;
  esac
done

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
REPO="${REPO:?caminho do repositório vazio}"

# a. root (dispensado em --dry-run)
if [ "$DRY" = 0 ]; then
  [ "${EUID:-$(id -u)}" -eq 0 ] || die "execute com sudo. $USO"
fi

# b. disco inteiro, nunca diskNsM
[[ "$DISK" =~ ^disk[0-9]+$ ]] || die "argumento inválido '$DISK'. $USO"

# c. disco externo
diskutil info "$DISK" >/dev/null 2>&1 || die "disco $DISK não encontrado."
[ "$(field "$DISK" "Device Location")" = "External" ] ||
  die "$DISK não é externo (Device Location ausente ou diferente de External)."

# d. não é o disco de / (nem o disco físico do contentor APFS de /)
ROOT_WHOLE="$(field / "Part of Whole")"
ROOT_STORE="$(field / "APFS Physical Store")"
[ -n "$ROOT_WHOLE" ] || die "não foi possível identificar o disco de /."
[ "$DISK" != "$ROOT_WHOLE" ] && [ "$DISK" != "${ROOT_STORE%s*}" ] ||
  die "$DISK é o disco do sistema em uso."

# e. capacidade mínima (pendrive de 128 GB)
BYTES="$(field "$DISK" "Disk Size" | sed -n 's/.*(\([0-9]*\) Bytes).*/\1/p')"
case "$BYTES" in ''|*[!0-9]*) die "não foi possível ler a capacidade de $DISK." ;; esac
[ "$BYTES" -ge "$MIN_BYTES" ] || die "$DISK tem $BYTES bytes; mínimo $MIN_BYTES."

# f. pelo menos um instalador conhecido em /Applications
GRAVAR=""
PULAR=""
for item in "${INST[@]}"; do
  ver="${item%:*}"
  if [ -d "/Applications/Install macOS $ver.app" ]; then
    GRAVAR="$GRAVAR  $ver -> ${item#*:}
"
  else
    PULAR="$PULAR  $ver
"
  fi
done
[ -n "$GRAVAR" ] || die "nenhum 'Install macOS <versão>.app' (High Sierra a Sequoia) em /Applications."
printf 'Serão gravados:\n%s' "$GRAVAR"
printf 'Faltam (partição fica vazia):\n%s' "${PULAR:-  nenhum
}"

# Origem da partição KIT
[ -f "$REPO/scripts/install_office.sh" ] && [ -f "$REPO/scripts/Instalar Office.command" ] ||
  die "scripts/install_office.sh ou \"scripts/Instalar Office.command\" não encontrados em $REPO."

# Confirmação
diskutil list "$DISK"
printf 'TODO o conteúdo de /dev/%s será APAGADO. Digite SIM: ' "$DISK"
OK=""
read -r OK || true
[ "$OK" = "SIM" ] || die "cancelado (não foi digitado SIM)."

# GPT + Mac OS Extended (Journaled), uma partição por versão + KIT
run diskutil partitionDisk "$DISK" GPT \
  JHFS+ HS 8G  JHFS+ MOJ 8G  JHFS+ CAT 10G \
  JHFS+ BSUR 15G  JHFS+ MONT 15G  JHFS+ VEN 15G \
  JHFS+ SON 16G  JHFS+ KIT 10G  JHFS+ SEQ R ||
  die "diskutil partitionDisk falhou."

for item in "${INST[@]}"; do
  ver="${item%:*}"
  part="${item#*:}"
  app="/Applications/Install macOS $ver.app"
  [ -d "$app" ] || continue
  echo ">> Gravando $ver em /Volumes/$part"
  confere_volume "$part"
  run "$app/Contents/Resources/createinstallmedia" --volume "/Volumes/$part" --nointeraction ||
    die "createinstallmedia falhou para $ver."
done

echo ">> Copiando o lançador e install_office.sh para /Volumes/KIT"
confere_volume KIT
run ditto "$REPO/scripts/install_office.sh" /Volumes/KIT/scripts/install_office.sh ||
  die "ditto de install_office.sh falhou."
run ditto "$REPO/scripts/Instalar Office.command" "/Volumes/KIT/Instalar Office.command" ||
  die "ditto do Instalar Office.command falhou."
# o Windows perde o bit de execução; sem ele o duplo clique não abre
run chmod 755 /Volumes/KIT/scripts/install_office.sh "/Volumes/KIT/Instalar Office.command" ||
  die "chmod na KIT falhou."

REV="sem-git"
if command -v git >/dev/null 2>&1; then
  REV="$(git -c safe.directory="$REPO" -C "$REPO" describe --always --dirty 2>/dev/null)" || REV="sem-git"
fi
VERSION_TXT="data: $(date +%Y-%m-%dT%H:%M:%S%z)
git: $REV
gravados:
${GRAVAR}pulados:
${PULAR:-  nenhum
}"
if [ "$DRY" = 1 ]; then
  echo "[dry-run] gravaria /Volumes/KIT/VERSION"
else
  printf '%s' "$VERSION_TXT" > /Volumes/KIT/VERSION || die "não foi possível gravar /Volumes/KIT/VERSION."
fi

echo
echo "===== Resumo ($DISK) ====="
printf '%s' "$VERSION_TXT"
echo "Cada partição gravada agora se chama 'Install macOS <versão>'; a KIT mantém o nome."
