# Auto-MACs

Kit de formatação offline para MacBooks Intel (≤2019): um pendrive com os instaladores
do macOS (High Sierra → Sequoia) e uma partição `KIT` com scripts e pacotes de pós-instalação.

| Script | Onde roda | Comando |
| --- | --- | --- |
| `scripts/build_pendrive.sh` | Mac de bancada | `sudo bash scripts/build_pendrive.sh diskN [--dry-run]` |
| `scripts/install_office.sh` | Mac do cliente | `sudo bash /Volumes/KIT/scripts/install_office.sh` |

Nenhum dos dois foi validado em Mac real ainda.

- Briefing técnico: [docs/briefing.md](docs/briefing.md)
- Plano de testes em bancada: [docs/plano_bancada.md](docs/plano_bancada.md)
