# Guia do Kit Autonomia Mac — formatar o seu MacBook sozinho

Versão esqueleto · Oct 3, 2026 · fotos ainda por tirar (ver lista no fim)

Este guia mostra, passo a passo, como apagar o seu MacBook e instalar o macOS pelo pendrive do kit.
Depois, como instalar o Microsoft Office.

Cada passo tem três partes:
- **Faça:** o que você faz.
- **Você vê:** o que deve aparecer na tela.
- **Se não vir:** o que fazer se for diferente.

> ⚠️ **Apagar o disco apaga TUDO o que está no Mac.** Copie antes as fotos e os arquivos que quiser guardar.

## 1. Antes de começar

**Você precisa de:**
- O pendrive do kit.
- O carregador do Mac, ligado na tomada **o tempo todo**.
- Cerca de **1h30** sem pressa.
- Um celular com internet, para usar como hotspot (Macs de 2018 e 2019 precisam dele por 1–2 minutos).

**PARE e chame o suporte se:**
- Ao ligar segurando a tecla **Option**, aparecer um **cadeado** pedindo senha. É a senha de firmware: só o dono anterior ou a Apple tiram.
- O Mac pedir o **Apple ID ou a senha de outra pessoa** (tela "Bloqueio de Ativação" ou "Ativar Mac"). Só o dono dessa conta libera.
- Você não souber a senha de administrador e o seu Mac for de 2018 ou 2019 (passo 3).

Não tente "atalhos" para passar desses bloqueios. Eles não funcionam e podem travar o Mac.

## 2. Descobrir o ano do seu Mac e qual macOS escolher

