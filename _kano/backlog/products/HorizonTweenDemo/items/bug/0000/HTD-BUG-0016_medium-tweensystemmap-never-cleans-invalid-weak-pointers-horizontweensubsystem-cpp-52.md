---
id: HTD-BUG-0016
uid: 019c4d6d-eae6-721a-8371-4b2fd427e12b
type: Bug
title: "[MEDIUM] TweenSystemMap never cleans invalid weak pointers (HorizonTweenSubsystem.cpp:52)"
state: Proposed
priority: P2
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['performance', 'memory', 'cleanup', 'plugin']
created: 2026-02-11
updated: 2026-03-25
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: [HTD-BUG-0005]
  blocks: []
  blocked_by: []
  duplicates: []
decisions: []
---

# Context
`HorizonTweenSubsystem.cpp:52` 附近的 `TweenSystemMap` 使用 `TWeakObjectPtr` 存儲 TweenSystem 引用，但從不清理無效的弱指標。

隨著時間推移，`TweenSystemMap` 會累積越來越多的無效弱指標，導致：
- 記憶體輕微洩漏（弱指標陣列）
- `TweenSystemMap.Num()` 返回虛假的數量
- 查找效率下降

# Goal
定期清理 `TweenSystemMap` 中的無效弱指標。

# Non-Goals
- 不改變 Map 的基本功能
- 不影響正常運行的 TweenSystem

# Approach
在 `GetOrCreateTweenSystemWithName` 或定時器中清理無效引用：

```cpp
// 清理無效引用
for (auto It = TweenSystemMap.CreateIterator(); It; ++It)
{
    if (!It.Value().IsValid())
    {
        It.RemoveCurrent();
    }
}
```

# Alternatives
1. 使用 `TMap<FName, TObjectPtr<AHorizonTweenSystem>>` 替代（但失去弱引用的好處）
2. 每次訪問前檢查並清理

# Acceptance Criteria
- [ ] `TweenSystemMap` 中的無效引用被及時清理
- [ ] `GetNumTweenEvent` 和類似函數返回準確計數

# Risks / Dependencies
- 風險：低（只影響無效引用）
- 依賴：無

# Worklog
2026-02-11 23:59 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
