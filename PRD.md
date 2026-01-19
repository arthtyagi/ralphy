# Ralphy Self-Improvement PRD

## Scope
Concrete fixes that prevent data loss, hangs, and incorrect behavior.
No new features. No refactoring for its own sake.

## Tasks

- [x] Bump VERSION to "3.2.0" on line 15 of ralphy.sh
- [x] Add 10-minute timeout to AI commands using `timeout` command wrapper in run_ai_command function
- [x] Fix ShellCheck SC2086 on line 702: change `$draft_flag` to `${draft_flag:+"$draft_flag"}`
- [x] Add `--timeout N` flag to override default AI command timeout (default 600 seconds)
- [x] In parallel mode, use agent-specific progress files (progress-agent-N.txt) to prevent race conditions
- [x] Add checkpoint file (.ralphy-checkpoint) that saves iteration count after each task completion
- [x] Add `--resume` flag that reads .ralphy-checkpoint and skips already-completed iterations
- [x] Validate Qwen-Code output format matches expected stream-json structure or add fallback parsing

## Tasks (Round 2 - Issues Found)

- [x] Add warning when `--resume` and `--parallel` are used together (resume is ignored in parallel mode)
- [x] Add `--model MODEL` flag to pass model selection to underlying AI CLI

## Tasks (Round 3 - Critical Bug)

- [x] Fix parallel mode: copy agent progress files from worktrees before cleanup, then merge (files are deleted before merge runs - merge is currently a no-op)

## Tasks (Round 4 - Code Review Fixes)

- [x] Handle timeout exit code 124 separately in run_ai_command - log "AI command timed out after N seconds" instead of generic "failed"
- [ ] Only save checkpoint after verifying PR was actually created (check gh pr create exit code before writing checkpoint)
- [ ] Fix model flag quoting in run_ai_command: use proper shell quoting `${model_flag:+"$model_flag"}` pattern
- [ ] Add data loss protection in merge_agent_progress_files - check if cat succeeds before removing source files
