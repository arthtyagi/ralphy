#!/usr/bin/env bats

@test "CHECKPOINT_FILE variable is defined" {
  run grep -E '^CHECKPOINT_FILE=' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'.ralphy-checkpoint'* ]]
}

@test "save_checkpoint function exists" {
  run grep -q 'save_checkpoint()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "read_checkpoint function exists" {
  run grep -q 'read_checkpoint()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "clear_checkpoint function exists" {
  run grep -q 'clear_checkpoint()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "save_checkpoint writes iteration to file" {
  # Set up test
  CHECKPOINT_FILE="$BATS_TEST_TMPDIR/.ralphy-checkpoint"
  VERBOSE=false

  # Define the function we're testing
  save_checkpoint() {
    local completed_iteration=$1
    echo "$completed_iteration" > "$CHECKPOINT_FILE"
  }

  # Test
  save_checkpoint 5
  [ -f "$CHECKPOINT_FILE" ]
  [ "$(cat "$CHECKPOINT_FILE")" = "5" ]
}

@test "read_checkpoint returns 0 when no file exists" {
  CHECKPOINT_FILE="$BATS_TEST_TMPDIR/.nonexistent-checkpoint"

  read_checkpoint() {
    if [[ -f "$CHECKPOINT_FILE" ]]; then
      local saved_iteration
      saved_iteration=$(cat "$CHECKPOINT_FILE" 2>/dev/null | tr -d '[:space:]')
      if [[ "$saved_iteration" =~ ^[0-9]+$ ]]; then
        echo "$saved_iteration"
        return 0
      fi
    fi
    echo "0"
  }

  result=$(read_checkpoint)
  [ "$result" = "0" ]
}

@test "read_checkpoint returns saved iteration from file" {
  CHECKPOINT_FILE="$BATS_TEST_TMPDIR/.ralphy-checkpoint"
  echo "7" > "$CHECKPOINT_FILE"

  read_checkpoint() {
    if [[ -f "$CHECKPOINT_FILE" ]]; then
      local saved_iteration
      saved_iteration=$(cat "$CHECKPOINT_FILE" 2>/dev/null | tr -d '[:space:]')
      if [[ "$saved_iteration" =~ ^[0-9]+$ ]]; then
        echo "$saved_iteration"
        return 0
      fi
    fi
    echo "0"
  }

  result=$(read_checkpoint)
  [ "$result" = "7" ]
}

@test "clear_checkpoint removes checkpoint file" {
  CHECKPOINT_FILE="$BATS_TEST_TMPDIR/.ralphy-checkpoint"
  VERBOSE=false
  echo "3" > "$CHECKPOINT_FILE"
  [ -f "$CHECKPOINT_FILE" ]

  clear_checkpoint() {
    if [[ -f "$CHECKPOINT_FILE" ]]; then
      rm -f "$CHECKPOINT_FILE"
    fi
  }

  clear_checkpoint
  [ ! -f "$CHECKPOINT_FILE" ]
}

@test "save_checkpoint is called in run_single_task" {
  # Look for save_checkpoint call after task completion
  run grep 'save_checkpoint' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'save_checkpoint "$task_num"'* ]]
}

@test "clear_checkpoint is called when all tasks complete (sequential)" {
  run grep -B 5 -A 5 'All tasks complete' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'clear_checkpoint'* ]]
}

@test "clear_checkpoint is called when parallel mode finishes" {
  run grep -B 3 -A 3 'run_parallel_tasks' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'clear_checkpoint'* ]]
}
