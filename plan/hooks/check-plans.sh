#!/bin/bash
# セッション開始時に未完了の計画があれば通知する
# 操作は /plan:check コマンドで行う

plans=()

# plans フォルダをスキャン
for dir in "$HOME/.claude/plans" "./.claude/plans"; do
  if [ -d "$dir" ]; then
    for f in "$dir"/*.md; do
      [ -f "$f" ] || continue
      # 隠しファイルは除外
      basename "$f" | grep -q '^\.' && continue

      status=$(sed -n '/^---$/,/^---$/p' "$f" | grep -E '^status:' | head -1 | sed 's/status:[[:space:]]*//')
      if [ -n "$status" ] && [ "$status" != "completed" ]; then
        title=$(sed -n '/^---$/,/^---$/p' "$f" | grep -E '^title:' | head -1 | sed 's/title:[[:space:]]*//')
        plans+=("- ${title:-$(basename "$f")} (${status})")
      fi
    done
  fi
done

# 未完了の計画がある場合のみ出力
if [ ${#plans[@]} -gt 0 ]; then
  # JSON 文字列として有効にするため、改行を \n にエスケープ
  plan_list=$(printf '%s\\n' "${plans[@]}" | sed 's/\\n$//')
  cat <<EOF
{
  "systemMessage": "未完了の計画があります:\\n${plan_list}\\n\\n/plan:check で整理できます"
}
EOF
fi

exit 0
