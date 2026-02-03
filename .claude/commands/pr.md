# Pull Request作成

PRのタイトルおよび本文を生成してください。

## 言語指定

- `language = "en"`
- タイトルおよび本文は英語で記述する。

## タイトル

```text
<Prefix>: <Summary (imperative/concise)>
```

- Prefixはコミットメッセージと同様、Conventional Commitsにおける `type` を使用（feat, fix, refactor, docs, chore など）
- 英語で簡潔に書く。末尾の句点は不要。
- 50文字以内を目安に。

## 本文テンプレート

```markdown
## Overview

Summary of what was implemented/fixed in this PR

## Changes

- Description of change 1
- Description of change 2
- Description of change 3

## Technical Details (Optional)

- Implementation details and design intentions as needed

## Test Content

- Types of tests performed (unit tests, E2E tests, manual verification, etc.)
- Results of main behavior verification

## Related Issues

- Closes #123
- Refs #456
```

## メッセージ生成の原則

- PRタイトルおよび本文は、必ず実際の差分とコミット履歴（`git diff`, `git log`）を確認したうえで生成する。
- issueタイトルやブランチ名だけから推測して書かず、変更内容・影響範囲・テスト内容を本文に明示する。
- コミットメッセージ規約と整合するようにPrefixやサマリを決める。

## 禁止事項

- 意味が伝わらない曖昧なタイトル（例: "update", "fix issue", "changes" などの抽象的な表現）
- 構造化されていない長文だけの本文（セクション見出しや箇条書きがなく、内容の把握が困難なもの）
- 実際の差分と異なる内容や、重要な変更点・影響・テスト結果を意図的に省略した説明
