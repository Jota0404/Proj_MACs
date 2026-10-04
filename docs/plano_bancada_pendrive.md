# Plano de Bancada — `scripts/build_pendrive.sh`

Oct 3, 2026 · @Jota

Valida o pendrive multi-macOS **em Mac real e Bash 3.2**, o que ainda não foi feito: travas, gravação, boot e instalação offline. É a prioridade atual; o plano do Office (`docs/plano_bancada.md`) vem a seguir.

## Contrato do script

| Código | Significado | O que o técnico faz |
| --- | --- | --- |
| 0 | Instaladores gravados, `KIT` copiada, resumo impresso (ou, em `--dry-run`, só os comandos impressos) | Conferir o resumo e o `VERSION` |
| 1 | Qualquer trava ou falha; a causa está na linha `ERRO:` do console | Corrigir o que a mensagem diz e rodar de novo |

Travas, por ordem e **antes de apagar qualquer coisa**: `sudo` (exceto `--dry-run`) → argumento `diskN` → disco externo → não é o disco de `/` → ≥ 120 GB → pelo menos um instalador em `/Applications` → digitar `SIM`.

## Antes de começar

1. **Mac de bancada:** anote modelo (`sysctl hw.model`) e macOS (`sw_vers`). O briefing recomenda um MacBook Pro 13" 2018 ou 2019.
2. **Pendrive:** 128 GB, USB 3.0, ligado direto na porta (sem hub). Tudo nele será apagado.
3. **Instaladores** em `/Applications`, baixados com os comandos do briefing (seção 3):
   - `softwareupdate --list-full-installers`
   - `softwareupdate --fetch-full-installer --full-installer-version <versão>` (a mais recente de cada linha)
   - High Sierra e Mojave: pelos links da App Store na página da Apple.
4. **Anote quais versões não foi possível baixar** ("update not found" = indisponível para este Mac). Essas partições ficam vazias e entram como "pulados" no `VERSION`.
5. Descubra o disco do pendrive com `diskutil list external` (ex.: `disk4`). Guarde o código (`echo $?`) e a última linha `ERRO:` de cada tentativa.

## Cenário 0: travas (nada é apagado)

Use sempre `--dry-run` em 0A–0D: as travas são as mesmas e, se alguma falhar, nada é executado. **Se 0B, 0C ou 0D chegarem ao pedido `Digite SIM`, responda `nao` e reprove.**

| # | Como provocar | Esperado |
| --- | --- | --- |
| 0A | `bash scripts/build_pendrive.sh diskN --dry-run` com o pendrive; digitar `SIM` | Lista "Serão gravados"/"Faltam" igual à anotação do passo 4; `diskutil list` do pendrive; linhas `[dry-run] diskutil partitionDisk ...`, `createinstallmedia ...`, dois `ditto ...` e `chmod 755 ...`; nada é apagado · código 0 |
| 0B | `... disk0 --dry-run` | `ERRO: disk0 não é externo (...)` · código 1 |
| 0C | `... disk4s1 --dry-run` (qualquer `diskNsM`) | `ERRO: argumento inválido 'disk4s1'. uso: ...` · código 1 |
| 0D | HD/SSD externo < 120 GB: `... diskN --dry-run` | `ERRO: diskN tem <N> bytes; mínimo 120000000000.` · código 1 |
| 0E | Sem `--dry-run`: `sudo bash scripts/build_pendrive.sh diskN` com o pendrive; responder `nao` | `ERRO: cancelado (não foi digitado SIM).` · código 1; `diskutil list diskN` igual ao de antes |

## Cenário 1: gravação real

1. `sudo bash scripts/build_pendrive.sh diskN`, digitar `SIM`. Cronometre do `SIM` até ao resumo. Esperado: código 0.
2. `diskutil list diskN`: registre o tamanho de cada partição. As gravadas aparecem como `Install macOS <versão>`; `KIT` mantém o nome.
3. `cat /Volumes/KIT/VERSION`: data de hoje, `git:` com o commit (ou `sem-git`), "gravados" igual ao que foi pedido e "pulados" igual à anotação do passo 4.
4. `ls /Volumes/KIT /Volumes/KIT/scripts`: a KIT tem **exatamente** `Instalar Office.command`, `scripts/install_office.sh` e `VERSION` (sem `assets/`; as pastas ocultas do macOS, como `.fseventsd`, não contam). `ls -l` mostra `-rwxr-xr-x` no `.command` e no `install_office.sh`.

**Reprova se:** a partição do Sequoia (`SEQ`/`Install macOS Sequoia`) tiver **menos de 17 GB**; algum instalador encontrado não foi gravado; a KIT tiver qualquer coisa além desses três ou um deles sem permissão de execução; ou o `VERSION` não bater com o resumo.

## Cenário 2: boot

Em cada Mac: pendrive direto na porta, carregador ligado, segurar **Option** ao ligar.

1. **2A:** o pendrive aparece no seletor de arranque, com uma entrada por versão gravada?
2. **2B:** escolhida a versão máxima do Mac (tabela da seção 3 do briefing), chega ao menu do instalador (Utilitários do macOS)?

Matriz mínima:

| Mac | Versão a arrancar | Atenção |
| --- | --- | --- |
| 1 · MacBook 2010–2012 | High Sierra ou Catalina | — |
| 2 · MacBook 2013–2017 | Big Sur, Monterey ou Ventura | — |
| 3 · MacBook com T2 2018–2019 | Sonoma ou Sequoia | Faça antes a **Fase 2 do briefing** (Segurança Média + mídia externa permitida) |

**Reprova se:** o pendrive não aparecer, aparecer com um círculo cortado ou não chegar ao instalador.

## Cenário 3: instalação offline completa

1. Wi-Fi desligado e sem cabo de rede, do início ao fim.
2. Siga a **Rota A do briefing** (Fase 3, passos 9–12): data corrigida no Terminal, disco apagado, instalação, até ao **Assistente de Configuração**.
3. Registre o tempo total e **qualquer pedido de rede** (tela, passo e mensagem).

**Esperado:** chega ao Assistente sem rede. No Mac com T2, a tela **Ativar Mac** exige internet (já prevista na Fase 4 do briefing): registre-a, não reprova.

**Reprova se:** a instalação parar ou falhar por falta de rede antes do Assistente.

## Registro de aprovação

| Cenário | Mac de bancada | Mac 1 (2010–2012) | Mac 2 (2013–2017) | Mac 3 (T2) |
| --- | --- | --- | --- | --- |
| 0A–0E travas |  | — | — | — |
| 1 gravação (SEQ ≥ 17 GB) |  | — | — | — |
| 2A pendrive aparece | — |  |  |  |
| 2B chega ao instalador | — |  |  |  |
| 3 instalação offline (tempo / pedidos de rede) | — |  |  |  |

Em cada célula: ✅/❌, data e observação. **Só criar a tag `v0.1` com todas as células aprovadas.**
