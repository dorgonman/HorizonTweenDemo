---
id: HTD-BUG-0003
uid: 019c4d6b-2ef7-71c9-88ac-36b434cd203c
type: Bug
title: "[CRITICAL] Division by zero in tween alpha calculation (HorizonTweenEvent.cpp:161,166,171)"
state: Done
priority: P0
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['crash', 'division-by-zero', 'nan', 'tween-calculation', 'plugin']
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
在 `HorizonTweenEvent.cpp:158-181` 的 `Processing()` 函數中，計算 `CurrentAlpha` 時直接除以 `TweenEventParam.Duration`，但沒有檢查 `Duration` 是否為零或極小值。

```cpp
case EHorizonTweenPlayMode::Forward:
{
    CurrentAlpha = CurrentDuration / TweenEventParam.Duration;  // line 161
}
break;
case EHorizonTweenPlayMode::Reverse:
{
    CurrentAlpha = 1 - (CurrentDuration / TweenEventParam.Duration);  // line 166
}
break;
case EHorizonTweenPlayMode::PingPong:
{
    float halfAlpha = CurrentDuration / TweenEventParam.Duration;  // line 171
    ...
}
```

當 `Duration <= 0` 時，會產生 `inf` 或 `NaN`，導致 tween 狀態不穩定。

# Goal
修復除以零的問題，確保 Duration 為零或極小值時有合理的預設行為。

# Non-Goals
- 不改變 API 介面
- 不添加新的錯誤回報機制（現有 ensure 足夠）

# Approach
在計算前檢查 Duration 是否為有效值：

```cpp
if (TweenEventParam.Duration > KINDA_SMALL_NUMBER)
{
    CurrentAlpha = CurrentDuration / TweenEventParam.Duration;
}
else
{
    // Duration 為零時，直接設為結束狀態
    CurrentAlpha = (TweenEventParam.PlayMode == EHorizonTweenPlayMode::Forward) ? 1.0f : 0.0f;
}
```

# Alternatives
1. 在建立 TweenEvent 時 Validation，拒絕 Duration <= 0 的請求
2. 使用 `FMath::IsNearlyZero()` 替代 `KINDA_SMALL_NUMBER` 比較

# Acceptance Criteria
- [ ] Duration = 0 時不會產生 inf/NaN
- [ ] Duration 極小（如 0.001）時行為正確
- [ ] 現有功能不受影響（正常 Duration > 0 時）
- [ ] PingPong 模式同樣處理

# Risks / Dependencies
- 風險：可能需要更新依賴 Duration 計算的其他函數
- 依賴：無

# Worklog
2026-02-11 23:56 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
2026-03-25 [agent=Sisyphus] Fixed: Added if(TweenEventParam.Duration > KINDA_SMALL_NUMBER) check with fallback behavior
