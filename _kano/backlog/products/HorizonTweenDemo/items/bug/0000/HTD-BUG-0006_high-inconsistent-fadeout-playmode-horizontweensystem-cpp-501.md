---
id: HTD-BUG-0006
uid: 019c4d6b-d58a-726e-95f1-52ab3edfb3ad
type: Bug
title: "[HIGH] Inconsistent FadeOut PlayMode (HorizonTweenSystem.cpp:501)"
state: Proposed
priority: P1
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['logic-error', 'fadeout', 'inconsistency', 'plugin']
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
在 `HorizonTweenSystem.cpp:501` 附近，`FadeOut` 函數對於不同類型使用不同的 PlayMode：
- Actor/SceneComponent 的 FadeOut 使用 `PingPong` 模式
- Widget 的 FadeOut 使用 `Forward` 模式

這種不一致導致相同的 API 名称但有不同的行為，可能讓使用者困惑。

# Goal
統一 `FadeOut` 的 PlayMode 行為，確保所有類型的淡出效果一致。

# Non-Goals
- 不改變 `FadeIn` 的行為
- 不改變其他相關函數的行為

# Approach
統一所有 `FadeOut` 實作使用 `Forward` 模式：

```cpp
// HorizonTweenSystem.cpp 中的 FadeOut
TweenEventParam.PlayMode = EHorizonTweenPlayMode::Forward;
```

需要檢查並修改的位置：
- Actor FadeOut
- SceneComponent FadeOut  
- Widget FadeOut

# Alternatives
1. 統一使用 `PingPong`（但 `Forward` 更直觀）
2. 添加參數讓使用者選擇 PlayMode

# Acceptance Criteria
- [ ] Actor/SceneComponent/Widget 的 FadeOut 使用相同的 PlayMode
- [ ] 現有依賴當前行為的代碼不受影響（或已更新）

# Risks / Dependencies
- 風險：可能破壞依賴當前不一致行為的現有使用
- 依賴：需要檢查所有使用 FadeOut 的地方

# Worklog
2026-02-11 23:57 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
