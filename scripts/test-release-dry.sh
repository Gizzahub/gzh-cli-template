#!/usr/bin/env bash
# Test the real release entrypoint; retain owned fixtures/logs under ignored tmp/.
set -euo pipefail

# Never let caller Git redirects or signing configuration escape the owned fixture.
while IFS= read -r variable; do
  unset "$variable"
done < <(compgen -v GIT_)
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
export GIT_CONFIG_COUNT=2
export GIT_CONFIG_KEY_0=core.hooksPath GIT_CONFIG_VALUE_0=/dev/null
export GIT_CONFIG_KEY_1=commit.gpgsign GIT_CONFIG_VALUE_1=false

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
case ${1-} in
  ''|--guard-only|--prepare-only) ;;
  *) printf 'usage: %s [--guard-only|--prepare-only]\n' "$0" >&2; exit 2 ;;
esac
# Generated repositories no longer have the raw-template contract to exercise.
marker_status=0
grep -q '__PROJECT_' "$root/go.mod" || marker_status=$?
if [[ $marker_status == 1 ]]; then
  printf 'release guard regression applies to the raw template only\n'
  exit 0
elif [[ $marker_status != 0 ]]; then
  printf 'cannot inspect project markers\n' >&2
  exit "$marker_status"
fi
mkdir -p "$root/tmp"
work=$(mktemp -d "$root/tmp/release-dry.XXXXXXXX")
printf 'Owned release verification fixture: %s\n' "$work"
printf '{"owner":"release-dry-test","purpose":"rendered-release-verification","source":"%s"}\n' \
  "$(git -C "$root" rev-parse HEAD)" >"$work/owner.json"
# Include the current authoring diff, excluding ignored outputs and private files.
mkdir "$work/project"
git -C "$root" ls-files -z --cached --others --exclude-standard >"$work/files"
(cd "$root" && tar --null -T "$work/files" -cf -) | (cd "$work/project" && tar -xf -)
project=$work/project
cp "$project/go.mod" "$work/go.mod.before"
cp "$project/go.sum" "$work/go.sum.before"
status=0
make -C "$project" --no-print-directory release-dry >"$work/raw.log" 2>&1 || status=$?
if [[ $status == 0 ]]; then
  printf 'raw template unexpectedly accepted release-dry\n' >&2
  exit 1
fi
grep -q 'release-dry requires a rendered project' "$work/raw.log"
cmp "$work/go.mod.before" "$project/go.mod"
cmp "$work/go.sum.before" "$project/go.sum"
[[ ! -e "$project/bin" && ! -e "$project/dist" ]]
printf 'Raw-template guard PASS (exit %s, module files unchanged)\n' "$status"
if [[ ${1-} == --guard-only ]]; then
  exit 0
fi
(cd "$project" && bash scripts/init-project.sh release-probe) >"$work/initialize.log" 2>&1
[[ -d "$project/cmd/release-probe" && ! -e "$project/cmd/"'__PROJECT_NAME__' ]]
# GoReleaser needs repository provenance, owned only by this disposable fixture.
git -C "$project" init -q
git -C "$project" add .
git -C "$project" -c user.name='Release fixture' -c user.email='fixture@example.invalid' \
  -c core.hooksPath=/dev/null commit -qm $'test(fixture): initialize rendered release fixture\n\nModel: gpt-6.1-sol'
if [[ ${1-} == --prepare-only ]]; then
  printf 'Rendered fixture preparation PASS: %s\n' "$work"
  exit 0
fi
# The existing target owns tool pin validation, hooks, archives and snapshot semantics.
make -C "$project" --no-print-directory release-dry >"$work/rendered-release.log" 2>&1
[[ -s "$project/dist/checksums.txt" ]]
printf 'Rendered fixture release PASS; retained logs: %s\n' "$work"
