---
id: HTD-BUG-0011
uid: 019c4d6c-eb04-76ae-9f7b-eac3276691fb
type: Bug
title: "[MEDIUM] const_cast abuse in font mutation (HorizonTweenWidgetEvent.cpp:320)"
state: Proposed
priority: P2
parent: null
area: HorizonTweenPlugin
iteration: backlog
tags: ['code-quality', 'const-cast', 'unsafe', 'plugin']
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
在 `HorizonTweenWidgetEvent.cpp:320` 附近：

```cpp
FSlateFontInfo* pFont = const_cast<FSlateFontInfo*>(&pTextBlock->GetFont());
pFont->OutlineSettings.OutlineColor.A = currentLerp.A;
```

使用 `const_cast` 修改 `GetFont()` 返回的 const 引用，這是不安全的。`GetFont()` 返回的是 const 引用可能有原因（防止意外修改）。

# Goal
消除 `const_cast` 使用，採用安全的字體修改方式。

# Non-Goals
- 不改變 OutlineColor 修改的功能

# Approach
正確的做法是複製字體後使用 `SetFont()`：

```cpp
FSlateFontInfo Font = pTextBlock->GetFont();
Font.OutlineSettings.OutlineColor.A = currentLerp.A;
pTextBlock->SetFont(Font);
```

# Alternatives
1. 創建一個修改過的 `FSlateFontInfo` 副本並 SetFont
2. 如果 API 不支援，可以保留 const_cast 但需要添加詳細註釋說明原因

# Acceptance Criteria
- [ ] 不再使用 `const_cast`
- [ ] OutlineColor 修改功能仍然正常

# Risks / Dependencies
- 風險：低（只是複製並設置）
- 依賴：檢查 `SetFont()` API 是否存在

# Worklog
2026-02-11 23:58 [agent=Sisyphus] Created item
2026-03-25 [agent=Sisyphus] Filled in Context, Goal, Approach, Acceptance Criteria
