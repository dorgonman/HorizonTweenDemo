# AGENTS.md - HorizonTweenDemo

This is an Unreal Engine 5.7 demo project for the HorizonTweenPlugin. This document guides agentic coding operations.

## Project Overview

- **Engine**: Unreal Engine 5.7
- **Project File**: `HorizonTweenDemo.uproject`
- **Main Module**: `Source/HorizonTweenDemo` (Runtime)
- **Plugin**: `Plugins/HorizonTweenPlugin` (git submodule)
- **CI Helpers**: `ue_ci_scripts/`, `horizon_ci_scripts/` (git submodules)

## Build / Lint / Test Commands

### Setup (One-time)

```bash
# Sync submodules
./git_submodule_update.sh

# If switching branches/tags
./git_checkout_submodules.sh
```

### Build (Editor)

**Recommended**: Open `HorizonTweenDemo.uproject` in Unreal Editor (5.7+). Editor will auto-generate and build.

**Command-line** (requires `UE_ROOT` env var set to engine root):
```bash
"%UE_ROOT%\Engine\Build\BatchFiles\Build.bat" HorizonTweenDemoEditor Win64 Development "%CD%\HorizonTweenDemo.uproject" -WaitMutex -FromMsBuild
```

### Build (Game)

```bash
"%UE_ROOT%\Engine\Build\BatchFiles\Build.bat" HorizonTweenDemo Win64 Development "%CD%\HorizonTweenDemo.uproject" -WaitMutex -FromMsBuild
```

### Run Tests (Single Test)

**Via CI script** (Git-Bash, set `UNREAL_ENGINE_ROOT` and `TEST_NODE_NAME`):
```bash
export UNREAL_ENGINE_ROOT="/d/UE/UE_5.7"
export TEST_NODE_NAME="HorizonTweenDemoTest"
bash ue_ci_scripts/job/sh/win64/test_editor_development_job.sh
```

**Via Automation command** (replace `MyTestNameOrFilter`):
```bash
"%UE_ROOT%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe" "%CD%\HorizonTweenDemo.uproject" -unattended -nop4 -nosplash -NullRHI -NoSound -log -ExecCmds="Automation RunTests MyTestNameOrFilter; Quit"
```

### Lint / Static Analysis

```bash
# cppcheck (requires cppcheck tooling)
bash ue_ci_scripts/job/sh/common/cppcheck.sh
```

## Code Style Guidelines

### Formatting

Follow `.editorconfig`:
- **Indent**: 4 spaces (C++, most files)
- **Max line length**: 120 characters
- **Trailing whitespace**: Do not trim (disabled)
- **Charset**: UTF-8

### Unreal C++ Conventions

Maintain consistency with Unreal Engine standards and existing code in `Source/HorizonTweenDemo/`:

**Type Prefixes**:
- `A*` for Actors (e.g., `AHorizonTweenDemoGameMode`)
- `U*` for UObject-derived types (e.g., `UActorComponent`)
- `F*` for structs (e.g., `FVector`)
- `E*` for enums (e.g., `EHorizonTweenPlayMode`)
- Prefer `TObjectPtr<>` and `TWeakObjectPtr<>` for modern engine versions

**Naming**:
- Classes: `PascalCase` (e.g., `AHorizonTweenDemoGameMode`)
- Functions: `PascalCase` (Unreal style, e.g., `GetTweenSystem()`)
- Member variables: Unreal style (`b` prefix for bools; avoid Hungarian notation elsewhere)
- Local variables: `camelCase`

**Includes**:
- Include your own module header first (e.g., `#include "HorizonTweenDemo.h"`)
- Keep includes minimal; forward declare when feasible
- Use `#pragma once` in all headers

**Reflection Macros**:
- Use `UCLASS()`, `USTRUCT()`, `UFUNCTION()`, `UPROPERTY()` appropriately
- Respect Unreal's reflection system for Blueprint exposure

**Error Handling & Logging**:
- Prefer Unreal logging over exceptions: `UE_LOG(LogTemp, Warning, TEXT("..."))`
- Use `ensure()` / `check()` for invariants (do not silently ignore failures)
- Avoid empty catch blocks

### Build.cs / Target.cs

- Keep module dependencies explicit in `PublicDependencyModuleNames` and `PrivateDependencyModuleNames`
- Do not add broad dependencies "just to make it compile"
- Example: `Source/HorizonTweenDemo/HorizonTweenDemo.Build.cs`

### Assets & Content

- Many Unreal assets are binary; keep diffs minimal and intentional
- Do not commit generated folders: `Binaries/`, `DerivedDataCache/`, `Intermediate/`, `Saved/`
- These are already in `.gitignore`

## Git Hygiene (Critical for Agents)

- **Submodules**: Do not edit submodule contents unless the task explicitly targets them
- **Submodule updates**: Use `./git_submodule_update.sh`
- **Commits**: Do not commit/push unless explicitly requested by the user
- **Branch strategy**: Main branch may be unstable; prefer tagged releases (e.g., `editor/5.7.0`)

## Key Files & Directories

- **Project config**: `HorizonTweenDemo.uproject` (enabled plugins: HorizonTweenPlugin, EditorTests, RuntimeTests, FunctionalTestingEditor)
- **Game module entry**: `Source/HorizonTweenDemo/HorizonTweenDemo.cpp`
- **Build config**: `Source/HorizonTweenDemo/HorizonTweenDemo.Build.cs`
- **CI build logic**: `ue_ci_scripts/function/sh/public/ue_build_function.sh`
- **CI test logic**: `ue_ci_scripts/function/sh/public/ue_test_function.sh`
- **Azure pipeline**: `.azure-pipelines/azure-pipelines.yml`

## Testing

The project enables three test plugins:
- `EditorTests` - Editor-only tests
- `RuntimeTests` - Runtime tests
- `FunctionalTestingEditor` - Functional testing framework

Run via CI scripts or Automation commands (see Build / Lint / Test section).

## Important Notes

- No Cursor rules (`.cursor/rules/` / `.cursorrules`) found
- No Copilot rules (`.github/copilot-instructions.md`) found
- Kano backlog config: `.kano/backlog_config.toml`
