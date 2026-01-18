#!/usr/bin/env bats

@test "draft_flag uses safe parameter expansion in gh pr create" {
  # SC2086: Verify draft_flag uses ${draft_flag:+"$draft_flag"} pattern
  # to prevent word splitting and globbing issues
  run grep -E '\$\{draft_flag:\+"\$draft_flag"\}' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "draft_flag is not used unquoted in gh pr create" {
  # Ensure the old unquoted pattern is not present
  # (would match '$draft_flag' followed by space or 2)
  run grep -E 'gh pr create.*[^}]\$draft_flag[[:space:]]' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -ne 0 ]
}