1. **Faça:** se o Mac ainda liga normalmente, clique na maçã, no canto de cima à esquerda, e em **Sobre Este Mac**.
   - **Você vê:** algo como "MacBook Pro (13 polegadas, 2017)". Anote o tipo e o ano.
   - **Se não vir** (o Mac não liga no sistema): vire o Mac e procure o **número de série** gravado embaixo. No celular, abra [checkcoverage.apple.com](https://checkcoverage.apple.com) e digite o número. [FOTO-01: número de série gravado embaixo do MacBook]

2. **Faça:** encontre o seu ano na tabela e anote o macOS.

| Ano do seu Mac | macOS para escolher | Office funciona? |
| --- | --- | --- |
| 2010 ou 2011 | High Sierra | Não |
| 2012 | Catalina | Não |
| 2013 ou 2014 | Big Sur (MacBook Pro do **início** de 2013: Catalina) | Não |
| 2015 ou 2016 | Monterey (MacBook 12" de 2015: Big Sur) | Sim (menos o MacBook 12" 2015) |
| 2017 | Ventura (MacBook Air 2017: Monterey) | Sim |
| 2018 ou 2019 — MacBook Air | Sonoma | Sim |
| 2018 ou 2019 — MacBook Pro | Sequoia | Sim |

   - **Se não achar o seu Mac** ou ficar em dúvida: chame o suporte antes de apagar qualquer coisa.

> Mac de **2018 ou 2019**? Faça o passo 3 primeiro. Outros anos: pule para o passo 4.

## 3. Só se o seu Mac é de 2018 ou 2019: preparar a segurança

Faça isto **ANTES** de apagar qualquer coisa. Depois de apagar, não dá mais.

1. **Faça:** desligue o Mac. Ligue e segure **Command (⌘) + R** até aparecer a maçã.
   - **Você vê:** a janela **Utilitários do macOS**. [FOTO-02: janela Utilitários do macOS]
   - **Se não vir** e aparecer um globo girando ou um pedido de Wi-Fi: conecte no hotspot do celular e espere. Se não avançar, chame o suporte.
2. **Faça:** na barra de cima, clique em **Utilitários** → **Utilitário de Segurança da Inicialização**.
   - **Você vê:** um pedido de senha de administrador.
   - **Se não vir:** confira se clicou no menu **Utilitários** da barra de cima, não na janela.
3. **Faça:** digite a senha de administrador do Mac e clique em OK.
   - **Você vê:** as opções de segurança. [FOTO-03: tela do Utilitário de Segurança da Inicialização]
   - **Se não vir** (senha recusada ou desconhecida): PARE e chame o suporte.
4. **Faça:** marque **Segurança Média** e **Permitir inicialização por mídia externa**.
   - **Você vê:** as duas opções marcadas. [FOTO-04: as duas opções marcadas]
   - **Se não vir:** feche a janela, abra de novo e repita.
5. **Faça:** feche a janela. Menu da maçã → **Desligar**.

## 4. Ligar pelo pendrive e escolher o instalador

1. **Faça:** com o Mac desligado, ligue o pendrive **direto** no Mac (sem hub ou extensão). Ligue o carregador.
   - **Se o Mac só tem USB-C:** use o adaptador USB-C → USB-A.
2. **Faça:** ligue o Mac e segure a tecla **Option (⌥)** até aparecerem ícones de discos.
   - **Você vê:** vários ícones amarelos, um para cada versão: "Install macOS Monterey", "Install macOS Ventura"... [FOTO-05: tela de escolha de disco com os instaladores do pendrive]
   - **Se não vir** os instaladores: desligue, troque o pendrive de porta e tente de novo. Mac de 2018/2019: refaça o passo 3. Se aparecer um **cadeado**: PARE (passo 1).
3. **Faça:** clique no instalador do macOS que você anotou no passo 2 e depois na seta.
   - **Você vê:** a maçã com a barra de progresso. Depois, a janela **Utilitários do macOS** ou um pedido de idioma.
   - **Se não vir** e aparecer um círculo cortado (🚫): você escolheu uma versão que não serve neste Mac. Desligue e escolha a versão certa.
4. **Faça:** se pedir, escolha **Português (Brasil)** e clique na seta.
   - **Você vê:** a janela com **Instalar macOS**, **Utilitário de Disco** e outras opções.

## 5. Acertar a data no Terminal

Data errada é a causa mais comum de "o instalador está danificado". Acerte **antes** de instalar.

1. **Faça:** na barra de cima, clique em **Utilitários** → **Terminal**.
   - **Você vê:** uma janela branca ou preta com texto e um cursor piscando. [FOTO-06: Terminal aberto no instalador]
2. **Faça:** digite `date` e aperte **Enter**.
   - **Você vê:** a data e a hora que o Mac acha que são.
   - Se estiverem certas (dia, mês, ano e hora aproximada), pule para o item 4.
3. **Faça:** digite `date` + espaço + **mês, dia, hora, minuto e ano**, tudo junto, e aperte **Enter**.
   - Exemplo: 03/10/2026, 14:30 fica assim:

     ```
     date 100314302026
     ```

     (10 = mês · 03 = dia · 14 = hora · 30 = minutos · 2026 = ano)
   - **Você vê:** a data nova.
   - **Se não vir** (aparece "usage" ou erro): confira se são **12 números seguidos**, sem barras nem espaços no meio.
4. **Faça:** feche o Terminal: menu **Terminal** → **Encerrar Terminal**.
   - **Você vê:** a janela Utilitários do macOS de novo.

## 6. Apagar o disco no Utilitário de Disco

1. **Faça:** clique em **Utilitário de Disco** → **Continuar**.
   - **Você vê:** uma lista de discos à esquerda.
2. **Faça:** na barra de cima, clique em **Visualizar** → **Mostrar Todos os Dispositivos**.
   - **Você vê:** a lista com itens em vários níveis. [FOTO-07: menu Visualizar com "Mostrar Todos os Dispositivos"]
3. **Faça:** em **Interno**, clique no **primeiro item, o de cima** (o nome do disco, ex.: "APPLE SSD ..."), não nos itens de baixo.
   - **Você vê:** o disco interno selecionado, com o tamanho total do Mac. [FOTO-08: disco físico interno selecionado]
   - ⚠️ **Nunca** selecione nada em **Externo**: é o pendrive do kit.
   - **Se não vir** a parte "Interno": o disco pode estar com defeito. Chame o suporte.
4. **Faça:** clique em **Apagar**, no alto da janela, e preencha:
   - **Nome:** `Macintosh HD`
   - **Formato:** **APFS**. Exceção: se você escolheu **High Sierra** e o Mac tem **HD que gira** (Macs 2010–2012 sem SSD), escolha **Mac OS Expandido (Reg. Cronológico)**.
   - **Esquema:** **Mapa de Partição GUID**
   - **Você vê:** os três campos preenchidos. [FOTO-09: janela Apagar preenchida]
   - **Se não vir** o campo Esquema: você selecionou um item de baixo. Cancele e volte ao item 3.
5. **Faça:** clique em **Apagar** e espere.
   - **Você vê:** "Processo de apagar concluído". Clique em **OK**.
   - **Se não vir** (aparece erro): tente de novo uma vez. Se repetir, chame o suporte.
6. **Faça:** feche o Utilitário de Disco: menu **Utilitário de Disco** → **Encerrar**.

## 7. Instalar o macOS e o Assistente de Configuração

1. **Faça:** clique em **Instalar macOS** → **Continuar**. Aceite os termos.
   - **Você vê:** a lista de discos para instalar.
2. **Faça:** escolha **Macintosh HD** e clique em **Continuar** (ou **Instalar**).
   - **Você vê:** uma barra de progresso. O Mac **reinicia sozinho várias vezes**. Leva de 30 a 60 minutos.
   - **Não tire o pendrive** nem o carregador até aparecer a tela de escolher o país.
   - **Se não vir** o Macintosh HD: volte ao passo 6, o disco não foi apagado.
   - Se aparecer "esta cópia do aplicativo está danificada": volte ao passo 5 e acerte a data.
3. **Faça:** quando aparecer a tela do país, escolha **Brasil** e siga.
   - **Você vê:** o **Assistente de Configuração**. Agora pode tirar o pendrive. [FOTO-10: primeira tela do Assistente de Configuração]
4. **Faça (Mac de 2010 a 2017):** na tela de Wi-Fi, clique em **Outras Opções de Rede** → **Meu computador não se conecta à internet**.
   - **Você vê:** o Assistente continua sem rede. [FOTO-11: tela "Outras Opções de Rede"]
5. **Faça (Mac de 2018 ou 2019):** na tela de Wi-Fi ou **Ativar Mac**, conecte no hotspot do celular.
   - No iPhone: Ajustes → Acesso Pessoal → ligue **Maximizar Compatibilidade**.
   - **Você vê:** "Ativando..." e depois o Assistente continua (leva 1–2 minutos).
   - **Se não vir** e pedir o Apple ID de outra pessoa: PARE e chame o suporte.
6. **Faça:** siga o Assistente e crie a sua conta (nome e senha).
   - **Anote a senha.** É a "senha do Mac" que o Office vai pedir.
   - **Você vê:** a mesa do Mac (área de trabalho). Pronto: macOS instalado!

## 8. Instalar o Office

O Office só funciona no **macOS 12 (Monterey) ou mais novo**, ou seja, em Macs de 2015 em diante (veja a tabela do passo 2).
Precisa de **internet** e da **sua licença** do Office (conta Microsoft).

1. **Faça:** conecte o Mac à internet (Wi-Fi de casa ou cabo). Ligue o carregador.
   - Evite Wi-Fi de hotel ou empresa, que pede login.
2. **Faça:** ligue o pendrive. Abra o **Finder** (o rosto azul na barra de baixo).
   - **Você vê:** **KIT** na coluna da esquerda, em **Locais**. [FOTO-12: Finder com KIT em Locais]
   - **Se não vir:** tire o pendrive, espere 10 segundos e ligue de novo.
3. **Faça:** clique em **KIT** e dê **dois cliques** em **Instalar Office.command**.
   - **Você vê:** uma janela do Terminal com a explicação do instalador. [FOTO-13: Terminal com a explicação do "Instalar Office.command"]
   - **Se não vir** e o macOS disser que o arquivo "não pode ser aberto": clique nele com o botão direito → **Abrir** → **Abrir**. **(A CONFIRMAR NA BANCADA)**
4. **Faça:** se o macOS perguntar se o Terminal pode acessar arquivos em um **volume removível**, clique em **OK**. **(A CONFIRMAR NA BANCADA)** [FOTO-14: pergunta de acesso ao volume removível]
5. **Faça:** quando pedir **Password**, digite a senha do Mac e aperte **Enter**.
   - **A senha NÃO aparece enquanto você digita.** Nem bolinhas. É normal: digite tudo e aperte Enter.
   - **Você vê:** "Baixando o Office da Microsoft" e uma barra de progresso. O download tem cerca de 3 GB. [FOTO-15: barra de progresso do download]
   - **Se não vir** e aparecer "Sorry, try again": a senha estava errada. Digite de novo com calma.
6. **Faça:** espere. **Não feche a janela.** Depois do download vem "Instalando" (10 minutos ou mais).
   - **Você vê:** **Pronto!** no fim. [FOTO-16: mensagem "Pronto!" no Terminal]
   - **Se não vir** e aparecer **ERRO**: leia a mensagem e veja a tabela do passo 9.
7. **Faça:** aperte **Enter** para fechar. Abra o **Microsoft Word** em **Aplicativos**.
8. **Faça:** clique em **Entrar** e use a **conta Microsoft da sua licença**.
   - **Você vê:** o Word pronto para usar. Crie um documento, escreva algo e salve para testar. [FOTO-17: tela de entrar com a conta Microsoft no Word]
   - **Se não vir** e o Word disser que só pode abrir e imprimir: a licença não ativou. Confira a conta ou chame o suporte.

## 9. Se algo der errado

Na janela do Office, a linha que começa com **ERRO:** diz o que aconteceu.

| Mensagem que apareceu | O que fazer |
| --- | --- |
| `Este Mac é antigo demais para o Office atual` / `O Office atual só funciona no macOS 12 ou mais novo` | Este Mac não roda o Office atual. Não há o que fazer pelo kit. |
| `o instalador precisa da senha do Mac` | Abra pelo **Instalar Office.command** (dois cliques), não de outro jeito. |
| `ligue o carregador na tomada` | Ligue o carregador e rode de novo. |
| `o relógio do Mac está no ano ...` | Acerte a data: Ajustes do Sistema → Geral → Data e Hora (no macOS 12: Preferências do Sistema → Data e Hora). Rode de novo. |
| `o Mac tem menos de ... GB livres` | Apague arquivos que não usa, esvazie o Lixo e rode de novo. |
| `sem acesso à internet` | Conecte o Mac à internet (Wi-Fi ou cabo) e rode de novo. |
| `a rede pede login` | Use outra rede ou o hotspot do celular e rode de novo. |
| `a internet funciona, mas o instalador da Microsoft não respondeu` | Tente mais tarde. Se repetir, chame o suporte. |
| `o download falhou (a internet caiu?)` | Confira a internet e rode de novo. O download recomeça do zero. |
| `o arquivo baixado não é o oficial da Microsoft` | Rode de novo. Se repetir, chame o suporte. |
| `a instalação falhou` / `... não apareceu em Aplicativos` | Rode de novo. Se repetir, chame o suporte e diga a mensagem. |
| `não foi possível identificar a versão do macOS` / `medir o espaço livre` / `criar a pasta temporária` | Reinicie o Mac e rode de novo. Se repetir, chame o suporte. |
| `Sorry, try again` (depois da senha) | A senha estava errada. Digite de novo; ela não aparece na tela. |

<!-- "a rede pede login" e "a internet funciona, mas..." só existem no install_office.sh depois do commit 1745972 (fix: travas de rede, espaço e quarentena), ainda fora de main. -->

**Para "rodar de novo":** feche a janela e dê dois cliques outra vez em **Instalar Office.command**.

**Problemas na instalação do macOS (passos 4 a 7):**

| O que aconteceu | O que fazer |
| --- | --- |
| Cadeado ao ligar | PARE. Senha de firmware: chame o suporte. |
| Pede Apple ID de outra pessoa | PARE. Bloqueio de Ativação: chame o suporte. |
| Pendrive não aparece ao segurar Option | Troque de porta, sem hub. Mac 2018/2019: refaça o passo 3. |
| Círculo cortado (🚫) ao ligar pelo pendrive | Versão errada: veja a tabela do passo 2. |
| "Esta cópia do aplicativo está danificada" | Acerte a data (passo 5) e instale de novo. |
| Barra parada por mais de 2 horas | Desligue segurando o botão, ligue pelo pendrive e recomece no passo 5. Se repetir, chame o suporte. |

## Lista de fotos a tirar

| Foto | O que fotografar | Em qual tela |
| --- | --- | --- |
| FOTO-01 | Número de série gravado embaixo do MacBook | Fundo do Mac (fora de qualquer tela) |
| FOTO-02 | Janela Utilitários do macOS | Recovery (Command + R), Mac com T2 |
| FOTO-03 | Utilitário de Segurança da Inicialização aberto | Recovery, menu Utilitários |
| FOTO-04 | "Segurança Média" e "Permitir inicialização por mídia externa" marcadas | Utilitário de Segurança da Inicialização |
| FOTO-05 | Ícones dos instaladores do pendrive | Tela de escolha de disco (Option ao ligar) |
| FOTO-06 | Terminal aberto | Instalador do pendrive, menu Utilitários |
| FOTO-07 | Menu Visualizar com "Mostrar Todos os Dispositivos" | Utilitário de Disco |
| FOTO-08 | Disco físico interno (item de cima) selecionado | Utilitário de Disco |
| FOTO-09 | Janela Apagar com Nome, Formato e Esquema preenchidos | Utilitário de Disco |
| FOTO-10 | Primeira tela (escolher o país) | Assistente de Configuração |
| FOTO-11 | "Outras Opções de Rede" / "Meu computador não se conecta à internet" | Assistente de Configuração, tela de Wi-Fi |
| FOTO-12 | KIT na coluna Locais | Finder |
| FOTO-13 | Explicação inicial do "Instalar Office.command" | Terminal |
| FOTO-14 | Pergunta de acesso a volume removível (se existir) | Alerta do macOS ao abrir o .command |
| FOTO-15 | Barra de progresso do download | Terminal, durante o Office |
| FOTO-16 | Mensagem "Pronto!" | Terminal, fim do Office |
| FOTO-17 | Tela de entrar com a conta Microsoft | Word, primeira abertura |
