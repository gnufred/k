#!/usr/bin/env bats

load 'helper'

@test "pods" {
  assert_expansion "g po"       "get pods"
  assert_expansion "-n ks g po" "--namespace kube-system get pods"
  assert_expansion "get po -W"  "get pods -o wide"
}

@test "get‐resource" {
  assert_expansion "g no"  "get nodes"
  assert_expansion "g svc" "get svc"
  assert_expansion "g cm"  "get configmaps"
}

@test "describe‐resource" {
  assert_expansion "d po"   "describe pods"
  assert_expansion "des cm" "describe configmaps"
  assert_expansion "d no"   "describe nodes"
}

@test "apply/delete" {
  assert_expansion "a -f foo.yaml" "apply -f foo.yaml"
  assert_expansion "del po"        "delete pods"
}

@test "logs/exec" {
  assert_expansion "l po" "logs pods"
  assert_expansion "x po" "exec pods"
}

@test "--file" {
  assert_expansion "a -f foo.yaml"   "apply -f foo.yaml"
  assert_expansion "app -f foo.yaml" "apply -f foo.yaml"
  assert_expansion "c -f foo.yaml"   "create -f foo.yaml"
  assert_expansion "cre -f foo.yaml" "create -f foo.yaml"
  assert_expansion "u -f foo.yaml"   "update -f foo.yaml"
  assert_expansion "upd -f foo.yaml" "update -f foo.yaml"
  assert_expansion "del -f foo.yaml" "delete -f foo.yaml"
}

