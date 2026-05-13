---
id: HTD-BUG-0009
uid: 019c4d6c-6f20-7581-a10d-fbfe184bcf67
type: Bug
title: "[HIGH] Actor spawning without thread check in Subsystem (HorizonTweenSubsystem.cpp:20,46)"
state: Proposed
priority: P1
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['thread-safety', 'unsafe-spawn', 'plugin']
created: 2026-02-11
updated: 2026-03-25
owner: None
external:
  azure_id: null
  jira_key: null
links:
  relates: [HTD-BUG-0008]
  blocks: []
  blocked_by: []
  duplicates: []
decisions: []
---

# Context
`HorizonTweenSubsystem.cpp:20` 和 `:46` 附近，`SpawnActor` 被呼叫但沒有 `IsInGameThread()` 檢查。

在 Unreal Engine 中，`SpawnActor` 只能在游戲線程呼叫。從其他線程呼叫會導致未定義行為或崩潰。

# Goal
添加 `IsInGameThread()` 檢查，確保 Actor 生成在正確的線程執行。

# Non-Goals
- 不改變 Subsystem 的基本功能
- 不添加全面的線程安全機制

# Approach
在 `SpawnActor` 呼叫前添加檢查：

```cpp
if (!ensureMsgf(IsInGameThread(), TEXT("SpawnActor must be called on game thread")))
{
    return nullptr;
}
```

並在非遊戲線程呼叫時返回 nullptr 或使用 `Async` 任務排程到遊戲線程。

# Alternatives
1. 使用 `AsyncTask(ENamedThreads::GameThread)` 包裝 SpawnActor
2. 文檔說明只能在遊戲線程呼叫

# Acceptance Criteria
- [ ] 非遊戲線程呼叫時不會崩潰
- [ ] 有明確的錯誤提示
- [ ] 遊戲線程呼叫時行為不變

# Risks / Dependencies
- 風險：異步化可能改變回調時機
- 依賴：無

# Worklog
2026-02-11 23:57 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
