#!/usr/bin/env bats

load 'helper'

@test "watch pods" {
  assert_expansion "w g po" "get pods"
}
