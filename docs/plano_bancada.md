# Plano de Bancada — Office (`Instalar Office.command` + `scripts/install_office.sh`)

Oct 3, 2026 · @Jota

Valida a instalação do Office **em Mac real e Bash 3.2**, o que ainda não foi feito. O script não leva Office no pendrive: baixa o instalador oficial da Microsoft conforme o macOS e confere a assinatura (`docs/decisoes.md`, ADR-001). O cliente roda só o lançador (ADR-002). Fazer depois do `docs/plano_bancada_pendrive.md`.

## Contrato do script

| Código | Significado | O lançador mostra |
| --- | --- | --- |
| 0 | Office instalado; Word, Excel e PowerPoint em Aplicativos | `Pronto!` |
| 1 | Qualquer trava ou falha; a causa e o que fazer estão na linha `ERRO:` | `Algo deu errado: leia a mensagem ERRO acima e tente de novo.` |
| 2 | macOS 11 ou anterior: o Office atual não roda | `Este Mac é antigo demais para o Office atual.` |

Travas, por ordem: `sudo` → macOS (10.x/11 = código 2; 12 → 16.88, 13 → 16.101, 14+ → 16.113.3) → carregador → ano do relógio ≥ 2026 → 15 GB livres em `/` → internet. Depois: download → assinatura `Developer ID Installer: Microsoft Corporation` → `installer` → Word, Excel e PowerPoint em `/Applications`.

O script não tem log próprio: o detalhe da instalação fica em `/var/log/install.log`.

## Antes de começar

1. Pendrive gerado pelo `build_pendrive.sh` (Cenário 1 do plano do pendrive aprovado): a KIT tem `Instalar Office.command`, `scripts/install_office.sh` e `VERSION`.
2. Macs sem Office (sem apps Microsoft em `/Applications`), usuário administrador. O ideal é um Mac com macOS 12, um com 13 e um com 14 ou mais novo; anote quais houve na bancada.
3. Uma licença real do Office (conta Microsoft 365 ou Office 2019/2021 vinculado a uma conta) para o Cenário 3.
4. Internet boa (o download tem cerca de 3 GB) e um hotspot para provocar a queda do Cenário 2.
5. Segunda janela do Terminal: `tail -f /var/log/install.log`. Guarde o código, o tempo e a última linha `ERRO:` de cada tentativa (o código aparece como a mensagem final do lançador).

Comando padrão: dois cliques em `Instalar Office.command` na KIT.

## Cenário 0: travas (nada é instalado)

| # | Como provocar | Esperado |
| --- | --- | --- |
| 0A | No Terminal, sem `sudo`: `bash /Volumes/KIT/scripts/install_office.sh` | `ERRO: o instalador precisa da senha do Mac...` · código 1 |
| 0B | Mac com macOS 11 ou anterior, pelo lançador | `ERRO: este Mac tem o macOS 11...` e `Este Mac é antigo demais...` · código 2 |
| 0C | Carregador desligado | `ERRO: ligue o carregador na tomada e rode de novo.` · código 1 |
| 0D | Ajustes > Data e Hora: desligar o automático e pôr 01/01/2001 (**voltar a data depois**) | `ERRO: o relógio do Mac está no ano 2001. Acerte a data em...` · código 1 |
| 0E | Wi-Fi desligado e sem cabo | `ERRO: sem acesso à internet. Conecte o Mac à internet (Wi-Fi ou cabo)...` · código 1 |
| 0F | Opcional, só se houver um Mac com menos de 15 GB livres | `ERRO: o Mac tem menos de 15 GB livres...` · código 1 |
| 0G | Rede com portal cativo (Wi-Fi de hotel, café ou empresa) conectada **sem** fazer o login | `ERRO: a rede pede login (Wi-Fi de hotel, empresa ou portal). Use outra rede ou o hotspot do celular e rode de novo.` · código 1 |

**Reprova se:** qualquer caso começar o download (`>> Baixando`), ou a mensagem não disser o que fazer.

## Cenário 1: instalação pelo lançador

Em cada macOS disponível (12, 13, 14+): dois cliques em `Instalar Office.command`, digitar a senha, esperar.

**Esperado:** barra de progresso do download, `>> Instalando`, `Concluído...` e `Pronto!` (código 0). Word, Excel e PowerPoint abrem; Word > Sobre o Word mostra 16.88 (macOS 12), 16.101 (macOS 13) ou 16.113 (14+). Registre o tempo de download e o de instalação.

**Reprova se:** o macOS bloquear a abertura do `.command` (ex.: "desenvolvedor não identificado"); a versão não bater com o macOS; ou algum dos três apps faltar.

## Cenário 2: internet cai durante o download

1. **2A.** Com a barra de progresso em cerca de 30 %, desligue o Wi-Fi.
2. **2B.** Religue o Wi-Fi e rode o lançador de novo.

**Esperado:** em 2A, `ERRO: o download falhou (a internet caiu?)...` e código 1 em poucos minutos, sem sobrar `/private/var/tmp/office.*`. Em 2B, `Pronto!` (código 0).

**Reprova se:** 2A ficar parado mais de 5 min sem sair, ou 2B não concluir.

## Cenário 3: ativação (o que decide)

1. Abra o Word e entre com a conta Microsoft da licença real.
2. No **Word** e no **Excel**: criar um documento novo, escrever, **salvar**, fechar, reabrir, **editar** e salvar de novo.

**Esperado:** tudo funciona, sem aviso de "funcionalidade reduzida" (o modo em que o Office só abre e imprime).

**Reprova se:** qualquer passo de edição ou gravação for bloqueado. Sem este cenário aprovado, o Office não vai para venda.

## Cenário 4: usuário leigo

Uma pessoa sem conhecimento técnico recebe o pendrive e uma única instrução: "dê dois cliques em `Instalar Office.command` na KIT". Ninguém ajuda; o técnico só observa.

**Anote:** cada dúvida, cada lugar onde a pessoa travou (achar a KIT, a senha que não aparece, mensagens) e quanto tempo levou.

**Reprova se:** a pessoa precisar de ajuda para concluir. Cada dúvida vira ajuste de mensagem no lançador ou no script.

## Registro de aprovação

| Cenário | Mac macOS ≤ 11 | Mac macOS 12 | Mac macOS 13 | Mac macOS 14+ |
| --- | --- | --- | --- | --- |
| 0A, 0C–0G travas | — |  |  |  |
| 0B macOS sem suporte (código 2) |  | — | — | — |
| 1 instalação (versão / tempo) | — |  |  |  |
| 2A–2B queda de internet | — |  |  |  |
| 3 ativação e edição | — |  |  |  |
| 4 usuário leigo | — |  |  |  |

Em cada célula: ✅/❌, data e observação. Só libere o Office para venda com todas as linhas aprovadas nos macOS que houver na bancada (pelo menos um).
