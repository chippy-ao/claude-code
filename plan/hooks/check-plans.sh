#!/bin/bash
# 起動時に:
# 1. .pending-review があれば Claude に AskUserQuestion で確認させる
# 2. 未完了の計画ファイルを通知

pending_file="$HOME/.claude/plans/.pending-review"
output=""

# .pending-review があれば確認を促す
if [ -f "$pending_file" ] && [ -s "$pending_file" ]; then
  plan_list=""
  while IFS= read -r f; do
    if [ -f "$f" ]; then
      title=$(sed -n '/^---$/,/^---$/p' "$f" | grep -E '^title:' | head -1 | sed 's/title:[[:space:]]*//')
      status=$(sed -n '/^---$/,/^---$/p' "$f" | grep -E '^status:' | head -1 | sed 's/status:[[:space:]]*//')
      plan_list="${plan_list}\\n- ${title:-$(basename "$f")} ($f) [status: $status]"
    fi
  done < "$pending_file"

  if [ -n "$plan_list" ]; then
    output="【前回セッションの進捗確認】以下の計画ファイルを読み込んでいました:${plan_list}\\n\\nAskUserQuestion で進捗を確認してください。選択肢:\\n- 「完了した」→ status を completed に変更、completed_at 追加、削除するか確認\\n- 「途中まで」→ どこまで進んだか確認\\n- 「何もしてない」→ 変更なし"
  fi

  rm -f "$pending_file"
fi

# 既存の未完了計画通知
plans=()
for dir in "$HOME/.claude/plans" "./.claude/plans"; do
  if [ -d "$dir" ]; then
    for f in "$dir"/*.md; do
      [ -f "$f" ] || continue
      status=$(sed -n '/^---$/,/^---$/p' "$f" | grep -E '^status:' | head -1 | sed 's/status:[[:space:]]*//')
      if [ -n "$status" ] && [ "$status" != "completed" ]; then
        title=$(sed -n '/^---$/,/^---$/p' "$f" | grep -E '^title:' | head -1 | sed 's/title:[[:space:]]*//')
        plans+=("${title:-$(basename "$f")} (status: $status)")
      fi
    done
  fi
done

# 出力
if [ -n "$output" ]; then
  # 前回セッションの確認がある場合
  cat <<EOF
{
  "systemMessage": "$output"
}
EOF
elif [ ${#plans[@]} -gt 0 ]; then
  # 未完了の計画がある場合（通知のみ）
  plan_list=$(printf '\\n- %s' "${plans[@]}")
  cat <<EOF
{
  "systemMessage": "未完了の計画があります:${plan_list}"
}
EOF
fi

exit 0
