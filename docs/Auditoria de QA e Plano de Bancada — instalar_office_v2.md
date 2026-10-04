# Auditoria de QA e Plano de Bancada — instalar\_office\_v2

Oct 3, 2026 · @Jota

## Veredito

**O `instalar_office.sh` original não deve ser vendido como está.** Ele instala direto do pendrive, mata apps do Office abertos, não confere bateria nem relógio e só avisa (não aborta) quando a integridade ou a assinatura falham. A `instalar_office_v2.sh` corrige esses pontos e passou em mais de 30 cenários simulados, mas isso foi feito em Linux com comandos do macOS simulados: **nenhum teste rodou em Mac real nem em bash 3.2.** Os 3 testes de bancada abaixo existem para fechar essa lacuna antes de liberar o kit.

Arquivos: `instalar_office_v2.sh` (na pasta de entregas desta sessão e no projeto MACs) e este documento.

## Riscos do script original

Dezesseis falhas, três delas críticas: todas podem deixar o Mac do cliente com Office parcial ou fazer o cliente perder trabalho. O original já acertava em não usar rede alguma, ignorar os arquivos `._*` e rodar em bash 3.2.

| # | Gravidade | Falha no original | Consequência | Correção na v2 |
| --- | --- | --- | --- | --- |
| 1 | Crítica | `installer` lê o `.pkg` direto do pendrive | Pendrive solto ou setor ruim no meio da instalação deixa Office parcial | Copia para o disco local, confere tamanho e SHA-256, instala da cópia (cód. 10 se a cópia falhar) |
| 2 | Crítica | O próprio script é lido do pendrive aos poucos pelo bash | Remover o pendrive corta o script em qualquer linha | Tudo dentro de `main()`: o bash lê a função inteira antes de executar |
| 3 | Crítica | `pkill` encerra Word, Excel etc. abertos | Documento não salvo do cliente é perdido | Aborta (cód. 9) pedindo para fechar; `--force-close` só se o técnico mandar |
| 4 | Alta | Nenhuma checagem de bateria ou carregador | Mac desliga no meio da instalação | Exige carregador e pelo menos 30% (cód. 6); `--force-power` registra no log |
| 5 | Alta | Integridade só por `xar -t` (lê o índice, não os dados); assinatura só gera aviso; sem `xar` ou `pkgutil` pula em silêncio | Pacote corrompido ou trocado é instalado | SHA-256 obrigatório contra `SHA256SUMS`; assinatura Microsoft obrigatória (cód. 8) |
| 6 | Alta | Nenhuma checagem de relógio (causa nº 2 do briefing) | Data de 2000/2001 quebra certificado e assinatura | Piso em 01/10/2026; abaixo disso aborta (cód. 7) |
| 7 | Alta | Se o `df` não for lido, avisa e segue | Disco cheio no meio da instalação | Falha fechada: sem medida, aborta; exige 8 GB mais o tamanho do `.pkg` (cód. 5) |
| 8 | Alta | Sem proteção contra rodar no Terminal do Recovery, onde o briefing manda trabalhar | `-target /` aponta para o disco RAM do Recovery | Detecta o Recovery e aborta (cód. 9). **Heurística, validar no Mac real** |
| 9 | Média | Com vários `.pkg` pega o “mais recente”; varre qualquer `/Volumes/*/Office` e usa o primeiro | Instala versão errada ou lê de outro disco; data de arquivo em FAT/exFAT não é confiável | Exige exatamente 1 `.pkg`; só aceita varredura se houver um único volume candidato (cód. 3) |
| 10 | Média | Sem `set -e`, sem `trap`, sem trava de execução dupla | Duas execuções simultâneas; Ctrl-C ou Terminal fechado mata o `installer` | `set -Eeuo pipefail`, `trap`, trava por PID, `installer` imune a HUP/INT/TERM, `caffeinate` contra suspensão |
| 11 | Média | `installer \| tee` | Console fechado gera SIGPIPE e derruba o `installer` | Saída vai direto para o log, sem pipe |
| 12 | Média | `grep -q` com `pipefail` na checagem da assinatura | Falso “não confirmou a assinatura”, de forma intermitente | Saída capturada em variável e testada com `case` |
| 13 | Média | `pkgutil --check-signature` sem limite de tempo | Pode travar tentando checagem online sem rede (plausível; **não verificado**) | Limite de 60 s; se estourar, segue, porque o SHA-256 já validou o arquivo |
| 14 | Média | `--office-dir` sem valor é ignorado; `MACOS_VERSION_OVERRIDE` valia em produção | Instala a pasta errada sem avisar | Valida argumentos; override só vale com `--dry-run`; limpeza só apaga sob `STAGE_BASE/office_setup.*` |
| 15 | Média | Termina com sucesso (cód. 0) mesmo sem Word, Excel e PowerPoint | Cliente recebe Mac “instalado” sem o Office | Falta de app principal vira erro (cód. 11) |
| 16 | Baixa | Tabela de versões máximas do Office fixa no código, sem fonte | Avisos falsos para o cliente | Mantida só como aviso e marcada “a validar” |

