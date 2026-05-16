#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
REPO="shoojai/azgardianz"
GH="${GH:-/opt/homebrew/bin/gh}"

if [[ ! -x "$GH" ]]; then
  echo "Install GitHub CLI: brew install gh"
  exit 1
fi

if ! "$GH" auth status &>/dev/null; then
  echo "→ เปิดเบราว์เซอร์ให้ login GitHub (ครั้งเดียว)"
  "$GH" auth login -h github.com -p https -w -s repo,workflow
fi

"$GH" auth setup-git
echo "→ Push โค้ดขึ้น GitHub..."
git push -u origin main

echo "→ เปิด GitHub Pages (deploy ผ่าน Actions)..."
if "$GH" api "repos/$REPO/pages" &>/dev/null; then
  "$GH" api -X PUT "repos/$REPO/pages" -f build_type=workflow
else
  "$GH" api -X POST "repos/$REPO/pages" -f build_type=workflow
fi

echo ""
echo "✓ เสร็จแล้ว"
echo "  Repo:  https://github.com/$REPO"
echo "  เว็บ:  https://shoojai.github.io/azgardianz/"
echo "  (รอ Actions 1–2 นาที แล้วรีเฟรช)"
