---
id: HTD-BUG-0004
uid: 019c4d6b-6b17-76b3-9418-5d7332fd945e
type: Bug
title: "[CRITICAL] Unchecked weak pointer usage in GetCurrentLerp (HorizonTweenSceneComponentEvent.cpp:77)"
state: Done
priority: P0
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['null-pointer', 'weak-pointer', 'crash', 'BlueprintPure', 'plugin']
created: 2026-02-11
updated: 2026-03-25
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: [HTD-BUG-0002]
  blocks: []
  blocked_by: []
  duplicates: []
decisions: []
---

# Context
在 `HorizonTweenSceneComponentEvent.cpp:77` 的 `GetCurrentLerp()` 函數中，直接使用弱指標解引用：

```cpp
UHorizonTweenFunctionLibrary::ConstrainsRotator(paramImpl.ConstraintType,
    paramImpl.TweenTargetWeakPtr->GetComponentTransform().Rotator(), result);
```

此函數可能是 `BlueprintPure`（從位於 header 的宣告推斷），在 Blueprint 中純函數不應有副作用或崩潰風險。當 target 已被銷毀時，此處會崩潰。

# Goal
修復 `GetCurrentLerp` 中的弱指標解引用問題，確保安全访问。

# Non-Goals
- 不改變函數的 Blueprint 公開屬性
- 不大幅重構約束邏輯

# Approach
在使用弱指標前檢查有效性：

```cpp
if (paramImpl.TweenTargetWeakPtr.IsValid())
{
    UHorizonTweenFunctionLibrary::ConstrainsRotator(paramImpl.ConstraintType,
        paramImpl.TweenTargetWeakPtr->GetComponentTransform().Rotator(), result);
}
```

同時檢查是否有其他類似問題：
- `HorizonTweenActorEvent.cpp` 中的 `GetCurrentLerp()` 函數
- `HorizonTweenWidgetEvent.cpp` 中的 `GetCurrentLerp()` 函數

# Alternatives
1. 將 `GetCurrentLerp` 從 `BlueprintPure` 改為有副作用的函數
2. 對所有 `GetCurrentLerp` 實作添加安全檢查

# Acceptance Criteria
- [ ] 當 target 已銷毀時呼叫 `GetCurrentLerp` 不會崩潰
- [ ] 約束邏輯在 target 有效時正常運作
- [ ] Actor、SceneComponent、Widget 版本的 GetCurrentLerp 都已檢查

# Risks / Dependencies
- 風險：約束可能在 target 無效時不應用（取決於預期行為）
- 依賴：需要檢查所有子類別的 GetCurrentLerp

# Worklog
2026-02-11 23:56 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
2026-03-25 [agent=Sisyphus] Fixed: Added if(paramImpl.TweenTargetWeakPtr.IsValid()) check before dereference
