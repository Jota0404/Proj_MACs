# Project Overview: Auto-MACs
- **Objetivo:** Kit de formatação offline e automação pós-instalação para MacBooks legados (≤2019).
- **Stack Tecnológica:** Scripts Bash (`/scripts`), documentação em Markdown (`/docs`) e pacotes utilitários (`/assets`).

## Estrutura do Repositório
```
Auto-MACs/
├── CLAUDE.md                  # Contexto e regras para agentes
├── README.md                  # (placeholder vazio)
├── docs/
│   ├── briefing.md            # Briefing técnico (Recovery/Wi-Fi, bancada, pendrive)
│   └── plano_bancada.md       # Testes em Mac real do install_office.sh
├── scripts/
│   └── install_office.sh      # Script oficial: instala os .pkg de assets/office/
└── assets/
    └── office/                # Pacotes .pkg do Office, uma versão de macOS por pendrive (não versionados)
```

**Estado atual:** script oficial pronto, falta validá-lo em Mac real (ver `docs/plano_bancada.md`).

# Regras de Desenvolvimento e Segurança (Bash)
1. **Guard Clauses Obrigatórias:** Todos os scripts devem verificar antes de executar ações críticas:
   - Presença e montagem correta do volume/pendrive (`/Volumes/...`).
   - Espaço livre em disco e nível de bateria (quando aplicável).
   - Existência física dos ficheiros `.pkg` antes de iniciar comandos de instalação (`installer`).
2. **Tratamento de Erros:** Utilizar sempre `set -e` e `set -u` no topo dos scripts. Proteger variáveis de caminho contra valores nulos (ex: `"${VAR:?mensagem}"`) e citar sempre as expansões (`"$VAR"`).
3. **Validação de Sintaxe:** Antes de finalizar qualquer script, executar testes estáticos de sintaxe (ex: `bash -n`; `shellcheck` quando disponível).

## Notas de Compatibilidade
- **Bash 3.2:** macOS legado traz Bash 3.2 por omissão — evitar funcionalidades de Bash 4+ (arrays associativos, `mapfile`/`readarray`, `${var,,}`, `&>>`).
- **Finais de linha LF:** o repositório é editado em Windows; os scripts `.sh` têm de ser gravados com LF (CRLF parte o shebang e os comandos no macOS).
- **Ferramentas nativas macOS:** preferir `diskutil`, `installer`, `pmset`, `df`, `sw_vers` — não assumir utilitários GNU nem Homebrew (ambiente offline).
- **Privilégios:** comandos `installer` exigem `sudo`; verificar `EUID` no início em vez de falhar a meio.
