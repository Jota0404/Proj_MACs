#!/bin/bash
# =============================================================================
#  instalar_office.sh  -  Pós-instalação automatizada do Microsoft Office
#  Alvo: MacBooks Intel (<= 2019) com macOS 10.13 a 12 (High Sierra -> Monterey)
#
#  O que faz:
#    1. Detecta a versão do macOS com sw_vers
#    2. Localiza no pendrive a pasta do Office correspondente
#    3. Seleciona o .pkg (ignora arquivos ._* criados pelo macOS em FAT/exFAT)
#    4. Instala em modo silencioso: installer -pkg <arquivo> -target /
#    5. Confere os 5 aplicativos instalados e registra tudo em log
#
#  Uso (a partir do pendrive):
#    sudo bash /Volumes/NOME_DO_PENDRIVE/instalar_office.sh
#
#  Opções:
#    --dry-run            Mostra o que seria feito, sem instalar nada
#    --lock-updates       Deixa o Microsoft AutoUpdate em modo Manual
#    --office-dir PASTA   Usa outra pasta-base em vez de <pendrive>/Office
#    -h | --help          Ajuda
#
#  Variáveis para teste: MACOS_VERSION_OVERRIDE=10.15.7  LOG_FILE=/caminho
#
#  Códigos de saída: 0 ok | 1 erro geral | 2 macOS não suportado
#                    3 instalador não encontrado | 4 falha na instalação
#                    5 pouco espaço em disco
#
#  Compatível com o bash 3.2 que acompanha o macOS (sem arrays associativos).
# =============================================================================

set -uo pipefail

# Em Big Sur+ alguns processos recebem "10.16" por compatibilidade; desliga isso.
export SYSTEM_VERSION_COMPAT=0
export LC_ALL=C

BASH_SRC="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd "$(dirname "$BASH_SRC")" && pwd -P)"
SCRIPT_FILE="$SCRIPT_DIR/$(basename "$BASH_SRC")"
ORIG_ARGS=("$@")

DRY_RUN=0
LOCK_UPDATES=0
OFFICE_DIR_ARG=""
MIN_FREE_KB=$((8 * 1024 * 1024))   # 8 GB livres no disco do sistema

# ----------------------------------------------------------------- argumentos
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)      DRY_RUN=1 ;;
    --lock-updates) LOCK_UPDATES=1 ;;
    --office-dir)   shift; OFFICE_DIR_ARG="${1:-}" ;;
    -h|--help)      sed -n '2,29p' "$SCRIPT_FILE" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Opção desconhecida: $1 (use --help)"; exit 1 ;;
  esac
  shift
done

# ------------------------------------------------------------------------ log
LOG_FILE="${LOG_FILE:-/var/log/office_setup.log}"
if ! { : >> "$LOG_FILE"; } 2>/dev/null; then
  LOG_FILE="${TMPDIR:-/tmp}/office_setup.log"
  : >> "$LOG_FILE" 2>/dev/null || LOG_FILE="/dev/null"
fi

log() {  # log NIVEL "mensagem"
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" "$2" | tee -a "$LOG_FILE"
}
die() {  # die CODIGO "mensagem"
  log "ERRO" "$2"
  exit "$1"
}

# ------------------------------------------------------------------ privilégio
if [ "$(id -u)" -ne 0 ] && [ "$DRY_RUN" -eq 0 ]; then
  echo "Este script precisa de administrador. Solicitando sudo..."
  exec sudo /bin/bash "$SCRIPT_FILE" "${ORIG_ARGS[@]+"${ORIG_ARGS[@]}"}"
fi

