# Project Overview: Auto-MACs
- **Objetivo:** Kit de formatação offline e automação pós-instalação para MacBooks legados (≤2019).
- **Stack Tecnológica:** Scripts Bash (`/scripts`), documentação em Markdown (`/docs`).

## Estrutura do Repositório
```
Auto-MACs/
├── CLAUDE.md                  # Contexto e regras para agentes
├── README.md                  # Visão geral e como usar
├── LICENSE                    # Proprietário, E.C.H.O Tech (ADR-004)
├── .gitignore                 # *.pkg, .DS_Store, ._*
├── .gitattributes             # *.sh e *.command sempre com LF
├── docs/
│   ├── briefing.md            # Briefing técnico (Recovery/Wi-Fi, bancada, pendrive)
│   ├── decisoes.md            # ADRs (Office online, cliente leigo, pendrive único, licença)
│   ├── plano_bancada_pendrive.md  # Testes em Mac real do build_pendrive.sh (travas, gravação, boot, offline)
│   ├── plano_bancada.md       # Testes em Mac real do Office (travas, instalação, ativação, leigo)
│   └── archive/               # Históricos (instalar_office.sh, auditoria v2) — não reutilizar
└── scripts/
    ├── build_pendrive.sh      # Bancada: monta o pendrive multi-macOS + partição KIT
    ├── Instalar Office.command  # Cliente: lançador de dois cliques (vai para a raiz da KIT)
    └── install_office.sh      # Cliente: baixa da Microsoft e instala o Office conforme o macOS
```

**Estado atual:** scripts oficiais `build_pendrive.sh` (bancada) e `install_office.sh` + `Instalar Office.command` (Mac do cliente), **nenhum validado em Mac real**. Prioridade: validar o pendrive de macOS (`docs/plano_bancada_pendrive.md`); depois o Office (`docs/plano_bancada.md`, o Cenário 3 de ativação decide). O Office não é distribuído no kit: é baixado da Microsoft e só roda em macOS 12+ (`docs/decisoes.md`).

# Regras de Desenvolvimento e Segurança (Bash)
1. **Guard Clauses Obrigatórias:** Todos os scripts devem verificar antes de executar ações críticas:
   - Presença e montagem correta do volume/pendrive (`/Volumes/...`).
   - Espaço livre em disco e nível de bateria (quando aplicável).
   - Existência física dos ficheiros `.pkg` antes de iniciar comandos de instalação (`installer`).
2. **Tratamento de Erros:** Utilizar sempre `set -e` e `set -u` no topo dos scripts. Proteger variáveis de caminho contra valores nulos (ex: `"${VAR:?mensagem}"`) e citar sempre as expansões (`"$VAR"`).
3. **Validação de Sintaxe:** Antes de finalizar qualquer script, executar testes estáticos de sintaxe (ex: `bash -n`; `shellcheck` quando disponível).

## Notas de Compatibilidade
- **Bash 3.2:** macOS legado traz Bash 3.2 por omissão — evitar funcionalidades de Bash 4+ (arrays associativos, `mapfile`/`readarray`, `${var,,}`, `&>>`).
- **Finais de linha LF:** o repositório é editado em Windows; os scripts `.sh` e `.command` têm de ser gravados com LF (CRLF parte o shebang e os comandos no macOS).
- **Ferramentas nativas macOS:** preferir `diskutil`, `installer`, `pmset`, `df`, `sw_vers` — não assumir utilitários GNU nem Homebrew (ambiente offline). **Exceção:** o `install_office.sh` precisa de internet para baixar o Office da Microsoft com `curl` (ADR-001).
- **Privilégios:** comandos `installer` exigem `sudo`; verificar `EUID` no início em vez de falhar a meio.
