---
id: HTD-BUG-0014
uid: 019c4d6d-7e7d-70a7-b152-b8d0fad9336d
type: Bug
title: "[MEDIUM] Excessive Cast checks in ByObject functions (HorizonTweenSystem.cpp:1786)"
state: Proposed
priority: P2
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['performance', 'optimization', 'type-checking', 'plugin']
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
在 `HorizonTweenSystem.cpp:1786` 附近的 `ByObject` 函數中，每個事件每次調用都執行 15+ 次類型檢查（Cast）。

這導致：
- 性能開銷大
- 代碼擴展性差（添加新類型需要更新所有函數）

# Goal
減少重複的類型檢查次數，提高性能和可維護性。

# Non-Goals
- 不改變函數的返回結果
- 不使用虛函數或 RTTI 替代

# Approach
方案 A（立即）：使用 `DoCast` 或模板避免重複 `Cast` 調用
```cpp
UHorizonTweenActorEvent* ActorEvent = Cast<UHorizonTweenActorEvent>(pEvent);
if (ActorEvent) { ... }
```

方案 B（重構）：使用 Visitor 模式或類型安全的枚舉
```cpp
enum class ETweenEventType { Actor, SceneComponent, Widget, ... };
switch(GetEventType(pEvent)) { ... }
```

# Alternatives
1. 將類型檢查結果緩存
2. 使用菱形繼承減少需要檢查的類型數

# Acceptance Criteria
- [ ] 每事件類型檢查次數顯著減少
- [ ] 性能提升明顯

# Risks / Dependencies
- 風險：重構可能引入新錯誤
- 依賴：無

# Worklog
2026-02-11 23:59 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