# ----------------------------------------------- 1) detectar versão do macOS
detect_macos() {
  if [ -n "${MACOS_VERSION_OVERRIDE:-}" ]; then
    OS_VER="$MACOS_VERSION_OVERRIDE"
  else
    command -v sw_vers >/dev/null 2>&1 || die 1 "sw_vers não encontrado: este script só roda no macOS."
    OS_VER="$(sw_vers -productVersion)"
  fi

  OS_MAJOR="${OS_VER%%.*}"
  if [ "$OS_MAJOR" = "$OS_VER" ]; then
    OS_MINOR=0
  else
    _rest="${OS_VER#*.}"
    OS_MINOR="${_rest%%.*}"
  fi

  # Tabela: pasta no pendrive | nome comercial | última build do Office suportada
  FOLDER=""; OS_NAME=""; MAX_OFFICE=""
  case "$OS_MAJOR" in
    10)
      case "$OS_MINOR" in
        13) FOLDER="macOS_10.13_HighSierra"; OS_NAME="High Sierra"; MAX_OFFICE="16.43" ;;
        14) FOLDER="macOS_10.14_Mojave";     OS_NAME="Mojave";      MAX_OFFICE="16.54" ;;
        15) FOLDER="macOS_10.15_Catalina";   OS_NAME="Catalina";    MAX_OFFICE="16.66" ;;
        16) FOLDER="macOS_11_BigSur";        OS_NAME="Big Sur";     MAX_OFFICE="16.77" ;; # 10.16 = Big Sur em modo de compatibilidade
      esac ;;
    11) FOLDER="macOS_11_BigSur";  OS_NAME="Big Sur";  MAX_OFFICE="16.77" ;;
    12) FOLDER="macOS_12_Monterey"; OS_NAME="Monterey"; MAX_OFFICE="16.89" ;;
  esac

  if [ -z "$FOLDER" ]; then
    die 2 "macOS $OS_VER fora do escopo (suportado: 10.13 a 12.x). Use o instalador atual da Microsoft, se aplicável."
  fi
}

