# Garak Security Testing

This folder contains the configuration and scripts used to run adversarial security tests against the RAG copilot using <a href="https://github.com/NVIDIA/garak" target="_blank">Garak</a>, an open-source LLM vulnerability scanner developed by NVIDIA.

---

## What it does

Garak sends adversarial prompts to the copilot's REST endpoint and measures how often the model can be manipulated into ignoring its instructions or producing harmful output. The probes cover DAN jailbreaks, role-play persona hijacks, latent injection hidden inside retrieved documents, and system prompt extraction attempts.

Each run produces a **report** and a **hit log**. The hit log contains the exact prompt and model output for every successful attack, making it straightforward to identify weaknesses and harden the system prompt accordingly.

---

## Scripts

- **`garak_setup.sh`** — Sets up the Python virtual environment and installs Garak if not already present.
- **`run_critical_probes.sh`** — Runs the curated set of critical probes against the copilot endpoint.
- **`format_hitlogs.sh`** — Parses raw `.hitlog.jsonl` files and writes a clean `.hitlog.formatted.json` for each one.
- **`cleanup_jsonl.sh`** — Deletes raw report and hit log files. Pass `--formatted` to also delete the formatted hit logs.

---

## Output files

| File | Description |
|---|---|
| `*.report.jsonl` | Full run report with all probe attempts and scores |
| `*.report.html` | Human-readable HTML summary of the run |
| `*.hitlog.jsonl` | Raw log of every successful attack |
| `*.hitlog.formatted.json` | Cleaned-up version with only the relevant fields |
