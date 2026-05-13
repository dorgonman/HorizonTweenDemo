# HorizonTweenDemo 程式碼分析總結報告

**分析日期**: 2026-02-11  
**分析範圍**: HorizonTweenDemo 專案 + HorizonTweenPlugin  
**發現問題總數**: 18 個

---

## 📊 問題統計

| 優先級 | 數量 | 票據編號 |
|--------|------|----------|
| **P0 (Critical)** | 4 | HTD-BUG-0002 ~ 0005 |
| **P1 (High)** | 4 | HTD-BUG-0006 ~ 0009 |
| **P2 (Medium)** | 7 | HTD-BUG-0010 ~ 0016 |
| **P3 (Low)** | 3 | HTD-BUG-0017 ~ 0019 |

---

## 🔴 Critical 優先級 (P0) - 需立即修復

### HTD-BUG-0002: Null pointer dereference in TweenFinished
- **檔案**: `HorizonTweenEvent.cpp:231-232`
- **問題**: `ensureMsgf` 後無條件解引用 `TweenSystemWeakPtr`
- **影響**: Shipping build 中 TweenSystem 無效時會崩潰
- **修復建議**:
```cpp
if (ensureMsgf(TweenSystemWeakPtr.IsValid(), TEXT("TweenSystem is invalid")))
{
    TweenSystemWeakPtr->MarkAsPendingKill(this);
}
```

### HTD-BUG-0003: Division by zero in tween alpha calculation
- **檔案**: `HorizonTweenEvent.cpp:161, 166, 171`
- **問題**: 除以 `TweenEventParam.Duration` 沒有零值保護
- **影響**: 產生 inf/NaN 導致 tween 狀態不穩定
- **修復建議**:
```cpp
if (TweenEventParam.Duration > KINDA_SMALL_NUMBER)
{
    CurrentAlpha = CurrentDuration / TweenEventParam.Duration;
}
else
{
    CurrentAlpha = 1.0f;
}
```

### HTD-BUG-0004: Unchecked weak pointer usage in GetCurrentLerp
- **檔案**: `HorizonTweenSceneComponentEvent.cpp:77`
- **問題**: `TweenTargetWeakPtr->GetComponentTransform()` 沒有有效性檢查
- **影響**: 從 BlueprintPure 路徑調用時，target 過期會崩潰
- **修復建議**: 在所有弱指針使用前添加 `IsValid()` 檢查

### HTD-BUG-0005: GetNumTweenEvent can return negative value
- **檔案**: `HorizonTweenSystem.cpp:2068`
- **問題**: pending-kill 列表沒有去重
- **影響**: 事件計數不正確
- **修復建議**: 在 `MarkAsPendingKill` 中去重，或使用 `FMath::Max(0, ...)`

---

## 🟠 High 優先級 (P1)

### HTD-BUG-0006: Inconsistent FadeOut PlayMode
- **檔案**: `HorizonTweenSystem.cpp:501`
- **問題**: Actor/SceneComponent 的 FadeOut 使用 PingPong，Widget 使用 Forward
- **影響**: 意外的淡入淡出行為
- **修復**: 統一使用 `Forward` 模式

### HTD-BUG-0007: Scale constraint uses wrong value
- **檔案**: `HorizonTweenActorEvent.cpp:260`, `HorizonTweenSceneComponentEvent.cpp:264`
- **問題**: Scale 約束使用 `currentLocation` 而非 `currentScale`
- **影響**: 約束行為不正確

### HTD-BUG-0008: TweenEventMap lacks thread synchronization
- **檔案**: `HorizonTweenSystem.cpp:43`
- **問題**: 迭代 map 時 mutator 可以無鎖修改
- **影響**: 非遊戲線程調用時出現競態條件
- **修復**: 添加 `check(IsInGameThread())` 或使用鎖

### HTD-BUG-0009: Actor spawning without thread check in Subsystem
- **檔案**: `HorizonTweenSubsystem.cpp:20, 46`
- **問題**: 沒有 `IsInGameThread()` 斷言
- **影響**: 非遊戲線程生成 UObject/Actor 不安全

---

## 🟡 Medium 優先級 (P2)

### HTD-BUG-0010: Direct Mobility assignment
- **檔案**: `HorizonTweenActorEvent.h:26`, `HorizonTweenSceneComponentEvent.h:25`
- **問題**: 直接賦值不會觸發渲染/物理更新
- **修復**: 使用 `SetMobility(EComponentMobility::Movable)`

