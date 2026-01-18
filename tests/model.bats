#!/usr/bin/env bats

@test "AI_MODEL variable is empty by default" {
  run grep -E '^AI_MODEL=""' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "--model flag is documented in help" {
  run "$BATS_TEST_DIRNAME/../ralphy.sh" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"--model MODEL"* ]]
  [[ "$output" == *"Model name to pass to underlying AI CLI"* ]]
}

@test "--model flag parsing sets AI_MODEL variable" {
  run grep -A 3 -- '--model)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'AI_MODEL='* ]]
  [[ "$output" == *'shift 2'* ]]
}

@test "run_ai_command constructs model_flag when AI_MODEL is set" {
  run grep -A 10 'run_ai_command()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'model_flag=""'* ]]
  [[ "$output" == *'[[ -n "$AI_MODEL" ]] && model_flag="--model $AI_MODEL"'* ]]
}

@test "Claude Code command includes model_flag placeholder" {
  run grep -A 100 'run_ai_command()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'claude --dangerously-skip-permissions'* ]]
  [[ "$output" == *'${model_flag:+$model_flag}'* ]]
}

@test "OpenCode command includes model_flag placeholder" {
  run grep -A 100 'run_ai_command()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'opencode run'* ]]
  [[ "$output" == *'${model_flag:+$model_flag}'* ]]
}

@test "Cursor command includes model_flag placeholder" {
  run grep -A 100 'run_ai_command()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'agent --print --force'* ]]
  [[ "$output" == *'${model_flag:+$model_flag}'* ]]
}

@test "Codex command includes model_flag placeholder" {
  run grep -A 100 'run_ai_command()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'codex exec --full-auto'* ]]
  [[ "$output" == *'${model_flag:+$model_flag}'* ]]
}

@test "Qwen command includes model_flag placeholder" {
  run grep -A 100 'run_ai_command()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'qwen --output-format stream-json'* ]]
  [[ "$output" == *'${model_flag:+$model_flag}'* ]]
}

@test "AI_MODEL is exported for parallel mode" {
  run grep -E 'export.*AI_MODEL' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'AI_MODEL'* ]]
}

@test "Model is displayed in mode when set" {
  run grep -E 'mode_parts.*model' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'model:$AI_MODEL'* ]]
}

@test "run_parallel_agent constructs model_flag when AI_MODEL is set" {
  run grep -A 200 'run_parallel_agent()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'model_flag=""'* ]]
  [[ "$output" == *'[[ -n "$AI_MODEL" ]] && model_flag="--model $AI_MODEL"'* ]]
}
