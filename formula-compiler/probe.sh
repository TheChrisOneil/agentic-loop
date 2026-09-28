#!/usr/bin/env bash
# Re-derive Gas City's formula validation rules from the installed gc.
#
# Builds a throwaway city in a temp dir — never registered, so no controller
# and no patrol ever runs against it — drops one deliberately malformed
# formula at a time, and records what the compiler says.
#
# The output of this script IS the rule list. Do not maintain the rule list
# by hand; run this against whatever gc is installed and diff it.
set -u
command -v gc >/dev/null || { echo "REFUSED: gc is not installed." >&2; exit 1; }
CITY=$(mktemp -d); trap 'rm -rf "$CITY"' EXIT
mkdir -p "$CITY/formulas"
cat > "$CITY/city.toml" <<'EOF'
[workspace]
provider = "claude"
[providers]
[providers.claude]
base = "builtin:claude"
EOF

HDR='formula = "%s"
version = 1
description = "d"
[requires]
formula_compiler = ">=2.0.0"
[catalog]
name = "%s"
description = "d"
'

probe() {                       # $1 = case name, stdin = the steps section
  local name=$1 body
  body=$(cat)
  { printf "$HDR" "$name" "$name"; printf '%s\n' "$body"; } > "$CITY/formulas/$name.formula.toml"
  printf '%-22s ' "$name"
  gc formula show "$name" --city "$CITY" 2>&1 \
    | grep -v '^warning: this city does not import' \
    | grep -E '^\s+- |^gc formula show: .*(cycle|failed)' \
    | sed 's/^ *- //' | tr '\n' '|' | sed 's/|$//'
  echo
  rm -f "$CITY/formulas/$name.formula.toml"
}

echo "gc version: $(gc --version 2>/dev/null | head -1)"
echo

probe duplicate-id <<'EOF'
[[steps]]
id = "a"
title = "A"
[[steps]]
id = "a"
title = "A2"
EOF

probe needs-unknown <<'EOF'
[[steps]]
id = "a"
title = "A"
needs = ["nope"]
EOF

probe dependency-cycle <<'EOF'
[[steps]]
id = "a"
title = "A"
needs = ["b"]
[[steps]]
id = "b"
title = "B"
needs = ["a"]
EOF

probe step-no-id <<'EOF'
[[steps]]
title = "A"
EOF

probe step-no-title <<'EOF'
[[steps]]
id = "a"
EOF

probe check-bad-mode <<'EOF'
[[steps]]
id = "a"
title = "A"
[steps.check]
max_attempts = 1
[steps.check.check]
mode = "banana"
path = "x.sh"
EOF

probe check-no-path <<'EOF'
[[steps]]
id = "a"
title = "A"
[steps.check]
max_attempts = 1
[steps.check.check]
mode = "exec"
EOF

probe check-no-attempts <<'EOF'
[[steps]]
id = "a"
title = "A"
[steps.check.check]
mode = "exec"
path = "x.sh"
EOF

probe retry-bad-exhausted <<'EOF'
[[steps]]
id = "a"
title = "A"
[steps.retry]
max_attempts = 2
on_exhausted = "banana"
EOF

probe drain-bad-values <<'EOF'
[[steps]]
id = "a"
title = "A"
[steps.drain]
context = "banana"
member_access = "banana"
on_item_failure = "banana"
EOF

echo
echo "--- accepted without complaint (the compiler does NOT enforce these) ---"
probe no-steps-at-all <<'EOF'
EOF
probe step-no-description <<'EOF'
[[steps]]
id = "a"
title = "A"
EOF
probe undeclared-template-var <<'EOF'
[[steps]]
id = "a"
title = "A"
description = "uses {{nosuchvar}}"
EOF
probe unknown-top-level-key <<'EOF'
bogus_key = 42
[[steps]]
id = "a"
title = "A"
EOF
probe check-script-absent <<'EOF'
[[steps]]
id = "a"
title = "A"
[steps.check]
max_attempts = 1
[steps.check.check]
mode = "exec"
path = ".gc/scripts/checks/definitely-not-there.sh"
EOF
