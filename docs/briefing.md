# Briefing — MacBooks Intel (≤2019) travando no Wi-Fi do Recovery

Oct 3, 2026 · @Jota

## 1. Diagnóstico técnico (o problema raiz)

**O Wi-Fi quase nunca é o defeito: o Mac caiu no Internet Recovery, que depende 100% de rede, e a etapa online falha.** Isso acontece porque a partição de recuperação local foi apagada ou corrompida (ex.: alguém apagou o disco inteiro numa formatação anterior). Sem ela, o Mac (Intel, até 2019) baixa o ambiente de recuperação e o instalador da Apple pela internet, e qualquer falha de rede, relógio ou certificado trava o processo.

**Sinais de que você está no Internet Recovery:** globo giratório na inicialização, pedido de rede Wi-Fi antes de qualquer menu, ou erro **-2003F** / "o servidor de recuperação não pôde ser contatado".

### Causas-raiz, em ordem de frequência

| # | Causa | Sintoma típico | Modelos afetados | Solução exata |
| --- | --- | --- | --- | --- |
| 1 | Recovery local inexistente → Mac depende da rede | Globo giratório, pede Wi-Fi, fica horas "carregando" | Todos os Intel 2010–2019 | Instalar **offline** via pendrive bootável (`createinstallmedia`) |
| 2 | Relógio do sistema errado (bateria arriada ou NVRAM zerada volta a data para 2000/2001) | "Erro ao preparar a instalação", "cópia do instalador danificada", servidor não contatado | Todos, principalmente máquinas paradas há meses | Terminal do Recovery: conferir com `date` e corrigir com `date MMDDhhmmAAAA` |
| 3 | Rede incompatível com o Recovery antigo: WPA3, rede só 5 GHz / Wi-Fi 6 com band steering, portal cativo, 802.1X, SSID oculto, caracteres especiais na senha | Não conecta, ou conecta e cai no meio | Principalmente 2010–2015 | Hotspot do celular em 2,4 GHz/WPA2 (no iPhone: "Maximizar Compatibilidade") ou cabo Ethernet com adaptador |
| 4 | Download grande em conexão fraca (imagem de recuperação + instalador de 12 GB ou mais) | Barra parada por horas; parece travado | Todos | Pendrive offline elimina o download |
| 5 | Instalador antigo com certificado vencido (cópias baixadas antes de out/2019) | "Esta cópia do aplicativo Instalar macOS está danificada" | Instaladores High Sierra/Mojave antigos guardados | Baixar instalador novo da Apple; ou, só offline, ajustar a data para o período de validade |
| 6 | Chip T2 (Macs 2018–2019): após apagar o disco, o macOS exige "Ativar Mac" online; Bloqueio de Ativação (Buscar) exige o Apple ID; Utilitário de Segurança bloqueia boot externo por padrão; em "Segurança Total" (padrão), o Mac consulta a Apple pela internet para validar o sistema | Fica na tela de ativação/Wi-Fi depois da formatação; alerta "conexão com a internet necessária"; pendrive não aparece | MacBook Pro/Air 2018–2019, Mac mini 2018, iMac Pro | Liberar boot externo **antes** de apagar o disco; baixar para "Segurança Média" (valida só a assinatura, sem internet); dono remove o Mac do iCloud; ativação via hotspot/cabo |
| 7 | Hardware: HD/SSD degradado, cabo flat do HD (MacBook Pro 13" 2012 é clássico), RAM com defeito | Instalação reinicia ou congela em pontos aleatórios | 2010–2015 com HD mecânico | Apple Diagnostics (tecla **D**); trocar cabo/SSD |

### Soluções técnicas, por papel

- **Resolve a causa raiz:** pendrive bootável offline com o instalador certo para o modelo. É o padrão de bancada.
- **Contorno quando só há Recovery online:** corrigir a data no Terminal + rede compatível (hotspot 2,4 GHz WPA2 ou Ethernet).
- **Higiene, não cura:** reset de NVRAM e de SMC. Limpam disco de inicialização, fuso, gestão de energia e Wi-Fi "enroscado", mas não resolvem certificado nem falta de recovery. Use antes de começar e quando o Mac se comportar de forma estranha.
- **Específico T2:** Utilitário de Segurança da Inicialização → "Permitir inicialização por mídia externa", feito enquanto ainda existe um usuário administrador no disco.

### Atalhos de inicialização (Intel)

| Teclas na inicialização | O que faz |
| --- | --- |
| Cmd + R | Recovery local (se existir) |
| Option + Cmd + R | Internet Recovery: macOS mais recente compatível com o modelo |
| Shift + Option + Cmd + R | Internet Recovery: macOS original de fábrica ou o mais próximo disponível |
| Option (Alt) | Gerenciador de Inicialização: escolher o pendrive |
| D / Option + D | Apple Diagnostics local / online |
| Option + Cmd + P + R | Reset de NVRAM (segurar \~20 s; em T2, até o logo aparecer e sumir duas vezes) |

## 2. Guia passo a passo operacional (bancada)

**Regra de ouro: instale sempre offline, pelo pendrive.** O Internet Recovery é o plano B. Com o pendrive pronto, a estimativa é de 60–90 min por máquina, quase tudo tempo de espera.

&#91;embedded content: triagem de bancada · 3 decisões, 2 rotas\]

Bloqueio encerra o atendimento; Mac com T2 passa pela Fase 2; sem pendrive, a Rota B é contorno e, se falhar, volta para a Rota A.

### Fase 0 — Recepção (antes de tocar no disco)

1. **Identifique o modelo exato.** Etiqueta embaixo do Mac, número de série em [checkcoverage.apple.com](https://checkcoverage.apple.com), ou no Terminal do Recovery: `sysctl hw.model` (ex.: `MacBookPro15,2`). O modelo define o macOS máximo e se há chip T2 (tabela na seção 3).
2. **Verifique bloqueios.** Segure **Option** ao ligar: um **cadeado** = senha de firmware. Em T2, pergunte se "Buscar meu Mac" está ativo. Sem a senha ou sem o Apple ID do dono, **pare** (seção 5).
3. **Formalize.** Termo de autorização de formatação assinado e confirmação de que não há dados a salvar.

### Fase 1 — Higiene (5 min)

4. **Reset de SMC.** T2: desligue, segure Control (esq.) + Option (esq.) + Shift (dir.) por 7 s, some o botão de ligar por mais 7 s, solte e aguarde. Sem T2, bateria interna: Shift + Control + Option (esq.) + botão de ligar por 10 s.
5. **Reset de NVRAM.** Ligue segurando Option + Cmd + P + R por \~20 s.
6. **Diagnóstico.** Ligue segurando **D**. Anote qualquer código de erro: falha de disco ou RAM muda o orçamento antes da formatação.

### Fase 2 — Preparo de segurança (só Macs com T2, 2018–2019)

7. Ligue com **Cmd + R** → Utilitários → **Utilitário de Segurança da Inicialização** → autentique com um administrador.
8. Marque **Segurança Média** e **Permitir inicialização por mídia externa**. Faça isso **antes** de apagar o disco: sem um usuário administrador no disco, o utilitário não autentica.

### Fase 3 — Rota A: instalação offline pelo pendrive (padrão)

9. Conecte o pendrive **direto** no Mac (sem hub) e o carregador na tomada. Ligue segurando **Option** e escolha "Instalar macOS …".
10. **Corrija a data antes de tudo.** Utilitários → Terminal:
    - conferir: `date`
    - corrigir (formato MMDDhhmmAAAA): `date 100314302026` = 03/10/2026, 14:30
11. **Utilitário de Disco** → Visualizar → **Mostrar Todos os Dispositivos** → selecione o **disco físico** (item do topo, não o volume) → Apagar:
    - Nome: `Macintosh HD`
    - Formato: **APFS** (High Sierra ou superior em SSD; Mojave ou superior sempre) ou **Mac OS Extended (Reg. Cronológico)** (HD mecânico até High Sierra)
    - Esquema: **Mapa de Partição GUID**
12. Feche o Utilitário de Disco → **Instalar macOS** → destino `Macintosh HD`. Deixe o pendrive conectado até o Assistente de Configuração aparecer; o Mac reinicia várias vezes.

### Fase 3 — Rota B: Internet Recovery (só sem pendrive)

13. Use **cabo Ethernet** (adaptador Thunderbolt/USB-C) ou hotspot do celular em 2,4 GHz/WPA2. Nunca rede corporativa, de hotel ou com WPA3.
14. **Shift + Option + Cmd + R** (sistema de fábrica, menor e mais compatível) ou **Option + Cmd + R** (mais recente compatível).
15. Antes de "Reinstalar macOS": Terminal → corrija a data (passo 10).
16. Erro **-2003F** ou servidor não contatado: troque de rede e tente a outra combinação de teclas. Persistiu: volte à Rota A.

### Fase 4 — Pós-instalação e entrega

17. **Assistente de Configuração:**
    - Sem T2: na tela de Wi-Fi, "Outras Opções de Rede" → "Meu computador não se conecta à internet" pula a etapa online.
    - Com T2: a tela **Ativar Mac** exige internet — conecte ao hotspot por 1–2 min.
18. **Mac para revenda:** pare no Assistente e pressione **Cmd + Q** → Desligar. O comprador recebe o Mac "de caixa".
19. **Mac para uso do cliente:** crie o usuário, rode Atualização de Software e confira Wi-Fi, câmera, áudio, teclado e bateria (Informações do Sistema → Energia → contagem de ciclos).

## 3. Ferramentas, softwares e comandos

**O ativo central é um pendrive de 128 GB com 8 instaladores (High Sierra → Sequoia) gerado num "Mac de bancada".** Ele cobre todos os MacBooks Intel de 2010 a 2019 sem depender da internet do cliente.

### Qual macOS gravar para cada MacBook (limite oficial)

| Modelo | Chip T2 | macOS máximo |
| --- | --- | --- |
| MacBook Pro 16" 2019 | Sim | Tahoe 26 ([lista Apple](https://support.apple.com/en-us/122867)) |
| MacBook Pro 13"/15" 2018–2019 | Sim | Sequoia 15 |
| MacBook Air 2018–2019 | Sim | Sonoma 14 |
| MacBook Pro 2017 · MacBook 12" 2017 | Não | Ventura 13 |
| MacBook Pro 2015–2016 · MacBook Air 2015–2017 · MacBook 12" 2016 | Não | Monterey 12 |
| MacBook Pro fim/2013–2014 · MacBook Air 2013–2014 · MacBook 12" 2015 | Não | Big Sur 11 |
| MacBook Pro meados/2012–início/2013 · MacBook Air 2012 | Não | Catalina 10.15 |
| MacBook Pro e Air 2010–2011 | Não | High Sierra 10.13 |

Confira o modelo exato nas [páginas de compatibilidade da Apple](https://support.apple.com/en-us/102662) antes de gravar; variações de meio de ano existem.

### Hardware de bancada

- **Mac de bancada:** um MacBook Pro 13" 2018 ou 2019. Ele veio de fábrica com High Sierra/Mojave e aceita até Sequoia, então baixa quase todos os instaladores. A Apple avisa que, na maioria dos casos, o download precisa ser feito num Mac compatível com aquela versão.
- **Pendrives:** 1 × 128 GB USB 3.0 (multi-instalador) + 1 × 32 GB reserva. A Apple indica que 32 GB comportam qualquer instalador.
- **Adaptadores:** USB-C → USB-A; USB-C → Ethernet (2016+); Thunderbolt 2 → Gigabit Ethernet (2012–2015).
- **Celular** com hotspot configurável em 2,4 GHz/WPA2.

### Softwares

- **Instaladores oficiais da Apple:** `softwareupdate` no Terminal (Catalina ou superior), App Store (High Sierra → Sequoia) e .dmg diretos (Sierra, El Capitan, Yosemite, Mountain Lion, Lion) — [Apple: baixar macOS](https://support.apple.com/en-us/102662).
- **createinstallmedia:** já vem dentro de cada instalador — [Apple: criar instalador inicializável](https://support.apple.com/en-us/101578).
- **Apple Configurator** (opcional): reanima o firmware do chip T2 via DFU a partir de outro Mac, quando o T2 trava.
- **OpenCore Legacy Patcher** (opcional, upsell): instala macOS mais novo em Mac não suportado. Não oficial; ofereça só com aviso por escrito.

### Baixar os instaladores no Mac de bancada

```bash
# lista as versões completas disponíveis para este Mac
softwareupdate --list-full-installers

# baixa uma versão específica para /Applications (use a mais recente de cada linha)
softwareupdate --fetch-full-installer --full-installer-version <versão listada acima>
```

High Sierra e Mojave: pelos links da App Store na página da Apple. Se o `softwareupdate` disser "update not found", aquela versão não está disponível para o modelo do Mac de bancada.

### Script: pendrive multi-macOS

```bash
#!/bin/bash
# kit-multi-macos.sh — rodar no Mac de bancada: sudo ./kit-multi-macos.sh disk4
set -e
DISK="$1"
[ -z "$DISK" ] && { echo "Uso: sudo $0 diskN  (veja com: diskutil list external)"; exit 1; }
diskutil list "$DISK"
read -p "TODO o conteúdo de /dev/$DISK será APAGADO. Digite SIM: " OK
[ "$OK" = "SIM" ] || exit 1

# 1) GUID + Mac OS Extended (Journaled), uma partição por versão
diskutil partitionDisk "$DISK" GPT \
  JHFS+ HS 8G  JHFS+ MOJ 8G  JHFS+ CAT 10G \
  JHFS+ BSUR 15G  JHFS+ MONT 15G  JHFS+ VEN 15G \
  JHFS+ SON 16G  JHFS+ SEQ R

# 2) grava cada instalador presente em /Applications na sua partição
grava() {
  APP="/Applications/Install macOS $1.app"
  if [ -d "$APP" ]; then
    echo ">> Gravando $1 em /Volumes/$2"
    "$APP/Contents/Resources/createinstallmedia" --volume "/Volumes/$2" --nointeraction
  else
    echo "-- Pulando $1: instalador não encontrado"
  fi
}
grava "High Sierra" HS
grava "Mojave" MOJ
grava "Catalina" CAT
grava "Big Sur" BSUR
grava "Monterey" MONT
grava "Ventura" VEN
grava "Sonoma" SON
grava "Sequoia" SEQ
echo "Pronto. Cada partição agora se chama 'Install macOS <versão>'."
```

Teste o pendrive em pelo menos dois Macs de gerações diferentes antes de vender ou usar em cliente.

### Comandos do Terminal no Recovery

| Comando | Para quê |
| --- | --- |
| `date` | Ver a data do sistema |
| `date 100314302026` | Ajustar data (MMDDhhmmAAAA) |
| `sysctl hw.model` | Identificador do modelo |
| `diskutil list` | Ver discos e partições |
| `ping -c 3 apple.com` | Testar se a rede realmente sai para a internet |
| `nvram -c` | Limpar NVRAM sem atalho de teclado |

## 4. Estratégia de monetização e empacotamento

**Venda ao cliente o "Kit Autonomia Mac": o pendrive pronto é o "software" que ele pediu, e a sessão guiada é o que o faz deixar de pagar a terceiros.** Ele mostrou três sinais: problema **recorrente** ("às vezes não reseta", vários MacBooks), **orçamento apertado** e desejo de **fazer sozinho, o quanto antes**. Um kit único, que se paga em poucas formatações, conversa com os três.

### Leitura do cliente

- **Dor real:** pagar toda vez a "os caras que formatam" por algo que se repete. Cada formatação terceirizada é dinheiro perdido.
- **Pedido literal:** "um software para rodar essa formatação". Não existe programa mágico; o equivalente honesto é o pendrive multi-macOS + roteiro.
- **Objeção previsível:** preço. Resposta: comparar com o custo de 2 formatações e oferecer entrada menor (Kit Lite).

### Pacotes

| Pacote | O que inclui | Preço sugerido (a validar) | Quando oferecer |
| --- | --- | --- | --- |
| **Kit Autonomia Mac** (recomendado) | Pendrive 128 GB multi-macOS testado · checklist ilustrado (seção 2 em linguagem de cliente) · 1 sessão remota de 45 min acompanhando a 1ª formatação · 30 dias de suporte por WhatsApp | R$ 297–397 à vista no PIX, ou 3× no cartão | Oferta principal: resolve hoje e dá autonomia |
| **Kit Lite** | Pendrive 32 GB só com a(s) versão(ões) dos modelos dele · checklist em PDF | R$ 147–197 | Se o orçamento travar; upgrade para o completo depois, abatendo o valor pago |
| **Mentoria Express** | 2 h mão na massa no Mac dele (presencial ou remoto); ele mesmo cria o pendrive no final | R$ 197–297 | Se ele valoriza aprender mais do que receber pronto |
| **Socorro Avulso** | Você formata na bancada, com diagnóstico | R$ 150–200 por máquina; R$ 120 a partir de 3 | Casos com T2 bloqueado, erro de disco ou urgência extrema |
| **Plano Nível 3** (recorrente) | Atualização anual do pendrive · casos que travarem com T2, firmware ou disco · prioridade na fila | R$ 99–149/mês | Depois da 1ª entrega, se ele revende ou mantém vários Macs |

Faixas de preço são proposta de partida: cote 3 assistências de Mac na sua região para ancorar o "quanto ele paga hoje". Custo direto do Kit Autonomia: pendrive (R$ 60–90) + \~2 h suas.

**Enquadramento legal:** o macOS é gratuito e distribuído pela Apple. Cobre pela mídia, preparação, testes, treinamento e suporte — nunca pelo sistema em si.

### Upsells naturais na bancada

- **Troca de HD por SSD** (2010–2012) e de bateria: o Mac "revive" além da formatação.
- **Limpeza interna + pasta térmica:** comum em MacBooks com mais de 5 anos.
- **Sistema mais novo via OpenCore Legacy Patcher:** só com termo de ciência (não oficial).

### Argumento de venda e mensagem pronta

**Âncora:** "Você não vai mais depender de ninguém para isso. O kit se paga na segunda formatação que você deixar de terceirizar."

> Fala, \[nome\]! Estudei o seu caso: o Mac trava no Wi-Fi porque cai na recuperação pela internet e ela falha (rede, data do sistema ou certificado). A saída é instalar **sem internet**, por um pendrive preparado.
>
> Montei o **Kit Autonomia Mac**: pendrive com todas as versões do macOS para MacBooks até 2019, um passo a passo ilustrado e uma chamada comigo acompanhando você na primeira formatação. Depois disso você faz sozinho quantas vezes quiser.
>
> Fica R$ \[valor\] no PIX ou 3× no cartão. Se preferir começar menor, tenho uma versão só para os seus modelos por R$ \[valor\]. Consigo entregar em \[prazo\]. Quer que eu separe um pra você?

### Escala do nicho (próximos passos)

- Mesmo kit para **revendedores de Mac usado** e **assistências pequenas** que não têm Mac de bancada.
- Conteúdo curto mostrando o "antes/depois" do travamento gera demanda orgânica.
- Encaixa na linha de serviços de TI da E.C.H.O Tech como produto de entrada padronizado.

## 5. Riscos, limites legais e checklist de entrega

**Bloqueio de Ativação e senha de firmware não se contornam: só o dono (Apple ID) ou a Apple, com nota fiscal, liberam.** Recuse ferramentas de "bypass": além de não funcionarem de forma confiável em T2, expõem você a receptação de aparelho furtado.

### Riscos técnicos e como neutralizar

| Risco | Consequência | Prevenção |
| --- | --- | --- |
| Apagar disco de Mac T2 antes de liberar mídia externa | Utilitário de Segurança não autentica; só resta o Internet Recovery | Fase 2 do guia sempre antes da formatação |
| Instalar versão incompatível | Instalação não conclui ou o Mac inicia num círculo cortado | Conferir o modelo na tabela da seção 3 |
| Instalação sem nenhuma internet | A Apple orienta manter o Mac online para buscar firmware do modelo; Mac T2 em Segurança Total exige rede | Hotspot próprio sempre à mão; T2 em Segurança Média |
| Disco ou RAM degradados | Instalação reinicia ou congela; cliente culpa o serviço | Apple Diagnostics (tecla D) na recepção, resultado anotado no termo |
| Perda de dados do cliente | Conflito e responsabilidade civil | Termo de autorização assinado antes de apagar |
| Bateria fraca no meio da instalação | Sistema corrompido | Carregador na tomada durante todo o processo |

### Checklist de entrega

- [ ] Modelo e macOS máximo conferidos
- [ ] Sem cadeado de firmware e sem Bloqueio de Ativação
- [ ] Termo de autorização assinado
- [ ] SMC + NVRAM resetados; Apple Diagnostics sem erro
- [ ] T2: Segurança Média + mídia externa liberada
- [ ] Data corrigida no Terminal antes de instalar
- [ ] Disco apagado (GUID + APFS/Mac OS Extended)
- [ ] macOS instalado e Assistente de Configuração concluído (ou Cmd + Q para revenda)
- [ ] Wi-Fi, câmera, áudio, teclado e bateria testados

### Fontes

- [Apple — Criar um instalador inicializável para o macOS](https://support.apple.com/en-us/101578)
- [Apple — Utilitário de Segurança da Inicialização (chip T2)](https://support.apple.com/en-us/102522)
- [Apple — Como baixar e instalar o macOS](https://support.apple.com/en-us/102662)
- [Apple — Compatibilidade do macOS Tahoe 26](https://support.apple.com/en-us/122867)

Causas de rede, data e certificado, atalhos e procedimentos de SMC/NVRAM vêm de prática de bancada e documentação Apple conhecida; valide em 2–3 máquinas antes de padronizar o serviço.