# ----------------------------------- 2) localizar pasta-base do Office no pendrive
find_base() {
  local c
  for c in "$OFFICE_DIR_ARG" "$SCRIPT_DIR/Office" /Volumes/*/Office; do
    if [ -n "$c" ] && [ -d "$c/$FOLDER" ]; then
      printf '%s\n' "$c"
      return 0
    fi
  done
  return 1
}

# --------------------------------------------------- 3) escolher o .pkg correto
# Ignora ._* (metadados do macOS em FAT32/exFAT). Se houver mais de um .pkg na
# pasta, usa o mais recente (por data de modificação) e avisa no log.
pick_pkg() {
  local dir="$1" best="" f b
  for f in "$dir"/*.pkg; do
    [ -f "$f" ] || continue
    b="$(basename "$f")"
    case "$b" in ._*) continue ;; esac
    if [ -z "$best" ] || [ "$f" -nt "$best" ]; then best="$f"; fi
  done
  [ -n "$best" ] || return 1
  printf '%s\n' "$best"
}

count_pkgs() {
  local dir="$1" f n=0
  for f in "$dir"/*.pkg; do
    [ -f "$f" ] || continue
    case "$(basename "$f")" in ._*) continue ;; esac
    n=$((n + 1))
  done
  printf '%s\n' "$n"
}

check_disk() {
  local free_kb
  free_kb="$(df -k / | awk 'NR==2 {print $4}')"
  case "$free_kb" in ''|*[!0-9]*) log "AVISO" "Não foi possível medir o espaço livre."; return 0 ;; esac
  if [ "$free_kb" -lt "$MIN_FREE_KB" ]; then
    die 5 "Espaço livre insuficiente: $((free_kb / 1024 / 1024)) GB (mínimo: $((MIN_FREE_KB / 1024 / 1024)) GB)."
  fi
  log "INFO" "Espaço livre no sistema: $((free_kb / 1024 / 1024)) GB"
}

verify_pkg() {
  local pkg="$1"
  if command -v xar >/dev/null 2>&1; then
    xar -t -f "$pkg" >/dev/null 2>&1 || die 3 "Pacote ilegível ou corrompido (recopie para o pendrive): $pkg"
  fi
  if command -v pkgutil >/dev/null 2>&1; then
    if pkgutil --check-signature "$pkg" 2>&1 | grep -q "Microsoft Corporation"; then
      log "INFO" "Assinatura Microsoft verificada."
    else
      log "AVISO" "Não foi possível confirmar a assinatura da Microsoft neste pacote."
    fi
  fi
}

# ------------------------------------------------------------- 5) pós-checagem
post_check() {
  local app v missing=0
  for app in Word Excel PowerPoint Outlook OneNote; do
    local plist="/Applications/Microsoft $app.app/Contents/Info"
    if [ -d "/Applications/Microsoft $app.app" ]; then
      v="$(defaults read "$plist" CFBundleShortVersionString 2>/dev/null || echo '?')"
      log "INFO" "OK  Microsoft $app  versão $v"
      case "$v" in
        "$MAX_OFFICE"*|"?") ;;
        *) log "AVISO" "Microsoft $app $v difere da build esperada ($MAX_OFFICE.x) para $OS_NAME." ;;
      esac
    else
      log "AVISO" "Microsoft $app.app não encontrado em /Applications"
      missing=$((missing + 1))
    fi
  done
  return "$missing"
}

# ------------------------------------------------------------------- principal
log "INFO" "===== Início: $(date) ====="
[ "$DRY_RUN" -eq 1 ] && log "INFO" "Modo --dry-run: nada será instalado."

detect_macos
ARCH="$(uname -m)"
log "INFO" "macOS $OS_VER ($OS_NAME) | arquitetura $ARCH | build Office alvo: $MAX_OFFICE.x"
[ "$ARCH" = "x86_64" ] || log "AVISO" "Arquitetura $ARCH (esperado x86_64/Intel)."

BASE="$(find_base)" || die 3 "Pasta '$FOLDER' não encontrada. Esperado: <pendrive>/Office/$FOLDER/ (ou use --office-dir)."
log "INFO" "Pasta-base do Office: $BASE"

PKG="$(pick_pkg "$BASE/$FOLDER")" || die 3 "Nenhum .pkg em $BASE/$FOLDER"
PKG_COUNT="$(count_pkgs "$BASE/$FOLDER")"
[ "$PKG_COUNT" -gt 1 ] && log "AVISO" "$PKG_COUNT arquivos .pkg na pasta; usando o mais recente."
log "INFO" "Instalador selecionado: $(basename "$PKG")"

if [ "$DRY_RUN" -eq 1 ]; then
  log "INFO" "[dry-run] executaria: installer -pkg \"$PKG\" -target /"
  [ "$LOCK_UPDATES" -eq 1 ] && log "INFO" "[dry-run] executaria: defaults write /Library/Preferences/com.microsoft.autoupdate2 HowToCheck -string Manual"
  log "INFO" "===== Fim (dry-run) ====="
  exit 0
fi

check_disk
verify_pkg "$PKG"

# Fecha apps do Office abertos para evitar conflito durante a instalação
for app in Word Excel PowerPoint Outlook OneNote; do
  pkill -x "Microsoft $app" 2>/dev/null || true
done

log "INFO" "Instalando (pode levar vários minutos em HD mecânico)..."
installer -pkg "$PKG" -target / -verboseR 2>&1 | tee -a "$LOG_FILE"
RC="${PIPESTATUS[0]}"
[ "$RC" -eq 0 ] || die 4 "installer retornou código $RC. Veja $LOG_FILE e /var/log/install.log."
log "INFO" "Pacote instalado com sucesso."

if [ "$LOCK_UPDATES" -eq 1 ]; then
  defaults write /Library/Preferences/com.microsoft.autoupdate2 HowToCheck -string Manual \
    && log "INFO" "Microsoft AutoUpdate definido como Manual."
fi

post_check
MISSING=$?
if [ "$MISSING" -gt 0 ]; then
  log "AVISO" "$MISSING aplicativo(s) ausente(s). Confirme se o pacote é a suíte completa."
fi

log "INFO" "===== Concluído. Log: $LOG_FILE ====="
log "INFO" "Próximo passo: abrir o Word e ativar com a conta/licença do cliente."
exit 0
