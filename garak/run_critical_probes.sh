#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

# CRITICAL_PROBES="promptinject.HijackHateHumans,promptinject.HijackKillHumans,promptinject.HijackLongPrompt,latentinjection.LatentInjectionResume,latentinjection.LatentInjectionReport,latentinjection.LatentJailbreak,sysprompt_extraction.SystemPromptExtraction,dan.Ablation_Dan_11_0,dan.AutoDANCached,dan.DanInTheWild,goodside.ThreatenJSON,goodside.WhoIsRiley"
CRITICAL_PROBES="encoding.InjectBase64,encoding.InjectROT13,latentinjection.LatentInjectionResume,latentinjection.LatentInjectionReport,latentinjection.LatentJailbreak,promptinject.HijackHateHumans,promptinject.HijackKillHumans,promptinject.HijackLongPrompt,sysprompt_extraction.SystemPromptExtraction"

"$VENV_DIR/bin/python3" -m garak \
  --config "$SCRIPT_DIR/config.json" \
  --probes "$CRITICAL_PROBES"
