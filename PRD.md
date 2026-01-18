# Ralphy Self-Improvement PRD

## Scope
Concrete fixes that prevent data loss, hangs, and incorrect behavior.
No new features. No refactoring for its own sake.

## Tasks

- [x] Bump VERSION to "3.2.0" on line 15 of ralphy.sh
- [ ] Add 10-minute timeout to AI commands using `timeout` command wrapper in run_ai_command function
- [ ] Fix ShellCheck SC2086 on line 702: change `$draft_flag` to `${draft_flag:+"$draft_flag"}`
- [ ] Add `--timeout N` flag to override default AI command timeout (default 600 seconds)
- [ ] In parallel mode, use agent-specific progress files (progress-agent-N.txt) to prevent race conditions
- [ ] Add checkpoint file (.ralphy-checkpoint) that saves iteration count after each task completion
- [ ] Add `--resume` flag that reads .ralphy-checkpoint and skips already-completed iterations
- [ ] Validate Qwen-Code output format matches expected stream-json structure or add fallback parsing
