#!/usr/bin/env bats

# Tests for Qwen-Code output format validation and fallback parsing

@test "Qwen parsing: case block exists in parse_ai_result" {
  run grep -A 50 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"stream-json parsing with format validation and fallback"* ]]
}

@test "Qwen parsing: is_error field validation exists" {
  run grep -A 20 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'is_error'* ]]
  [[ "$output" == *'.is_error // false'* ]]
}

@test "Qwen parsing: handles is_error=true case" {
  run grep -A 20 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'is_error" == "true"'* ]]
  [[ "$output" == *"Qwen-Code reported an error"* ]]
}

@test "Qwen parsing: fallback 1 - assistant message content array" {
  run grep -A 30 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'Fallback 1'* ]]
  [[ "$output" == *'"type":"assistant"'* ]]
  [[ "$output" == *'.message.content[0].text'* ]]
}

@test "Qwen parsing: fallback 2 - text field extraction via regex" {
  run grep -A 40 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'Fallback 2'* ]]
  [[ "$output" == *'"text":"'* ]]
}

@test "Qwen parsing: fallback 3 - plain text (non-JSON) detection" {
  run grep -A 50 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'Fallback 3'* ]]
  [[ "$output" == *'non-JSON format'* ]]
  [[ "$output" == *'grep -q '* ]]
}

@test "Qwen parsing: final fallback to Task completed" {
  run grep -A 55 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'Final fallback'* ]]
  [[ "$output" == *'response="Task completed"'* ]]
}

@test "Qwen parsing: extracts input_tokens from usage" {
  run grep -A 25 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'.usage.input_tokens'* ]]
}

@test "Qwen parsing: extracts output_tokens from usage" {
  run grep -A 25 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'.usage.output_tokens'* ]]
}

@test "Qwen parsing: uses jq with error handling" {
  run grep -A 45 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  # All jq calls should have 2>/dev/null for error handling
  [[ "$output" == *'jq'*'2>/dev/null'* ]]
}

@test "Qwen parsing: primary extraction uses type:result" {
  run grep -A 10 'qwen)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *'"type":"result"'* ]]
}

@test "Qwen parsing: has 4 fallback levels" {
  # Count the fallback comments
  fallback_count=$(grep -c 'Fallback\|Final fallback' "$BATS_TEST_DIRNAME/../ralphy.sh" || echo "0")
  [ "$fallback_count" -ge 4 ]
}
