#!/usr/bin/env bats

load 'helper'

@test "no mutation" {
  assert_expansion "g po" "get pods"
}

@test "event sort: no expansions" {
  assert_expansion "get events" "get events --sort-by='.lastTimestamp'"
}

@test "event sort: current namespace" {
  assert_expansion "g ev" "get events --sort-by='.lastTimestamp'"
}

@test "event sort: all namespaces" {
  assert_expansion "g ev -A" "get events --all-namespaces --sort-by='.lastTimestamp'"
}

@test "event sort: no overrides" {
  assert_expansion "g ev --sort-by='.firstTimestamp'" "get events --sort-by='.firstTimestamp'"
}

# https://github.com/gnufred/k/issues/41
@test "event sort: with namespace" {
  assert_expansion "-n mykube g ev" "--namespace mykube get events --sort-by='.lastTimestamp'"
}
