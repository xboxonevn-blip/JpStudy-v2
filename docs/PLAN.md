# Plan: Enhance Grammar UI Visibility

## Problem
The user reported missing "Ghost Reviews (SRS Logic)" and "Grammar Exercises".
Analysis reveals:
1. **Ghost Reviews**: The UI (`GrammarScreen.dart`) specifically hides the Ghost Dashboard when `ghostCount == 0`. User cannot confirm the feature exists.
2. **Exercises**: "Exercises" are accessed via the "Practice Lesson Grammar" button, which might not be explicit enough.

## Goals
1. **Visibility**: Ensure "Ghost Reviews" section is always visible in the main Grammar Screen, showing a positive state ("All caught up!") when empty.
2. **Clarity**: Rename/Enhance the "Practice" button to clearly indicate "Exercises / Quiz".

## Architecture
- **Frontend**: Flutter (Riverpod)
- **Screens**: 
    - `lib/features/grammar/grammar_screen.dart` (Main Level View)
    - `lib/features/lesson/widgets/grammar_list_widget.dart` (Lesson View)

## Proposed Changes

### 1. `GrammarScreen.dart`
- Remove `if (ghostCount == 0) return const SizedBox.shrink();`
- Add an "Empty State" for Ghost Dashboard:
    - Icon: `check_circle` (Green)
    - Text: "No mistakes pending"
    - Action: Disable "Review" button or change to "Practice Random"

### 2. `GrammarListWidget.dart`
- Update "Practice Lesson Grammar" button:
    - Change label to "Practice & Exercises" (or local equivalent).
    - Add a subtitle or icon indicating "Quiz".

### 3. Verification
- Manual verification via hot reload (if possible) or code review.
- Check `ghostCountProvider` logic.

## Task Breakdown
1. **Frontend Specialist**: Modify `GrammarScreen.dart` to show persistent Ghost Dashboard.
2. **Frontend Specialist**: Modify `GrammarListWidget.dart` to enhance Practice button.
3. **Test Engineer**: Verify logic handles 0 items correctly without errors.
