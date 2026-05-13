---
id: HTD-BUG-0018
uid: 019c4e-615b-723b-84df-ece0dacb590f
type: Bug
title: "[LOW] Map key collision silently overwrites (HorizonTweenSystem.cpp:2016)"
state: Proposed
priority: P3
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['code-quality', 'map-collision', 'silent-error', 'plugin']
created: 2026-02-12
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
`HorizonTweenSystem.cpp:2016` 附近，`TMap::Add` 在鍵衝突時會靜默覆蓋舊值：

```cpp
TweenEventMap.Add(EventName, NewEvent);
```

在 Development/Shipping build 中，如果名稱衝突，舊事件會被靜默替換，可能導致：
- 事件丟失
- 內存洩漏（舊事件可能未被正確清理）
- 難以調試的行為

只有 `ensure` 檢查會在 Debug build 中提示。

# Goal
在鍵衝突時提供明確的錯誤處理，而非靜默覆蓋。

# Non-Goals
- 不改變 Map 的基本行為

# Approach
使用 `TMap::Add` 的重載，明確處理衝突：

```cpp
if (TweenEventMap.Contains(EventName))
{
    // 衝突：先移除舊事件或明確報錯
    UE_LOG(LogHorizonTween, Warning, TEXT("Duplicate event name: %s"), *EventName.ToString());
    // 選擇：覆蓋/返回/拒絕
}
TweenEventMap.Add(EventName, NewEvent);
```

# Alternatives
1. 使用 `TMap::FindOrAdd` 但先驗證
2. 在 Debug build 中添加 `ensure` 提示（如果尚未存在）

# Acceptance Criteria
- [ ] 鍵衝突時有明確的日誌/警告
- [ ] 舊事件被正確清理

# Risks / Dependencies
- 風險：低（只影響錯誤處理）
- 依賴：無

# Worklog
2026-02-12 00:00 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