## Travas da v2 e códigos de saída

A v2 roda as travas nesta ordem e para na primeira que falhar: ambiente (Recovery, outro `installer`, Office aberto), relógio, energia, localização do `.pkg`, disco, cópia local, SHA-256, assinatura e só então a instalação. O `--dry-run` executa todas as travas (inclusive o SHA-256 lido do pendrive) sem copiar nem instalar, e serve como pré-teste na bancada.

| Código | Significado | O que o técnico faz |
| --- | --- | --- |
| 0 | Instalou e conferiu os apps | Ativar o Office com a licença do cliente |
| 1 | Uso incorreto ou erro geral | Ler a mensagem no console e no log |
| 2 | macOS fora do escopo (10.13 a 12) | Ver a seção de lacunas |
| 3 | `.pkg` ou pasta não achados, ou ambiguidade | Deixar exatamente 1 `.pkg` por pasta |
| 4 | O `installer` falhou | Ler `/var/log/install.log` e o log do script; rodar de novo |
| 5 | Pouco espaço em disco | Liberar espaço |
| 6 | Sem carregador ou bateria baixa | Conectar o carregador e esperar carregar |
| 7 | Relógio errado | Corrigir a data e rodar de novo |
| 8 | SHA-256 ou assinatura não conferem | Recopiar o `.pkg` do original homologado |
| 9 | Recovery, outro `installer` ou Office aberto | Fechar apps e rodar no macOS instalado |
| 10 | Pendrive removido ou erro de leitura na cópia | Reconectar direto, sem hub, e rodar de novo; nada foi instalado |
| 11 | Word, Excel ou PowerPoint ausentes após instalar | Reinstalar com a suíte completa |

Um manifesto `SHA256SUMS` precisa existir em cada pasta de versão. Gere-o na bancada, depois de conferir a assinatura do `.pkg` com `pkgutil --check-signature`:

```bash
cd Office/macOS_12_Monterey && shasum -a 256 *.pkg > SHA256SUMS
```

O manifesto protege contra cópia corrompida, não contra alguém que troque o `.pkg` e o manifesto juntos no pendrive.

## Lacunas e decisões abertas

- **Escopo de macOS.** O script cobre só 10.13 a 12 (Monterey). O briefing vende o kit para MacBooks até 2019, e os modelos com chip T2 (2018–2019) rodam Ventura, Sonoma, Sequoia ou Tahoe: nesses o script sai com código 2. Decida entre ampliar (novos pacotes e tabela de versões) ou dizer na oferta que o Office cobre até o macOS 12.
- **Onde fica a pasta Office no pendrive.** O `kit-multi-macos.sh` do briefing entrega todo o espaço restante à partição do Sequoia. Não sobra lugar para `Office/`, e o `createinstallmedia` apaga a partição de destino. Crie uma partição própria (por exemplo, `KIT`) antes da última.
- **Licença da Microsoft.** Vender um pendrive que carrega o instalador do Office é diferente de vender o macOS, que a Apple distribui gratuitamente. Confirme os termos de redistribuição da Microsoft antes de comercializar; não sou advogado e isto não é parecer jurídico.
- **Qual build do Office roda em cada macOS.** A tabela `MAX_OFFICE` do Engenheiro não tem fonte. Confirme na bancada, por versão de macOS, que o `.pkg` escolhido realmente instala e abre.
- **Limites do meu teste.** Rodei bash 5.2 em Linux, com `sw_vers`, `pmset`, `installer`, `pkgutil`, `caffeinate` e `defaults` simulados. Não validei o formato real do `pmset -g batt`, a detecção do Recovery, o `df -Pk /` em APFS, o bash 3.2 do macOS nem o tempo do SHA-256 em HD mecânico com USB 2.0.

## Roteiro de bancada: 3 cenários de erro

Os três cenários cobrem os riscos que mais custam caro: pendrive solto, perda de rede e falta de energia. Cada um deve passar **em dois Macs** de gerações diferentes, um com HD mecânico e porta USB 2.0 e outro com SSD, usando o pendrive exatamente como será vendido.

### Antes de começar