### HTD-BUG-0011: const_cast abuse in font mutation
- **檔案**: `HorizonTweenWidgetEvent.cpp:320`
- **問題**: 對 `GetFont()` 使用 `const_cast` 修改 `OutlineColor`
- **修復**: 複製字體後使用 `SetFont(...)`

### HTD-BUG-0012: BlueprintPure returns non-const reference
- **檔案**: `HorizonTweenEvent.h:101`
- **問題**: Pure 函數允許副作用修改
- **修復**: 返回 `const FHorizonTweenEventParameters&`

### HTD-BUG-0013: FindTweenEventByName uses linear search
- **檔案**: `HorizonTweenSystem.cpp:1697`
- **問題**: 遍歷所有 map 值
- **影響**: 高頻調用時性能差
- **修復**: 使用 `TweenEventMap.Find(EventName)` 直接查找

### HTD-BUG-0014: Excessive Cast checks in ByObject functions
- **檔案**: `HorizonTweenSystem.cpp:1786`
- **問題**: 每個事件每次調用 15+ 次類型檢查
- **影響**: 擴展性差

### HTD-BUG-0015: Repeated parent chain traversal
- **檔案**: `HorizonTweenWidgetEvent.cpp:13`
- **問題**: `GetParentCanvasPanelSlot` 在 tick 路徑中重複調用
- **影響**: 不必要的開銷
- **修復**: 緩存 slot 引用

### HTD-BUG-0016: TweenSystemMap never cleans invalid weak pointers
- **檔案**: `HorizonTweenSubsystem.cpp:52`
- **問題**: 無效弱指針永久累積
- **影響**: 長時間運行會話中不必要的 map 增長

---

## 🟢 Low 優先級 (P3)

### HTD-BUG-0017: Parameter name typo
- **檔案**: `HorizonTweenSystem.h:466`
- **問題**: `InTaInTweenTargetrget` 拼寫錯誤
- **影響**: 可讀性

### HTD-BUG-0018: Map key collision silently overwrites
- **檔案**: `HorizonTweenSystem.cpp:2016`
- **問題**: `TMap::Add` 在衝突時覆蓋，只有 `ensure` 檢查
- **影響**: Shipping 中靜默事件替換

### HTD-BUG-0019: Deprecated Engine.h include in demo project
- **檔案**: `HorizonTweenDemo.h:5`
- **問題**: 包含整個引擎而非特定頭文件
- **影響**: 增加編譯時間
- **修復**: 使用 `CoreMinimal.h` 和具體需要的頭文件

---

## 📋 修復優先級建議

### 第一階段 (立即修復 - Critical)
1. HTD-BUG-0002: Null pointer dereference
2. HTD-BUG-0003: Division by zero
3. HTD-BUG-0004: Unchecked weak pointer
4. HTD-BUG-0005: Negative event count

### 第二階段 (高優先級 - High)
5. HTD-BUG-0008: Thread synchronization
6. HTD-BUG-0009: Thread check in Subsystem
7. HTD-BUG-0006: Inconsistent FadeOut
8. HTD-BUG-0007: Scale constraint bug

### 第三階段 (中優先級 - Medium)
9. HTD-BUG-0010 ~ 0016: UE 最佳實踐和性能優化

### 第四階段 (低優先級 - Low)
10. HTD-BUG-0017 ~ 0019: 代碼質量改進

---

## 🔧 測試建議

修復後應執行以下測試：

1. **單元測試**:
   - 測試 Duration = 0 的情況
   - 測試 TweenSystem 無效時的行為
   - 測試弱指針過期的情況

2. **集成測試**:
   - 測試 FadeIn/FadeOut 行為一致性
   - 測試 Scale 約束功能
   - 測試高頻事件創建/銷毀

3. **壓力測試**:
   - 長時間運行測試（檢查內存洩漏）
   - 大量事件並發測試
   - 線程安全測試

4. **Shipping Build 測試**:
   - 確保所有 ensure 檢查後都有適當的錯誤處理

---

## 📝 備註

- 所有問題已記錄在 Kano backlog 系統中
- 票據位置: `_kano/backlog/products/HorizonTweenDemo/items/bug/0000/`
- 所有 18 個 Bug 項目 (HTD-BUG-0002 ~ 0019) 已填入完整的 Context, Goal, Approach, Acceptance Criteria
- 建議在修復前創建對應的單元測試
- 修復後更新 AGENTS.md 中的已知問題部分

## 📅 更新記錄

- 2026-03-25: [agent=Sisyphus] 填入所有 18 個 Bug 項目的完整內容
- 2026-02-11: [agent=Sisyphus] 初始代碼分析，創建 18 個 Bug 票據
