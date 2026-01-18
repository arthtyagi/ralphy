#!/usr/bin/env bats

@test "run_parallel_agent uses agent-specific progress file" {
  # Verify agent-specific progress file variable is declared
  run grep 'progress-agent-\$agent_num' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "agent prompt instructs to write to agent-specific progress file" {
  # Verify the prompt tells agents to use their specific file
  run grep 'NOT progress.txt' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "merge_agent_progress_files function exists" {
  run grep -q 'merge_agent_progress_files()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}

@test "merge_agent_progress_files is called after parallel tasks" {
  run grep -B 5 'return 0' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'merge_agent_progress_files'* ]]
}

@test "merge_agent_progress_files finds progress-agent-*.txt files" {
  run grep -A 5 'merge_agent_progress_files()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *"progress-agent-*.txt"* ]]
}

@test "merge_agent_progress_files uses version sort for correct ordering" {
  # sort -V ensures agent-1, agent-2, ... agent-10 order (not lexicographic)
  run grep -A 5 'merge_agent_progress_files()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'sort -V'* ]]
}

@test "merge_agent_progress_files appends to progress.txt" {
  run grep -A 15 'merge_agent_progress_files()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'>> progress.txt'* ]]
}

@test "merge_agent_progress_files cleans up agent files after merge" {
  run grep -A 20 'merge_agent_progress_files()' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'rm -f "$pfile"'* ]]
}

@test "agent progress file is copied to ORIGINAL_DIR before successful cleanup" {
  # Verify the copy happens before cleanup_agent_worktree on success path
  run grep -B 3 'Cleanup worktree (but keep branch)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'cp "$worktree_dir/$progress_file" "$ORIGINAL_DIR/$progress_file"'* ]]
}

@test "agent progress file is copied to ORIGINAL_DIR on failure before cleanup" {
  # Verify the copy happens before cleanup_agent_worktree on failure path (else branch)
  run grep -A 5 'Copy agent progress file to original directory before worktree cleanup (even on failure)' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'cp "$worktree_dir/$progress_file" "$ORIGINAL_DIR/$progress_file"'* ]]
}

@test "agent progress file is copied before no-commit failure cleanup" {
  # Verify the copy happens in the commit_count == 0 failure path
  run grep -A 10 'No new commits created' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'cp "$worktree_dir/$progress_file" "$ORIGINAL_DIR/$progress_file"'* ]]
}

@test "copy uses -s flag to check file exists and is non-empty" {
  # The copy should only occur if the progress file exists and has content
  run grep 'worktree_dir/\$progress_file' "$BATS_TEST_DIRNAME/../ralphy.sh"
  [[ "$output" == *'-s "$worktree_dir/$progress_file"'* ]]
}
