#!/bin/bash
# セッション終了時に、読み込んだ plan ファイルを .pending-review に記録

input=$(cat)
transcript_path=$(echo "$input" | grep -o '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*:.*"\([^"]*\)"/\1/')

if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
  exit 0
fi

# transcript から plan ファイルの Read を検索
plan_files=$(grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*\.claude/plans/[^"]*\.md"' "$transcript_path" | \
  sed 's/.*"\([^"]*\)"/\1/' | sort -u)

if [ -z "$plan_files" ]; then
  exit 0
fi

# 未完了の plan ファイルを .pending-review に記録
pending_file="$HOME/.claude/plans/.pending-review"
: > "$pending_file"  # ファイルをクリア

for f in $plan_files; do
  if [ -f "$f" ]; then
    status=$(sed -n '/^---$/,/^---$/p' "$f" | grep -E '^status:' | head -1 | sed 's/status:[[:space:]]*//')
    if [ "$status" != "completed" ]; then
      echo "$f" >> "$pending_file"
    fi
  fi
done

# 空ファイルなら削除
if [ ! -s "$pending_file" ]; then
  rm -f "$pending_file"
fi

exit 0
