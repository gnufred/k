#!/usr/bin/env bats

load 'helper'

@test "space trimming" {
  assert_expansion "get pods"    "get pods"
  assert_expansion " get pods"   "get pods"
  assert_expansion "get pods "   "get pods"
  assert_expansion " get pods "  "get pods"
  assert_expansion " get  pods " "get pods"
  assert_expansion "g po"        "get pods"
  assert_expansion " g po"       "get pods"
  assert_expansion "g po "       "get pods"
  assert_expansion " g po "      "get pods"
  assert_expansion " g  po "     "get pods"
  assert_expansion "  g   po  "  "get pods"
}
