---
id: HTD-BUG-0005
uid: 019c4d6b-9faf-74c9-8b7a-75593e5f1d13
type: Bug
title: "[CRITICAL] GetNumTweenEvent can return negative value (HorizonTweenSystem.cpp:2068)"
state: Done
priority: P0
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['incorrect-count', 'negative-value', 'api-correctness', 'plugin']
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
`GetNumTweenEvent()` 計算回傳值為：
```
TweenEventMap.Num() + PendingAddTweenEvenList.Num() - PendingKillTweenEvenList.Num()
```

問題在於 `PendingKillTweenEvenList` 沒有去重，如果同一個事件被多次加入 pending kill 列表，減去的次數會多於實際應有的，導致回傳負值。

根據原始程式碼註解（`// should be TweenEventMap.Num() + PendingAddTweenEvenList.Num() - PendingKillTweenEvenList.Num()`），這是已知問題。

# Goal
修復 `GetNumTweenEvent` 回傳負值的問題，確保計數正確。

# Non-Goals
- 不改變事件管理的基本邏輯
- 不移除 pending kill 機制

# Approach
方案 A（簡單）：使用 `FMath::Max(0, ...)` 確保不會回傳負值
```cpp
return FMath::Max(0, TweenEventMap.Num() + PendingAddTweenEvenList.Num() - PendingKillTweenEvenList.Num());
```

方案 B（根本修復）：在 `MarkAsPendingKill` 中確保不重複添加
```cpp
if (!PendingKillTweenEvenList.Contains(InEvent))
{
    PendingKillTweenEvenList.Add(InEvent);
}
```

建議採用方案 B 根本修復，方案 A 作為保險。

# Alternatives
- 見上方 Approach

# Acceptance Criteria
- [ ] `GetNumTweenEvent()` 不會回傳負值
- [ ] 事件計數在各種場景下都是正確的
- [ ] 反覆新增/移除同一事件不會造成計數錯誤

# Risks / Dependencies
- 風險：修改 pending kill 列表管理可能影響其他地方
- 依賴：需要全面測試所有事件新增/移除場景

# Worklog
2026-02-11 23:57 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
2026-03-25 [agent=Sisyphus] Fixed: Added Contains check in MarkAsPendingKill + FMath::Max(0,...) safety net in GetNumTweenEvent
