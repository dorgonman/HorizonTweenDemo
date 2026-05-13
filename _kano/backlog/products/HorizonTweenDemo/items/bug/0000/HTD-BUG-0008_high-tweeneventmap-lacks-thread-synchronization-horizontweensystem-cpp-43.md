---
id: HTD-BUG-0008
uid: 019c4d6c-39f8-7043-940d-45a4ae2fd870
type: Bug
title: "[HIGH] TweenEventMap lacks thread synchronization (HorizonTweenSystem.cpp:43)"
state: Proposed
priority: P1
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['thread-safety', 'race-condition', 'plugin']
created: 2026-02-11
updated: 2026-03-25
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: [HTD-BUG-0009]
  blocks: []
  blocked_by: []
  duplicates: []
decisions: []
---

# Context
`HorizonTweenSystem.cpp:43` 附近，`TweenEventMap` 的迭代和修改之間沒有同步機制。在非遊戲線程（如 Render Thread）呼叫 Tween 函數時，可能導致：

- 迭代期間 map 被修改（std::map 迭代期間不允許修改）
- 競態條件導致數據不一致

# Goal
添加執行緒安全保護，防止多線程並發訪問 `TweenEventMap` 導致的崩潰。

# Non-Goals
- 不全面重構為完全無鎖設計（過度工程）
- 不改變 API 介面

# Approach
方案 A（最小改動）：在关键操作添加 `check(IsInGameThread())` 斷言
```cpp
check(IsInGameThread() && "Tween operations must be called on game thread");
```

方案 B（完整修復）：使用 `FCriticalSection` 保護 `TweenEventMap` 的所有訪問

建議先採用方案 A 識別所有需要保護的地方，再評估是否需要方案 B。

# Alternatives
1. 文檔說明只應在遊戲線程呼叫
2. 使用 `TMap` 的 thread-safe 版本（如需要）

# Acceptance Criteria
- [ ] 非遊戲線程呼叫時有明確的錯誤提示（或安全處理）
- [ ] 遊戲線程呼叫時不受影響

# Risks / Dependencies
- 風險：添加鎖可能影響效能
- 依賴：需要識別所有對 TweenEventMap 的訪問點

# Worklog
2026-02-11 23:57 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
