# Plano de Bancada — `scripts/install_office.sh`

Oct 3, 2026 · @Jota

Substitui o plano da `instalar_office_v2.sh` (que não está no repositório). Testa o script oficial de 43 linhas **em Mac real e Bash 3.2**, o que ainda não foi feito.

## Contrato do script

| Código | Significado | O que o técnico faz |
| --- | --- | --- |
| 0 | Todos os `.pkg` de `assets/office/` instalados | Abrir o Word e ativar com a licença do cliente |
| 1 | Qualquer trava ou falha; a causa está na linha `ERRO:` do console | Corrigir o que a mensagem diz e rodar de novo |

Travas, por ordem: `sudo` → kit em `/Volumes/...` → pasta `assets/office/` → carregador → 10 GB livres em `/` → pelo menos um `.pkg` (ignora `._*`) → `installer` de cada `.pkg`.

O script não tem log próprio: o detalhe da instalação fica em `/var/log/install.log`.

## Antes de começar

1. Pendrive exatamente como será vendido: `scripts/install_office.sh` e `assets/office/*.pkg` **de uma única versão de macOS** (o script instala todos os `.pkg` da pasta).
2. Na bancada, confira a assinatura de cada `.pkg`: `pkgutil --check-signature assets/office/*.pkg` deve mostrar `Microsoft Corporation`.
3. Mac sem Office (sem os apps Microsoft em `/Applications`), relógio correto, usuário administrador.
4. Segunda janela do Terminal: `tail -f /var/log/install.log`. Guarde o código (`echo $?`), o tempo e a última linha `ERRO:` de cada tentativa.
5. Repita tudo em **dois Macs**: um com HD mecânico e USB 2.0, outro com SSD.

Comando padrão: `sudo bash /Volumes/<PENDRIVE>/scripts/install_office.sh`

## Cenário 0: travas (rápido, sem instalar nada)

| # | Como provocar | Esperado |
| --- | --- | --- |
| 0A | Rodar sem `sudo` | `ERRO: execute com sudo.` · código 1 |
| 0B | Copiar o kit para a Mesa e rodar de lá | `ERRO: o kit tem de rodar a partir de um volume em /Volumes/` · código 1 |
| 0C | Deixar em `assets/office/` só um `._x.pkg` (ou nada) | `ERRO: nenhum .pkg em ...` · código 1 |
| 0D | Rodar no Terminal do Recovery | Tem de abortar com código 1 antes de instalar (carregador, espaço ou outra trava). **Se chegar a `>> Instalando`, reprova:** `-target /` apontaria para o disco do Recovery. |

## Cenário 1: pendrive removido

1. **1A, durante a instalação.** Quando aparecer `>> Instalando`, puxe o pendrive.
2. **1B, recuperação.** Reconecte (direto na porta, sem hub) e rode de novo.

**Esperado:** em 1A, `ERRO: installer falhou em ...` e código 1, sem travar. Em 1B, código 0 e Word, Excel, PowerPoint, Outlook e OneNote abrindo.

**Reprova se:** o script ou o `installer` travar mais de 5 min sem sair, aparecer erro de sintaxe ou "unexpected EOF", ou a nova execução em 1B não deixar os cinco apps funcionando.

## Cenário 2: sem rede

1. **2A, sem rede desde o início.** Wi-Fi desligado, sem cabo.
2. **2B, Wi-Fi sem internet.** Hotspot do celular com os dados desligados. Cronometre do `>> Instalando` até ao fim.
3. **2C, queda a meio.** Com Wi-Fi funcionando, desligue-o assim que aparecer `>> Instalando`.

**Esperado:** código 0 e os cinco apps nos três casos, com o tempo de 2B parecido com o de 2A. A ativação da licença exige internet depois; avise o cliente.

**Reprova se:** qualquer caso falhar por falta de rede, ou 2B demorar muito mais que 2A (sinal de que o `installer` espera pela rede).

## Cenário 3: energia

1. **3A, na bateria.** Tire o carregador e rode.
2. **3B, carregador removido a meio.** Com o carregador, comece a instalar e tire-o quando aparecer `>> Instalando`. Não mexa no Mac até ao fim.
3. **3C, opcional e destrutivo, só em Mac de bancada.** Segure o botão de ligar durante a instalação; religue e rode de novo.

**Esperado:** 3A sai com `ERRO: ligue o carregador.` e código 1 antes de instalar. Em 3B a instalação termina (código 0) sem o Mac suspender. Em 3C o Mac liga e a nova execução recupera os cinco apps.

**Reprova se:** 3A começar a instalar, ou o Mac suspender em 3B. Se suspender, a correção é prefixar o `installer` com `caffeinate -i`.

## Registro de aprovação

| Cenário | Mac 1 (HD, USB 2.0) | Mac 2 (SSD) | `install.log` arquivado |
| --- | --- | --- | --- |
| 0A sem sudo |  |  |  |
| 0B fora de /Volumes |  |  |  |
| 0C sem .pkg |  |  |  |
| 0D Terminal do Recovery |  |  |  |
| 1A pendrive removido |  |  |  |
| 1B recuperação |  |  |  |
| 2A sem rede |  |  |  |
| 2B Wi-Fi sem internet |  |  |  |
| 2C queda de Wi-Fi |  |  |  |
| 3A na bateria |  |  |  |
| 3B carregador removido |  |  |  |

Só libere o pendrive para venda com todas as linhas aprovadas nos dois Macs.

## Decisões abertas (herdadas da auditoria anterior)

- **Escopo de macOS.** Cada pendrive leva o Office de uma versão. Os MacBooks com T2 (2018–2019) rodam até Sequoia/Tahoe: defina que build do Office vai para cada macOS e diga na oferta qual cobre.
- **Espaço no pendrive.** O `kit-multi-macos.sh` do briefing entrega o resto do pendrive à partição do Sequoia, e o `createinstallmedia` apaga a partição de destino. Crie uma partição própria (ex.: `KIT`) para `scripts/` e `assets/`.
- **Licença da Microsoft.** Confirme os termos de redistribuição do instalador do Office antes de vender (não é parecer jurídico).
