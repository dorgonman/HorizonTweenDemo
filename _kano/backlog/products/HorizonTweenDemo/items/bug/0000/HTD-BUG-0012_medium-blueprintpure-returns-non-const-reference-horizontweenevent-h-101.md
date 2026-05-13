---
id: HTD-BUG-0012
uid: 019c4d6d-17ec-771a-800f-a56afb2b4803
type: Bug
title: "[MEDIUM] BlueprintPure returns non-const reference (HorizonTweenEvent.h:101)"
state: Proposed
priority: P2
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['code-quality', 'blueprint', 'pure-function', 'plugin']
created: 2026-02-11
updated: 2026-03-25
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: [HTD-BUG-0004]
  blocks: []
  blocked_by: []
  duplicates: []
decisions: []
---

# Context
在 `HorizonTweenEvent.h:101` 附近，一個 `BlueprintPure` 函數返回非 const 引用：

```cpp
UFUNCTION(BlueprintPure, ...)
FHorizonTweenEventParameters& GetTweenEventParam();
```

`BlueprintPure` 函數承諾沒有副作用，但返回非 const 引用允許調用者修改內部狀態，違反了 Pure 函數的約定。

# Goal
將返回類型改為 const 引用，符合 BlueprintPure 的約定。

# Non-Goals
- 不改變函數的實際功能

# Approach
```cpp
UFUNCTION(BlueprintPure, ...)
const FHorizonTweenEventParameters& GetTweenEventParam() const;
```

注意：這可能是一個破壞性改變，需要檢查所有調用者。

# Alternatives
1. 如果確實需要修改，返回值應為副本而非引用
2. 移除 BlueprintPure 標記

# Acceptance Criteria
- [ ] `BlueprintPure` 函數不再返回可修改的引用
- [ ] 所有調用者仍然能正常工作

# Risks / Dependencies
- 風險：可能破壞現有調用代碼
- 依賴：需要全面測試

# Worklog
2026-02-11 23:58 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
