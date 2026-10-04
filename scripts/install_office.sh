#!/bin/bash
# install_office.sh - instala os .pkg de assets/office/ (rodar a partir do pendrive)
# Uso: sudo bash /Volumes/PENDRIVE/scripts/install_office.sh
set -eu

MIN_FREE_GB=10

die() { echo "ERRO: $*" >&2; exit 1; }

# Bloco { } lido inteiro antes de executar: pendrive removido a meio dá erro limpo,
# não um script cortado a meio da leitura.
{
[ "${EUID:-$(id -u)}" -eq 0 ] || die "execute com sudo."

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ROOT="${ROOT:?caminho raiz vazio}"
case "$ROOT" in
  /Volumes/?*) ;;
  *) die "o kit tem de rodar a partir de um volume em /Volumes/ (atual: $ROOT)." ;;
esac

PKG_DIR="$ROOT/assets/office"
[ -d "$PKG_DIR" ] || die "pasta não encontrada: $PKG_DIR"

# Carregador ligado (evita desligar a meio da instalação)
pmset -g batt | grep -q "AC Power" || die "ligue o carregador."

# Espaço livre em / (KB)
FREE_KB="$(df -k / | awk 'NR==2 {print $4}')"
case "$FREE_KB" in ''|*[!0-9]*) die "não foi possível medir o espaço livre." ;; esac
[ "$FREE_KB" -ge $((MIN_FREE_GB * 1024 * 1024)) ] || die "menos de ${MIN_FREE_GB} GB livres."

# Os .pkg têm de existir fisicamente ([!.] ignora ._* de FAT/exFAT)
set -- "$PKG_DIR"/[!.]*.pkg
[ -e "$1" ] || die "nenhum .pkg em $PKG_DIR"

for f; do
  echo ">> Instalando: $f"
  installer -pkg "$f" -target / || die "installer falhou em $f (ver /var/log/install.log)."
done

echo "Concluído. Abra o Word e ative com a licença do cliente."
}; exit
