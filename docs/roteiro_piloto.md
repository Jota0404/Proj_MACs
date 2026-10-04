# Roteiro do Piloto — Macs do cliente

Oct 3, 2026 · @Jota

Checklist para usar **na frente do cliente**. É no piloto que se executam os dois planos de bancada, com os Macs do próprio cliente (`docs/decisoes.md`, ADR-005). Marque cada caixa ao concluir.

## Fase 0 — Inventário (antes de marcar a visita)

Preencha com o cliente, por mensagem ou por telefone. Para o macOS-alvo, use a tabela do passo 2 do `docs/guia_cliente.md`.

| Mac | Modelo / ano | Armazenamento (SSD/HD, GB) | Estado (liga? bateria? teclado?) | Conta Apple do dono (sai do iCloud?) | macOS-alvo | Office (sim/não) | No piloto? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A |  |  |  |  |  |  |  |
| B |  |  |  |  |  |  |  |
| C |  |  |  |  |  |  |  |

- [ ] **Licença do Office:** que tipo (Microsoft 365, 2019, 2021), em que conta e quantas instalações permite. Office só em macOS 12+.
- [ ] **Rede:** existe Wi-Fi em 2,4 GHz com WPA2 (ou cabo de rede)? Se não, o hotspot do celular resolve.
- [ ] **Regra:** Mac com **Bloqueio de Ativação** (Apple ID de outra pessoa) ou **cadeado de firmware** fica **FORA** do piloto. Sem exceção nem tentativa de contorno.

## O que levar

- [ ] Pendrive de **128 GB** USB 3.0 (será apagado)
- [ ] 2º pendrive com a **pasta do repositório** (cópia do clone git, não um zip baixado)
- [ ] Adaptadores: USB-C → USB-A, USB-C → Ethernet, Thunderbolt 2 → Ethernet (conforme o inventário)
- [ ] Celular com hotspot configurável em 2,4 GHz/WPA2 (no iPhone: "Maximizar Compatibilidade")
- [ ] Termo do piloto impresso (`docs/termo_piloto.md`), uma via por Mac ou uma com a tabela completa
- [ ] `docs/guia_cliente.md` (impresso ou no celular) para seguir e tirar as `[FOTO-NN]`
- [ ] Os dois planos impressos para preencher: `docs/plano_bancada_pendrive.md` e `docs/plano_bancada.md`

## Fase 1 — Mac de montagem

- [ ] **Termo assinado** antes de tocar em qualquer disco.
- [ ] Escolher o **Mac mais novo que funcione**. Ele monta o pendrive, e o `softwareupdate` só baixa as versões que esse Mac suporta: quanto mais novo, mais versões.
- [ ] **Se nenhum Mac funcionar:** recuperar um pela **Rota B do briefing** (Fase 3, passos 13–16):
  1. **Antes de reinstalar:** Apple Diagnostics: ligar segurando **D** (**Option + D** se não abrir), anotar o código ou "sem problemas" no termo. Erro de disco ou memória: o Mac sai do piloto ou segue só com o cliente ciente e de acordo, anotado no termo.
  2. Cabo de rede ou hotspot do celular em 2,4 GHz/WPA2. Nunca rede de hotel, empresa ou WPA3.
  3. Ligar com **Shift + Option + Cmd + R** primeiro (sistema de fábrica, mais compatível); se falhar, **Option + Cmd + R**.
  4. Antes de "Reinstalar macOS": Utilitários → Terminal → acertar a data (`date MMDDhhmmAAAA`).
  5. Erro -2003F ou servidor não contatado: trocar de rede e tentar a outra combinação de teclas.

**Critério de sucesso:** o Mac arranca no macOS com uma conta de administrador, tem internet e o espaço livre da Fase 2. O ideal é macOS 10.15 (Catalina) ou mais novo, porque o `softwareupdate --fetch-full-installer` não existe antes disso. Num sistema mais antigo, atualizar pela Atualização de Software ou baixar pelos links da App Store.

**Se falhar:** pedir emprestado o **Mac de um conhecido** (Mac **Intel** com macOS 10.15+ e espaço; um Mac Apple Silicon não baixa as versões antigas) só para a Fase 2. Sem Mac de montagem, o piloto para aqui; anote o motivo.

- [ ] Anotar: modelo, macOS (`sw_vers`), espaço livre, tempo gasto.

