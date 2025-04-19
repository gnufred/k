#!/usr/bin/env bats

load 'helper'

HOME=/tmp

TEST_KMAP=$(cat <<'EOF'
foo=custom.resource.io
bar=barz.io/v1
EOF
)

create_test_kmap() {
  mkdir -p "$HOME"
  echo "$TEST_KMAP" > "$HOME/.kmap.custom"
}

@test "custom‑alias loads from $HOME/.kmap.custom" {
  create_test_kmap
  assert_expansion "get foo"  "get custom.resource.io"
  assert_expansion "g bar"    "get barz.io/v1"
  destroy_test_kmap
}

destroy_test_kmap() {
  rm -f "$HOME/.kmap.custom"
}