1. Gere o `SHA256SUMS` da pasta de versão e rode `sudo bash instalar_office_v2.sh --dry-run`. Deve terminar com código 0 (`echo $?`).
2. Abra o Terminal do Recovery do Mac de bancada, rode o script e confirme que ele aborta com código 9. Se instalar ou der outro erro, a detecção de Recovery não serve e precisa ser trocada.
3. Antes de cada cenário, deixe o Mac sem Office (apague os cinco apps Microsoft de `/Applications` ou use um Mac recém-formatado), com relógio correto e usuário administrador.
4. Em uma segunda janela do Terminal, acompanhe o log: `sudo tail -f /var/log/office_setup.log`. Guarde o log, o código de saída e o tempo de cada tentativa.

### Cenário 1: pendrive removido

1. **1A, durante a cópia.** Inicie a instalação e, assim que o log mostrar “Copiando instalador”, puxe o pendrive.
2. **1B, durante a instalação.** Reconecte, rode de novo e, quando o log mostrar “Instalando”, puxe o pendrive.
3. **1C, logo no início.** Rode de novo e puxe o pendrive nos primeiros 3 segundos, antes de qualquer mensagem de cópia.
4. Depois de cada tentativa, confira `echo $?`, `ls /private/var/tmp | grep office_setup` e `ls /Applications | grep Microsoft`.

**Esperado:** em 1A e 1C o script sai com código 10 e a mensagem “Nada foi instalado”, sem sobrar pasta `office_setup.*` e sem app Microsoft. Em 1B a instalação **termina normalmente** (código 0, cinco apps), porque o `installer` lê da cópia local. Reconectar o pendrive e rodar de novo depois de 1A e 1C conclui a instalação.

**Reprova se:** aparecer erro de sintaxe ou “unexpected EOF”, o script travar, sobrar pasta temporária, ou o Office ficar parcial (app que não abre).

### Cenário 2: perda de Wi-Fi e internet

1. **2A, sem rede desde o início.** Desligue o Wi-Fi e desconecte qualquer cabo; rode o script inteiro.
2. **2B, Wi-Fi ligado sem internet.** Conecte a um hotspot de celular com os dados desligados (ou a uma rede com portal cativo) e rode de novo. Cronometre a etapa de assinatura.
3. **2C, queda no meio.** Com Wi-Fi funcionando, desligue-o assim que o log mostrar “Instalando”.

**Esperado:** nos três casos o resultado é código 0 e cinco apps. Em 2B a etapa de assinatura não passa de cerca de 60 s; se estourar, o log mostra o aviso de tempo excedido e a instalação segue. O log não pode pedir rede em nenhum ponto. A ativação da licença do Office exige internet depois; avise o cliente disso.

**Reprova se:** o script esperar mais de 90 s em qualquer etapa sem rede, falhar por falta de rede, ou o tempo total ficar muito acima do teste com rede.

### Cenário 3: energia

1. **3A, na bateria.** Com a bateria acima de 50%, tire o carregador e rode o script.
2. **3B, carregador mas bateria baixa.** Deixe a bateria abaixo de 30% (descarregue, ou use um Mac de bateria fraca), conecte o carregador e rode. Espere carregar até 30% e rode de novo.
3. **3C, carregador removido no meio.** Com bateria acima de 30% e carregador, comece a instalar e, com o log em “Instalando”, tire o carregador. Ponha de volta só depois do fim.
4. **3D, opcional e destrutivo, só em Mac de bancada.** Segure o botão de ligar durante a instalação para simular queda brusca; religue e rode o script outra vez.

**Esperado:** 3A e 3B saem com código 6 antes de copiar qualquer arquivo; 3B passa depois de carregar. Em 3C a instalação termina (código 0) sem o Mac dormir ou desligar, e o `caffeinate` impede a suspensão do sistema. Em 3D o Mac liga normalmente e a nova execução recupera tudo, com os cinco apps abrindo (um corte brusco não dá chance ao script de registrar nada).

**Reprova se:** o script começar a copiar com o Mac na bateria, o Mac suspender durante a instalação, ou a nova execução em 3D não recuperar o Office.

### Registro de aprovação

| Cenário | Mac 1 (HD, USB 2.0) | Mac 2 (SSD) | Log arquivado |
| --- | --- | --- | --- |
| 1A pendrive removido na cópia |  |  |  |
| 1B pendrive removido na instalação |  |  |  |
| 1C pendrive removido no início |  |  |  |
| 2A sem rede |  |  |  |
| 2B Wi-Fi sem internet |  |  |  |
| 2C queda de Wi-Fi no meio |  |  |  |
| 3A na bateria |  |  |  |
| 3B bateria abaixo de 30% |  |  |  |
| 3C carregador removido no meio |  |  |  |

Só libere o pendrive para venda com todas as linhas aprovadas nos dois Macs, ou com cada falha corrigida e o cenário repetido.
