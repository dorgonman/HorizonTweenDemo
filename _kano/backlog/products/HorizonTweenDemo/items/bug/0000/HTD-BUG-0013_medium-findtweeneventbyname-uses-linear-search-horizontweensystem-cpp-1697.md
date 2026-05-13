---
id: HTD-BUG-0013
uid: 019c4d6d-4abb-7189-a00f-c5e533614c06
type: Bug
title: "[MEDIUM] FindTweenEventByName uses linear search (HorizonTweenSystem.cpp:1697)"
state: Proposed
priority: P2
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['performance', 'optimization', 'search', 'plugin']
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
`FindTweenEventByName` 函數遍歷所有 `TMap` 值來查找事件：

```cpp
for (auto& It : TweenEventMap)
{
    if (It.Value->EventName == InEventName)
    {
        return It.Value;
    }
}
```

由於 `TMap` 已經是按鍵值存儲的，如果 `EventName` 也是鍵的一部分，應該可以直接查找。

# Goal
優化查找性能，使用 O(1) 查找而非 O(n) 遍歷。

# Non-Goals
- 不改變查找的邏輯（仍按名稱查找）

# Approach
檢查 `TweenEventMap` 的鍵結構。如果 `EventName` 存在於鍵中，直接使用 `TMap::Find()`：

```cpp
if (auto* FoundEvent = TweenEventMap.Find(EventName))
{
    return *FoundEvent;
}
```

如果需要保留按值查找的功能，可以添加另一個 map 來建立名稱到事件的索引。

# Alternatives
1. 使用 `TMap<FName, UHorizonTweenEvent*>` 替代
2. 保持現有實現，添加性能備註

# Acceptance Criteria
- [ ] `FindTweenEventByName` 性能顯著提升
- [ ] 查找結果與原實現一致

# Risks / Dependencies
- 風險：低（純優化）
- 依賴：需要確認 TweenEventMap 的鍵結構

# Worklog
2026-02-11 23:58 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
