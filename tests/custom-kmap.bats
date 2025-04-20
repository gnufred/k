#!/usr/bin/env bats

load 'helper'

create_kmap() {
  export KMAP_FILE=/tmp/.kmap.custom

  TEST_KMAP=$(cat <<'EOF'
foo=custom.resource.io
bar=barz.io/v1
EOF
  )

  echo "$TEST_KMAP" > "$KMAP_FILE"
}

destroy_kmap() {
  rm -f "$KMAP_FILE"
}

@test "custom‑alias loads from $KMAP_FILE" {
  create_kmap
  assert_expansion "get foo"  "get custom.resource.io"
  assert_expansion "g bar"    "get barz.io/v1"
  destroy_kmap
}
