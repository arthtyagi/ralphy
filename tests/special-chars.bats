#!/usr/bin/env bats

@test "escaped_task regex escapes [ character" {
  result=$(echo 'Task with [ bracket' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Task with \[ bracket' ]]
}

@test "escaped_task regex escapes ] character" {
  result=$(echo 'Task with ] bracket' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Task with \] bracket' ]]
}

@test "escaped_task regex escapes both brackets" {
  result=$(echo 'Fix handling of special character ] in task parsing' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Fix handling of special character \] in task parsing' ]]
}

@test "escaped_task regex escapes . character" {
  result=$(echo 'Fix bug in file.txt' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Fix bug in file\.txt' ]]
}

@test "escaped_task regex escapes * character" {
  result=$(echo 'Match all *.js files' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Match all \*\.js files' ]]
}

@test "escaped_task regex escapes ^ character" {
  result=$(echo 'Task with ^ caret' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Task with \^ caret' ]]
}

@test "escaped_task regex escapes $ character" {
  result=$(echo 'Task with $var' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Task with \$var' ]]
}

@test "escaped_task regex escapes / character" {
  result=$(echo 'Fix path/to/file' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Fix path\/to\/file' ]]
}

@test "escaped_task regex escapes multiple special chars" {
  result=$(echo 'Fix [bug] in *.txt for $HOME/path' | sed 's/[][\.*^$/]/\\&/g')
  [[ "$result" == 'Fix \[bug\] in \*\.txt for \$HOME\/path' ]]
}

@test "mark_task_complete_markdown uses correct escape pattern" {
  run grep "sed 's/\[\]\[" "$BATS_TEST_DIRNAME/../ralphy.sh"
  [ "$status" -eq 0 ]
}
