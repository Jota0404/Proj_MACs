#!/bin/bash
# install_office.sh - baixa da Microsoft e instala o Office oficial (Mac do cliente)
# Normalmente chamado pelo "Instalar Office.command" (dois cliques na KIT).
# Uso: sudo bash scripts/install_office.sh
# Códigos: 0 ok · 1 erro (a linha ERRO diz o que fazer) · 2 macOS sem suporte
set -eu

# Instaladores completos "Microsoft 365 and Office" (sem Teams), copiados de
# https://learn.microsoft.com/officeupdates/update-history-office-for-mac
# Office < 16.83 fica em modo reduzido desde 13/07/2026: ver docs/decisoes.md (ADR-001).
URL_MACOS12="https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_365_and_Office_16.88.24081116_Installer.pkg"
URL_MACOS13="https://officecdn.microsoft.com/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_365_and_Office_16.101.25091314_Installer.pkg"
URL_MACOS14="https://res.public.onecdn.static.microsoft/mro1cdnstorage/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_365_and_Office_16.113.26092714_Installer.pkg"
MIN_FREE_GB=15  # download de ~3 GB mais o Office instalado

die() { echo "ERRO: $*" >&2; exit 1; }

# Bloco { } lido inteiro antes de executar: pendrive removido a meio dá erro limpo,
# não um script cortado a meio da leitura.
{
# a. root
[ "${EUID:-$(id -u)}" -eq 0 ] ||
  die "o instalador precisa da senha do Mac. Abra-o com dois cliques em \"Instalar Office.command\"."

# b. macOS: escolhe a versão do Office
MACOS="$(sw_vers -productVersion 2>/dev/null || true)"
case "${MACOS%%.*}" in
  10|11)
    echo "ERRO: este Mac tem o macOS $MACOS. O Office atual só funciona no macOS 12 ou mais novo (limite da Microsoft), por isso não dá para instalar neste Mac." >&2
    exit 2 ;;
  ''|*[!0-9]*) die "não foi possível identificar a versão do macOS. Peça ajuda ao técnico." ;;
  12) URL="$URL_MACOS12" ;;
  13) URL="$URL_MACOS13" ;;
  *) URL="$URL_MACOS14" ;;
esac

# c. carregador ligado (evita desligar a meio da instalação)
pmset -g batt | grep -q "AC Power" || die "ligue o carregador na tomada e rode de novo."

# d. relógio (data errada quebra o download seguro e a ativação)
YEAR="$(date +%Y)"
[ "$YEAR" -ge 2026 ] ||
  die "o relógio do Mac está no ano $YEAR. Acerte a data em Ajustes do Sistema > Geral > Data e Hora (no macOS 12: Preferências do Sistema > Data e Hora) e rode de novo."

# e. espaço livre em / (KB); falha fechada se não der para medir
FREE_KB="$(df -k / | awk 'NR==2 {print $4}')"
case "$FREE_KB" in ''|*[!0-9]*) die "não foi possível medir o espaço livre do disco. Peça ajuda ao técnico." ;; esac
[ "$FREE_KB" -ge $((MIN_FREE_GB * 1024 * 1024)) ] ||
  die "o Mac tem menos de ${MIN_FREE_GB} GB livres. Apague arquivos que não usa, esvazie o Lixo e rode de novo."

# f. internet: (a) conectividade, separando portal cativo (página da Apple sem "Success")
PROBE="$(curl -sf --max-time 15 http://captive.apple.com/hotspot-detect.html)" ||
  die "sem acesso à internet. Conecte o Mac à internet (Wi-Fi ou cabo) e rode de novo."
case "$PROBE" in
  *Success*) ;;
  *) die "a rede pede login (Wi-Fi de hotel, empresa ou portal). Use outra rede ou o hotspot do celular e rode de novo." ;;
esac
# (b) HEAD no próprio instalador (a raiz dos CDNs responde 400)
curl -sfI --max-time 15 -o /dev/null "$URL" ||
  die "a internet funciona, mas o instalador da Microsoft não respondeu (pode ter mudado de endereço). Tente mais tarde; se repetir, fale com o suporte."

TMP="$(mktemp -d /private/var/tmp/office.XXXXXX)" || die "não foi possível criar a pasta temporária. Reinicie o Mac e rode de novo."
trap 'rm -rf "${TMP:?}"' EXIT
PKG="$TMP/office.pkg"

echo ">> Baixando o Office da Microsoft (cerca de 3 GB; pode demorar)..."
# speed-limit/time: aborta se a internet cair em vez de ficar parado para sempre
curl -fL --retry 3 --speed-limit 1000 --speed-time 60 --progress-bar -o "$PKG" "$URL" ||
  die "o download falhou (a internet caiu?). Confira a conexão e rode de novo."

SIG="$(pkgutil --check-signature "$PKG" 2>&1 || true)"
case "$SIG" in
  *"Status: signed"*"Developer ID Installer: Microsoft Corporation"*) ;;
  *) die "o arquivo baixado não é o oficial da Microsoft. Rode de novo." ;;
esac

echo ">> Instalando (10 minutos ou mais; não feche esta janela)..."
caffeinate -i installer -pkg "$PKG" -target / ||
  die "a instalação falhou. Rode de novo; se repetir, mostre ao técnico o arquivo /var/log/install.log."

for app in "Microsoft Word" "Microsoft Excel" "Microsoft PowerPoint"; do
  [ -d "/Applications/$app.app" ] ||
    die "$app não apareceu em Aplicativos. Rode de novo; se repetir, mostre ao técnico o arquivo /var/log/install.log."
done

echo "Concluído. Abra o Word e entre com a conta Microsoft da sua licença."
}; exit
