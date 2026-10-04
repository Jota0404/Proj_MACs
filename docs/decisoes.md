# Decisões (ADR)

Oct 3, 2026 · @Jota

Formato curto: decisão / motivo / rejeitado / consequência. Uma decisão nova revoga a antiga explicitamente.

## ADR-001 — Office baixado da Microsoft na hora, nunca distribuído

- **Decisão:** o kit não leva nenhum `.pkg` da Microsoft. O `scripts/install_office.sh` baixa o instalador oficial do CDN da Microsoft no momento da instalação e confere a assinatura antes de instalar. O cliente ativa com a própria licença.
- **Motivo:** a licença do Office proíbe copiar ou publicar o software. Desde 13/07/2026, Office for Mac abaixo da 16.83 fica em "reduced functionality mode" (abre e imprime, não edita nem salva), inclusive Office 2019/2021 perpétuos, e a 16.83 exige macOS 12+ ([Microsoft](https://support.microsoft.com/en-us/topic/f418ae5d-bb5f-4078-b3d9-9340f5dd084e)). Instalar offline não traz ganho: a ativação exige internet de qualquer forma.
- **Mapa** (URLs em [update history](https://learn.microsoft.com/officeupdates/update-history-office-for-mac)):

  | macOS | Office |
  | --- | --- |
  | 10.13–11 | sem Office (código 2) |
  | 12 | 16.88 |
  | 13 | 16.101 |
  | 14+ | 16.113.3 (atual) |

- **Rejeitado:** `.pkg` em `assets/office/` no pendrive (licença; e versões antigas ficam em modo reduzido); Office offline.
- **Consequência:** `assets/` sai do repositório. Instalar o Office exige internet e macOS 12+ (Macs de 2015 em diante). As URLs vão ficando velhas: revisar o mapa a cada versão nova do Office. O host atual do CDN é `res.public.onecdn.static.microsoft` (TLD `.microsoft`, sem `.com`).

## ADR-002 — O operador é o cliente leigo

- **Decisão:** tudo o que o cliente executa tem um lançador de duplo clique (`Instalar Office.command`) e mensagens em pt-BR simples; cada erro diz o que fazer.
- **Motivo:** o produto é a autonomia do cliente (Kit Autonomia, briefing seção 4); um Terminal com comandos não serve para quem nunca o abriu.
- **Rejeitado:** instruções de Terminal para o cliente.
- **Consequência:** `build_pendrive.sh` é só da bancada e não vai para o pendrive. O teste com usuário leigo entra no plano de bancada.

## ADR-003 — Um pendrive para todos os Macs

- **Decisão:** o macOS fica nas partições do pendrive; o Office é escolhido em tempo de execução pela versão do macOS do Mac do cliente.
- **Motivo:** um único produto físico para estoque e venda.
- **Rejeitado:** "um pendrive por versão de macOS" (**revogado**).
- **Consequência:** a KIT leva só `Instalar Office.command`, `scripts/install_office.sh` e `VERSION`.

## ADR-004 — Repositório privado e proprietário

- **Decisão:** código proprietário da E.C.H.O Tech, todos os direitos reservados (`LICENSE`).
- **Motivo:** o kit é produto comercial.
- **Rejeitado:** licença aberta.
- **Consequência:** a visibilidade privada é configurada pelo Jota no GitHub; o repositório só registra o `LICENSE`.

## ADR-005 — Piloto assistido nos Macs do cliente

- **Decisão:** sem Mac de bancada próprio na v0.1. O Mac de montagem é um Mac do cliente (se nenhum funcionar, recuperado pela Rota B do briefing). O pendrive do piloto leva só os instaladores dos modelos do cliente. Depois de aprovado, o pendrive vira imagem mestra copiada no Windows.
- **Motivo:** `createinstallmedia` e `diskutil` só existem no macOS; os Macs do cliente são o próprio hardware-alvo.
- **Rejeitado:** Mac na nuvem (sem USB); VM/Hackintosh (licença da Apple); comprar um Mac antes da primeira venda.
- **Consequência:** os planos de bancada passam a ser executados no piloto (`docs/roteiro_piloto.md`); "Mac de bancada" passa a "Mac de montagem".
