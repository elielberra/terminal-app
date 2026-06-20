# Setup

## Requirements

- Python 3.10+
- The `rag-chain` service running locally with `LOCAL_SECURITY_TESTING=true` (see `rag-chain/.env`)

---

## Install

Run the setup script once to create the virtual environment and install Garak:

```bash
bash garak/garak_setup.sh
```

---

## Configuration

Copy `config.example` to `config.json` and fill in the required values:

```bash
cp garak/config.example garak/config.json
```

Set `report_dir` to the absolute path where you want reports written. The other defaults are suitable for a standard local run.

---

## Running tests

Activate the virtual environment and run the critical probes:

```bash
cd garak
source .venv/bin/activate
bash run_critical_probes.sh
```

To run a specific probe manually:

```bash
python -m garak --config config.json --probes promptinject.HijackHateHumans
```

---

## Reading results

Format the hit logs after a run to get a readable summary of every successful attack:

```bash
bash garak/format_hitlogs.sh
```

Open the generated `*.report.html` in a browser for a visual overview, or inspect `*.hitlog.formatted.json` for the exact prompts and outputs that bypassed the model.

To clean up output files between runs:

```bash
bash garak/cleanup_jsonl.sh           # keeps formatted hit logs
bash garak/cleanup_jsonl.sh --formatted  # deletes everything
```
