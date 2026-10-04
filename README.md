# Auto-MACs

Kit de formatação offline para MacBooks Intel (≤2019): um pendrive com os instaladores
do macOS (High Sierra → Sequoia) e uma partição `KIT` com o instalador do Office para o cliente.

| Script | Quem usa | Como |
| --- | --- | --- |
| `scripts/build_pendrive.sh` | Técnico, no Mac de montagem | `sudo bash scripts/build_pendrive.sh diskN [--dry-run]` |
| `Instalar Office.command` (na KIT) | Cliente | Dois cliques no arquivo; ele pede a senha do Mac |

O Office é baixado da Microsoft na hora (precisa de internet e da licença do cliente) e só
funciona em **macOS 12 ou mais novo** (Macs de 2015 em diante). Nada foi validado em Mac real ainda.

- Briefing técnico: [docs/briefing.md](docs/briefing.md) · Decisões: [docs/decisoes.md](docs/decisoes.md)
- Plano de bancada do pendrive (prioridade): [docs/plano_bancada_pendrive.md](docs/plano_bancada_pendrive.md)
- Plano de bancada do Office: [docs/plano_bancada.md](docs/plano_bancada.md)
- Piloto nos Macs do cliente: [docs/roteiro_piloto.md](docs/roteiro_piloto.md) · [docs/termo_piloto.md](docs/termo_piloto.md)
