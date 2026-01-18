#!/usr/bin/env bats

@test "AI_TIMEOUT variable is set to 600 by default" {
  AI_TIMEOUT=$(grep -E '^AI_TIMEOUT=' "$BATS_TEST_DIRNAME/../ralphy.sh" | cut -d'=' -f2 | cut -d' ' -f1)
  [ "$AI_TIMEOUT" = "600" ]
}

@test "--timeout flag is documented in help" {
  run "$BATS_TEST_DIRNAME/../ralphy.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"--timeout N"* ]]
  [[ "$output" == *"AI command timeout in seconds"* ]]
}

@test "get_timeout_cmd function exists" {
  run grep -q 'get_timeout_cmd()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "run_ai_command uses timeout_cmd variable" {
  run grep -A 100 'run_ai_command()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'timeout_cmd=$(get_timeout_cmd)'* ]]
  [[ "$output" == *'"$timeout_cmd" "$AI_TIMEOUT"'* ]]
}

@test "--timeout flag parsing exists" {
  run grep -A 3 -- '--timeout)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'AI_TIMEOUT='* ]]
}
