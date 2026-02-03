# Gitコミットメッセージ作成

Conventional Commitsベースのコミットメッセージを生成してください。

## 言語指定

- `language = "en"`
- サマリおよび本文は英語で記述する。

## 基本フォーマット（必須）

```md
<Prefix>: <Summary (imperative/concise)>

- Change 1 (bullet point)
- Change 2 (bullet point)
- ...

Refs: #<Issue number> (optional)
BREAKING CHANGE: <content> (optional)
```

## Prefix（先頭プレフィックス）

- feat: 新機能の追加
- fix: バグ修正
- refactor: リファクタリング（挙動変更なし）
- perf: パフォーマンス改善
- test: テスト追加/修正
- docs: ドキュメント更新
- build: ビルド/依存関係の変更
- ci: CI関連の変更
- chore: 雑務（ツール設定/スクリプト等）
- style: スタイルのみの変更（コードロジック無関係）
- revert: 取り消し

必要に応じて `<Prefix>(scope):` の形式も許可（例: `fix(translation): ...`）。

## サマリ（1行目）

- 英語で簡潔に書く。末尾の句点は不要。
- 何を・なぜを短く表現。
- 文字数はおおよそ50文字以内を目安に。

## メッセージ生成の原則

- コミットメッセージは、必ず未コミットの差分（`git diff` / `git diff --cached` など）を確認したうえで生成する。
- issueタイトルやブランチ名だけから推測して書かず、実際の差分に含まれる変更内容を要約・列挙する。

## 本文（箇条書き）

- 変更点を「- 」ではじめる箇条書きで列挙。
- 可能なら「影響範囲」「移行手順」「リスク」「ロールバック方法」等も箇条書きで追記。

## 禁止事項

- 意味が伝わらない曖昧なサマリ（例: "update", "fix bug" 等の抽象的な表現）
- 箇条書きがなく、内容が把握しづらい長文だけの本文
- 静的解析や検査を無効化・迂回するだけで、実質的な改善を伴わない変更のコミット

## 例

```md
fix: Remove unnecessary debug log output

- Remove verbose log lines from user info retrieval process
- Reduce log volume while keeping necessary information

Refs: #123
```

```md
refactor: Consolidate duplicate validation logic into common function

- Extract duplicate form input check code to utility function
- Remove duplicate logic from callers to improve readability
- No behavior changes
```
