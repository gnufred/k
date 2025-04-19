#!/usr/bin/env bats

load 'helper'

@test "no mutation" {
  assert_expansion "g po" "get pods"
}

@test "event sorting: current namespace" {
  assert_expansion "g ev" "get events --sort-by='.lastTimestamp'"
}

@test "event sorting: all namespaces" {
  assert_expansion "g ev -A" "get events --all-namespaces --sort-by='.lastTimestamp'"
}
