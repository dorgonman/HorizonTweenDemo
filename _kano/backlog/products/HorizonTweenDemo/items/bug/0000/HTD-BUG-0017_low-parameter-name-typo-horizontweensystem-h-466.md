---
id: HTD-BUG-0017
uid: 019c4e-2a15-7168-b8d0-42afa2089ad6
type: Bug
title: "[LOW] Parameter name typo: InTaInTweenTargetrget (HorizonTweenSystem.h:466)"
state: Proposed
priority: P3
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['code-quality', 'typo', 'readability', 'plugin']
created: 2026-02-11
updated: 2026-03-25
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: []
  blocks: []
  blocked_by: []
  duplicates: []
decisions: []
---

# Context
`HorizonTweenSystem.h:466` 附近，參數名稱有拼寫錯誤：`InTaInTweenTargetrget`

這是一個可讀性問題，影響：
- Blueprint API 顯示
- 程式碼可維護性
- IDE 自動完成

# Goal
修復參數名稱拼寫錯誤。

# Non-Goals
- 不改變參數含義
- 不影響 API 行為

# Approach
將 `InTaInTweenTargetrget` 修正為 `InTweenTarget` 或類似的正確名稱。

注意：這可能是一個破壞性改變，如果此參數已在 Blueprint 中使用，需要更新調用者。

# Alternatives
- 無（明顯的拼寫錯誤）

# Acceptance Criteria
- [ ] 參數名稱拼寫正確
- [ ] Blueprint 節點參數顯示正確

# Risks / Dependencies
- 風險：低（只影響名稱）
- 依賴：如果 API 已公開，可能需要更新文件

# Worklog
2026-02-11 23:59 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
