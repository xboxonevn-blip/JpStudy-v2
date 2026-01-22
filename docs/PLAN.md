# Rive Integration Plan

> **Goal:** Replace static mascot with interactive Rive animation (Duolingo-style).

## 1. Phase Planning

| Phase | Agent | Description |
|-------|-------|-------------|
| **1. Planning** | `project-planner` | Define scope, assets, and state machine inputs. |
| **2. Implementation** | `mobile-developer` | Add `rive` dependency, implement `MascotRive` widget. |
| **3. Verification** | `test-engineer` | Verify build, analyze code, and visual check. |

## 2. Technical Implementation `mobile-developer`

### Dependencies
- Add `rive: ^0.13.0` to `pubspec.yaml`.

### Assets
- **Location:** `assets/mascot.riv`
- **Source:** User provided / Placeholder. (Note: Since I cannot generate `.riv` files, I will use a placeholder logic or expect the file to be present. I will assume `assets/mascot.riv` exists for the code to compile, or handle the error gracefully).

### State Machine (`MascotSM`)
- **Inputs:**
  - `success`: Trigger (Boolean/Trigger)
  - `fail`: Trigger (Boolean/Trigger)
  - `hover`: Boolean (Optional, for attention)

### Components
- **New Widget:** `lib/features/home/widgets/mascot_rive.dart`
  - Encapsulate Rive logic.
  - Expose `playSuccess()` and `playFail()` methods via `GlobalKey` or Controller.
- **Update:** `lib/features/home/widgets/unit_map_widget.dart`
  - Replace `_MascotWidget` (image-based) with `MascotRive`.
  - Connect interactions (e.g., tap) to Rive triggers.

## 3. Verification Strategy `test-engineer`

- **Static Analysis:** `flutter analyze` must be clean.
- **Runtime:** Application must not crash if `.riv` is missing (handle error).
- **Functionality:** `playSuccess` and `playFail` must act on the controller without error.

## 4. User Interaction
- User requested "smooth animation". Rive handles this internally.
- User requested specific triggers. We will expose them.

---
**Status:** Waiting for approval.
