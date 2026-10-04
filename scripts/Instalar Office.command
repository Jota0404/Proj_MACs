#!/bin/bash
# Instalar Office.command - lançador de dois cliques para o cliente (fica na raiz da KIT,
# ao lado de scripts/). Códigos do install_office.sh: 0 ok · 1 erro · 2 macOS sem suporte.
set -eu

cd "$(dirname "$0")"
clear
cat <<'EOF'
Este programa vai instalar o Microsoft Office (Word, Excel e PowerPoint).

Antes de começar: o Mac precisa estar com INTERNET e com o CARREGADOR ligado.
Ele vai pedir a SENHA DO MAC. Enquanto você digita, a senha NÃO aparece: é normal.
Digite a senha e aperte Enter.
Não feche esta janela até aparecer "Pronto".

EOF

rc=0
sudo bash ./scripts/install_office.sh || rc=$?

echo
case "$rc" in
  0) echo "Pronto!" ;;
  2) echo "Este Mac é antigo demais para o Office atual." ;;
  *) echo "Algo deu errado: leia a mensagem ERRO acima e tente de novo." ;;
esac
echo
printf 'Pressione Enter para fechar '
read -r _ || true
