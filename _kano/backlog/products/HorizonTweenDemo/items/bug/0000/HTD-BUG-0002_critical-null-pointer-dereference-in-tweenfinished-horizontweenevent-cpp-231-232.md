---
id: HTD-BUG-0002
uid: 019c4d6a-f62a-71eb-b900-7366fdeb1821
type: Bug
title: "[CRITICAL] Null pointer dereference in TweenFinished (HorizonTweenEvent.cpp:231-232)"
state: Done
priority: P0
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['crash', 'null-pointer', 'shipping-build', 'plugin']
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
在 `HorizonTweenEvent.cpp:231-232` 的 `TweenFinished()` 函數中，程式碼使用 `ensureMsgf()` 來檢查 `TweenSystemWeakPtr` 是否有效，但無論檢查結果如何，都會繼續解引用。

```cpp
ensureMsgf(TweenSystemWeakPtr.IsValid(), TEXT("oops! something error."));
TweenSystemWeakPtr->MarkAsPendingKill(this);
```

`ensureMsgf` 在 Debug/Development build 中會中斷執行，但在 Shipping build 中是一個 no-op，導致在 TweenSystem 已銷毀的情況下仍然嘗試訪問，造成崩潰。

# Goal
修復 `TweenFinished()` 中的空指標解引用，確保在 Shipping build 中不會崩潰。

# Non-Goals
- 不修改其他函數中的類似模式（暫定）
- 不改變 TweenSystem 的生命週期管理邏輯

# Approach
將 `ensureMsgf` 改為 `if` 檢查，正確處理無效指標的情況：

```cpp
if (TweenSystemWeakPtr.IsValid())
{
    TweenSystemWeakPtr->MarkAsPendingKill(this);
}
```

# Alternatives
1. 在呼叫 `TweenFinished()` 前確保 TweenSystem 有效性（呼叫者負責）
2. 使用 `SafeNotifyTweenFinished()` 包裝函數，內部做空指標檢查

# Acceptance Criteria
- [ ] Shipping build 中，当 TweenSystem 已銷毀時呼叫 Tween 不會崩潰
- [ ] Debug/Development build 中同樣行為正確
- [ ] 現有功能不受影響（正常情況下 TweenSystem 應保持有效）
- [ ] 有對應的單元測試覆蓋此場景

# Risks / Dependencies
- 風險：此修復可能隱藏其他設計問題（為何 TweenSystem 會無效？）
- 依賴：需要單元測試框架

# Worklog
2026-02-11 23:56 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
2026-03-25 [agent=Sisyphus] Fixed: Wrapped dereference in if(TweenSystemWeakPtr.IsValid()) check
