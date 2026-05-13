---
id: HTD-BUG-0019
uid: 019c4e-9ea9-77a7-9b31-8208c89a6486
type: Bug
title: "[LOW] Deprecated Engine.h include in demo project (HorizonTweenDemo.h:5)"
state: Proposed
priority: P3
parent: null
area: HorizonTweenDemo
iteration: backlog
tags: ['code-quality', 'includes', 'compile-time', 'demo']
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
`HorizonTweenDemo.h:5` 包含了完整的 `Engine.h` 標頭文件：

```cpp
#include "Engine.h"
```

這是不推薦的做法，因為：
- 增加編譯時間（Engine.h 包含大量內容）
- 現代 UE 最佳實踐是使用 `CoreMinimal.h` 或更具體的頭文件
- 可能隱藏include依賴問題

# Goal
用更具體的頭文件替換 `Engine.h`。

# Non-Goals
- 不改變編譯結果
- 不影響任何功能

# Approach
將 `Engine.h` 替換為所需的具體頭文件：

```cpp
// 根據實際使用的類型，添加：
#include "CoreMinimal.h"
// 或
#include "GameFramework/Actor.h"
// 或其他具體的頭文件
```

需要分析 `HorizonTweenDemo.h` 的實際依賴來確定需要哪些頭文件。

# Alternatives
1. 如果確實需要 Engine 中的多個類型，可以使用 `Engine/Engine.h` 或 `EngineTypes.h`
2. 使用 `EngineSubsystem.h` 如果是 subsystem

# Acceptance Criteria
- [ ] 編譯成功
- [ ] 編譯時間可能改善
- [ ] 代碼符合 modern UE 最佳實踐

# Risks / Dependencies
- 風險：低（只是頭文件調整）
- 依賴：需要分析實際依賴

# Worklog
2026-02-12 00:00 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
