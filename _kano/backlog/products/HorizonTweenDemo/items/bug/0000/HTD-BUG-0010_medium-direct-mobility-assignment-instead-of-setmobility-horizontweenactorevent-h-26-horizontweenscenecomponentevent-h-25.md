---
id: HTD-BUG-0010
uid: 019c4d6c-b4eb-72c3-b932-b2125ad1e14a
type: Bug
title: "[MEDIUM] Direct Mobility assignment instead of SetMobility (HorizonTweenActorEvent.h:26, HorizonTweenSceneComponentEvent.h:25)"
state: Proposed
priority: P2
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['best-practice', 'mobility', 'render-state', 'plugin']
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
在 `HorizonTweenActorEvent.h:26` 和 `HorizonTweenSceneComponentEvent.h:25` 附近，直接使用賦值語法設置組件的 Mobility：

```cpp
Component->Mobility = EComponentMobility::Movable;  // 不會觸發渲染/物理更新
```

正確的做法應該使用 `SetMobility()` 函數，它會正確觸發組件的狀態更新。

# Goal
將直接賦值改為使用 `SetMobility()` 函數调用。

# Non-Goals
- 不改變其他相關功能

# Approach
```cpp
Component->SetMobility(EComponentMobility::Movable);  // 正確做法
```

# Alternatives
- 無（這是正確的修復方式）

# Acceptance Criteria
- [ ] 組件 mobility 設置正確
- [ ] 渲染/物理狀態正確更新

# Risks / Dependencies
- 風險：低（UE API 正確用法）

# Worklog
2026-02-11 23:58 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
