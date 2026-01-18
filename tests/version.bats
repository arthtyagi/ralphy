#!/usr/bin/env bats

@test "VERSION variable is set to 3.2.0" {
  VERSION=$(grep -E '^VERSION=' "$BATS_TEST_DIRNAME/../ralphy.sh" | cut -d'"' -f2)
  [ "$VERSION" = "3.2.0" ]
}

@test "--version flag outputs correct version" {
  run "$BATS_TEST_DIRNAME/../ralphy.sh" --version
  [ "$status" -eq 0 ]
  [ "$output" = "Ralphy v3.2.0" ]
}