## Fase 2 — Montagem do pendrive

- [ ] Copiar a pasta do repositório do 2º pendrive para `~/Proj_MACs` (Finder ou `ditto /Volumes/<PENDRIVE>/Proj_MACs ~/Proj_MACs`).
- [ ] **Espaço livre:** soma dos instaladores que serão baixados + 20 GB. Conferir em Sobre Este Mac → Armazenamento ou `df -h /`. Referência por instalador: de 5 GB (High Sierra) a cerca de 15 GB (Sequoia).
- [ ] Baixar **só as versões do inventário** (comandos da seção 3 do briefing):
  - `softwareupdate --list-full-installers`
  - `softwareupdate --fetch-full-installer --full-installer-version <versão>`
  - High Sierra e Mojave: links da App Store na página da Apple.
  - Anotar o que **não** foi possível baixar e para que Mac isso faz falta.
- [ ] `docs/plano_bancada_pendrive.md` → **Cenário 0** (travas, com `--dry-run`) e **Cenário 1** (gravação real). Preencher as tabelas do plano.

Comando: `cd ~/Proj_MACs && sudo bash scripts/build_pendrive.sh diskN` (o `diskN` sai de `diskutil list external`).

## Fase 3 — Instalação do macOS (por Mac)

Para cada Mac marcado "No piloto? sim". O Mac de montagem vai **por último** (só ele pode refazer o pendrive).

- [ ] **Antes de apagar qualquer disco:** Apple Diagnostics: ligar segurando **D** (**Option + D** se não abrir), anotar o código ou "sem problemas" no termo. Erro de disco ou memória: o Mac sai do piloto ou segue só com o cliente ciente e de acordo, anotado no termo.
- [ ] `docs/plano_bancada_pendrive.md` → **Cenário 2** (boot) e **Cenário 3** (instalação offline).
- [ ] Seguir **o `docs/guia_cliente.md` ao pé da letra**, como se fosse o cliente. Tudo o que não bater com a tela vai para as notas.
- [ ] Tirar as **`[FOTO-NN]`** do guia (no celular, nome do arquivo = número da foto).
- [ ] Conferir os itens marcados **"A CONFIRMAR NA BANCADA"** no guia e anotar o que aparece de verdade.
- [ ] Mac com T2 (2018–2019): passo 3 do guia **antes** de apagar o disco.

| Mac | Apple Diagnostics | Boot pelo pendrive | Instalação offline | Tempo total | Pedidos de rede | Fotos tiradas |
| --- | --- | --- | --- | --- | --- | --- |
| A |  |  |  |  |  |  |
| B |  |  |  |  |  |  |
| C |  |  |  |  |  |  |

## Fase 4 — Office (Macs com macOS 12+)

- [ ] `docs/plano_bancada.md` nos Macs com macOS 12 ou mais novo, com a licença do cliente.
- [ ] **Cenário 3 obrigatório:** entrar com a conta, **criar, editar e salvar** no Word e no Excel. Sem isto, o Office não está validado.
- [ ] **Cenário 4 com o próprio cliente:** ele opera sozinho, só pelo guia e pelo `Instalar Office.command`. O técnico observa e anota cada dúvida, sem ajudar.

## Fase 5 — Depois do piloto (em casa)

- [ ] Transformar o pendrive aprovado em **imagem mestra** e copiá-la no Windows (procedimento ainda por escrever).

## Fechamento

- [ ] Tabelas preenchidas: inventário, Fase 3, e os registros de aprovação dos dois planos.
- [ ] Todas as linhas **`ERRO:`** que apareceram, com o Mac e o momento.
- [ ] Resultado de cada item **"A CONFIRMAR NA BANCADA"** do guia.
- [ ] Tempos: downloads, gravação do pendrive, instalação por Mac, Office.
- [ ] Se o cliente quiser e o Mac de montagem não foi formatado: apagar os instaladores (`/Applications/Install macOS *.app`) e a pasta `~/Proj_MACs`.

## Sugestão: 2 visitas

| Visita | Fases | Observação |
| --- | --- | --- |
| V1 | 0 (conferir), 1 e 2 | Os downloads levam horas: deixar o Mac de montagem baixando e voltar para gravar o pendrive. |
| V2 | 3 e 4 | Cerca de 1h30 por Mac, mais o Office e o teste com o cliente. |
