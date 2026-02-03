# AI設定ファイル同期

> **Note**: このコマンドはClaude Code専用です。GeminiやCodexへの同期コマンドの作成は不要です。

`.claude`、`.gemini`、`.codex`ディレクトリの内容を同期してください。

## 実行手順

1. **全ファイルの読み取り**
   - `.claude/` ディレクトリ内の全ファイルを読み取る（CLAUDE.md、commands/*.md）
   - `.gemini/` ディレクトリ内の全ファイルを読み取る（v5.md、commit-message-format.md、pr-message-format.md、commands/*.toml）
   - `.codex/` ディレクトリ内の全ファイルを読み取る（AGENTS.md、prompts/*.md）

2. **差分の分析**
   - 3つのディレクトリ間で意味的な差分を特定する
   - 各ディレクトリにしか存在しない内容を特定する

3. **マージと同期**
   - **衝突時**: `.claude`の内容を正として採用
   - **新規追加**: `.gemini`や`.codex`にのみ存在する有用な内容は`.claude`にも追加を提案
   - 最終的に3つのディレクトリで同等の内容を持つようにする

4. **変更内容のサマリを報告**

## ディレクトリ構造のマッピング

### 基盤ルール
| Claude | Gemini | Codex |
|--------|--------|-------|
| `CLAUDE.md` | `v5.md` | `AGENTS.md` |

### カスタムコマンド
| Claude | Gemini | Codex |
|--------|--------|-------|
| `commands/commit.md` | `commands/commit.toml` + `commit-message-format.md` | `prompts/commit.md` |
| `commands/pr.md` | `commands/pr.toml` + `pr-message-format.md` | `prompts/pr.md` |
| `commands/<name>.md` | `commands/<name>.toml` | `prompts/<name>.md` |

## 同期ルール

1. **衝突時はClaudeを優先**: 同じ項目で意味が矛盾している場合は`.claude`の内容を採用
2. **新規内容はマージ**: 他のディレクトリにのみ存在する有用なルールは全てに追加を提案
3. **フォーマット変換**: 各ツール固有のフォーマットに適切に変換

## 同期対象外ファイル

- `.gemini/GEMINI.md` (参照ファイルのみ)
- `.gemini/planning-mode-guard.md` (Gemini固有)
- `.gemini/settings.json`
- `.claude/settings.local.json`

## フォーマット変換ルール

### Gemini v5.md（基盤ルール）
```yaml
---
trigger: always_on
---
# 内容
```

### Gemini commit-message-format.md / pr-message-format.md
```yaml
---
trigger: model_decision
description: <説明>
---
# 内容
```

### Gemini commands/*.toml
```toml
prompt = """
<内容>
"""
```

### Codex AGENTS.md
フロントマター不要

### Codex prompts/*.md
```yaml
---
description: <英語の説明>
---
# 内容
```

## 同期前の確認事項

同期実行前に以下を報告し、ユーザーの確認を得る：

1. 各ディレクトリにのみ存在する内容の一覧
2. 衝突している内容の一覧と、採用する内容
3. 追加・更新されるファイルの一覧
4. 削除が必要なファイル（あれば）
