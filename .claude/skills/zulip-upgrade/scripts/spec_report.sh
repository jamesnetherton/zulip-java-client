#!/bin/bash
# Usage: spec_report.sh <old-version> <new-version>   e.g. spec_report.sh 12.0 13.0
# Run from the repository root. Writes the report to stdout; specs are cached in .claude/zulip-upgrade/openapi.

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 <old-version> <new-version>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLASSPATH_FILE=target/spec-report-classpath.txt

if [ ! -s "${CLASSPATH_FILE}" ] || [ pom.xml -nt "${CLASSPATH_FILE}" ]; then
  ./mvnw -q dependency:build-classpath -Dmdep.includeScope=test -Dmdep.outputFile="${CLASSPATH_FILE}" >&2
fi

java -cp "$(cat "${CLASSPATH_FILE}")" "${SCRIPT_DIR}/SpecReport.java" "$1" "$2" . .claude/zulip-upgrade/openapi
