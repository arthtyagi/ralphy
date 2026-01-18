#!/usr/bin/env bats

@test "RESUME variable is defined and defaults to false" {
  run grep -E '^RESUME=' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'false'* ]]
}

@test "--resume flag is parsed in parse_args" {
  run grep -A 3 '\-\-resume)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'RESUME=true'* ]]
}

@test "--resume flag is documented in help text" {
  run grep -E '\-\-resume' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'Resume from last checkpoint'* ]]
}

@test "--resume is shown in mode display" {
  run grep 'mode_parts.*resume' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "resume logic checks for checkpoint value" {
  run grep -A 10 'Handle --resume' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'read_checkpoint'* ]]
  [[ "$output" == *'checkpoint_val'* ]]
}

@test "resume sets iteration to checkpoint value" {
  run grep -A 10 'Handle --resume' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'iteration=$checkpoint_val'* ]]
}

@test "resume logs when skipping iterations" {
  run grep -A 10 'Handle --resume' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'Resuming from checkpoint'* ]]
}

@test "resume logs when no checkpoint found" {
  run grep -A 10 'Handle --resume' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'No checkpoint found'* ]]
}

@test "resume skip logic validates checkpoint > 0" {
  run grep -A 10 'Handle --resume' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'checkpoint_val" -gt 0'* ]]
}

@test "--help includes --resume documentation" {
  cd "$BATS_TEST_DIRNAME/.."
  run ./ralphy.sh --help
  [ "$status" -eq 0 ]
  [[ "$output" == *'--resume'* ]]
  [[ "$output" == *'checkpoint'* ]]
}
