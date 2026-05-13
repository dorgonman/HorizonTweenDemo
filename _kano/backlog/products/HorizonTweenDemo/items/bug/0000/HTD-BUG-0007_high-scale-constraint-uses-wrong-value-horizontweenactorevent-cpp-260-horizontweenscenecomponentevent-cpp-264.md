---
id: HTD-BUG-0007
uid: 019c4d6c-0a85-7038-9be0-d2050c0472fa
type: Bug
title: "[HIGH] Scale constraint uses wrong value (HorizonTweenActorEvent.cpp:260, HorizonTweenSceneComponentEvent.cpp:264)"
state: Proposed
priority: P1
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['logic-error', 'constraint', 'scale', 'plugin']
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
在 `SetScale` 函數中，Scale 約束錯誤地使用了 `GetActorLocation`（或 `GetSceneComponentLocation`）而非 `GetActorScale`（或 `GetSceneComponentScale`）：

**HorizonTweenActorEvent.cpp:260:**
```cpp
UHorizonTweenFunctionLibrary::ConstrainsVector(paramImpl.ScaleConstraintType,
    GetActorLocation<decltype(paramImpl)>(paramImpl), newScale);  // 錯誤：應該用 GetActorScale
```

**HorizonTweenSceneComponentEvent.cpp:264:**
```cpp
UHorizonTweenFunctionLibrary::ConstrainsVector(paramImpl.ScaleConstraintType,
    GetSceneComponentLocation<decltype(paramImpl)>(paramImpl), newScale);  // 錯誤：應該用 GetSceneComponentScale
```

這導致 Scale 約束功能完全錯誤。

# Goal
修復 Scale 約束使用錯誤值的問題。

# Non-Goals
- 不改變約束的基本邏輯
- 不修改其他類型的約束（如 Location、Rotation）

# Approach
將 `GetActorLocation` 改為 `GetActorScale`，`GetSceneComponentLocation` 改為 `GetSceneComponentScale`：

```cpp
// HorizonTweenActorEvent.cpp:260
UHorizonTweenFunctionLibrary::ConstrainsVector(paramImpl.ScaleConstraintType,
    GetActorScale<decltype(paramImpl)>(paramImpl), newScale);

// HorizonTweenSceneComponentEvent.cpp:264
UHorizonTweenFunctionLibrary::ConstrainsVector(paramImpl.ScaleConstraintType,
    GetSceneComponentScale<decltype(paramImpl)>(paramImpl), newScale);
```

# Alternatives
- 無（這是一個明確的 bug）

# Acceptance Criteria
- [ ] Scale 約束正確使用 Scale 值而非 Location 值
- [ ] XOnly/YOnly/ZOnly 約束對 Scale 正確運作
- [ ] XYPlane/YZPlane/XZPlane 約束對 Scale 正確運作

# Risks / Dependencies
- 風險：低（明確的 bug 修復）
- 依賴：無

# Worklog
2026-02-11 23:57 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
