#!/usr/bin/env bash
# Gera URL mermaid.ink e opcionalmente baixa PNG.
# Uso:
#   render-mermaid.sh '<mermaid code>' [output.png]
#   echo 'flowchart TD; A-->B' | render-mermaid.sh

set -euo pipefail

CODE="${1:-}"
OUTPUT="${2:-}"

if [[ -z "$CODE" ]]; then
  CODE="$(cat)"
fi

if [[ -z "$CODE" ]]; then
  echo "Uso: render-mermaid.sh '<mermaid code>' [output.png]" >&2
  exit 1
fi

ENCODED="$(printf '%s' "$CODE" | python3 -c "
import sys, base64
code = sys.stdin.read()
print(base64.urlsafe_b64encode(code.encode('utf-8')).decode('ascii').rstrip('='))
")"

URL="https://mermaid.ink/img/${ENCODED}?type=png&bgColor=!white"

if [[ -n "$OUTPUT" ]]; then
  curl -fsSL "$URL" -o "$OUTPUT"
  echo "Salvo: $OUTPUT"
  echo "URL: $URL"
else
  echo "$URL"
fi
