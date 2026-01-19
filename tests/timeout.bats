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

@test "run_ai_command captures wait exit code for timeout detection" {
  run grep -A 20 'Wait for AI to finish' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'ai_exit_code=0'* ]]
  [[ "$output" == *'wait "$ai_pid"'* ]]
  [[ "$output" == *'ai_exit_code=$?'* ]]
}

@test "run_ai_command checks for timeout exit code 124" {
  run grep -A 50 'Wait for AI to finish' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'ai_exit_code -eq 124'* ]]
  [[ "$output" == *'timed out after'* ]]
  [[ "$output" == *'$AI_TIMEOUT seconds'* ]]
}

@test "run_parallel_agent captures exit code for timeout detection" {
  run grep -A 200 'run_parallel_agent()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'local cmd_exit_code=$?'* ]]
}

@test "run_parallel_agent checks for timeout exit code 124" {
  run grep -A 200 'run_parallel_agent()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'cmd_exit_code -eq 124'* ]]
  [[ "$output" == *'timed out after'* ]]
}
