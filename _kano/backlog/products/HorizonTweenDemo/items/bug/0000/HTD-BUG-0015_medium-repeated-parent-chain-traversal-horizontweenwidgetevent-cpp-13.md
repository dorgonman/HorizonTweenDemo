---
id: HTD-BUG-0015
uid: 019c4d6d-b7b3-7647-acef-263315c5d220
type: Bug
title: "[MEDIUM] Repeated parent chain traversal (HorizonTweenWidgetEvent.cpp:13)"
state: Proposed
priority: P2
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['performance', 'optimization', 'widget', 'plugin']
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
`GetParentCanvasPanelSlot` 函數（`HorizonTweenWidgetEvent.cpp:13`）在每次調用時都遍歷父widget鏈：

```cpp
UWidget* pTargetWidget = pWidget;
do {
    if (pTargetWidget) {
        pPanelSlot = Cast<UCanvasPanelSlot>(pTargetWidget->Slot);
    }
    if (pPanelSlot) break;
    else {
        if (pTargetWidget) {
            pTargetWidget = pTargetWidget->GetParent();
        }
        ...
    }
} while (...);
```

在 TweenUpdate 的 tick 路徑中重複調用會造成不必要的開銷。

# Goal
緩存 `UCanvasPanelSlot` 引用，避免重複遍歷。

# Non-Goals
- 不改變函數的邏輯
- 不移除遍歷功能（因為slot可能改變）

# Approach
在 TweenStart 或 construction 時查找並緩存 slot，以後直接使用緩存：

```cpp
UCanvasPanelSlot* CachedPanelSlot = nullptr;
// 在 TweenStart 中：
CachedPanelSlot = GetParentCanvasPanelSlot(pWidget);
// 在 TweenUpdate 中使用 CachedPanelSlot
```

注意：如果 widget 在動畫過程中可能改變父級，則不應緩存。

# Alternatives
1. 如果 slot 不會改變，在第一次調用後緩存結果
2. 保持現有實現，添加性能備註

# Acceptance Criteria
- [ ] 減少不必要的父鏈遍歷
- [ ] 如果 widget 父級會改變，仍正確處理

# Risks / Dependencies
- 風險：如果 widget 父級會改變但未正確更新緩存，可能出錯
- 依賴：無

# Worklog
2026-02-11 23:59 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
