# SwiftSolitaire - Task Breakdown
## Detailed Implementation Checklist

**Project:** SwiftSolitaire Enhancement  
**Date Started:** 2026-01-28  
**Status:** Planning Complete, Ready for Implementation

---

## 🎯 Task Categories

- **P0:** Critical Path - Must Complete
- **P1:** High Priority - Should Complete
- **P2:** Medium Priority - Nice to Have
- **P3:** Low Priority - Future Enhancement

---

## Phase 1: Project Setup & Analysis ✅

### Task 1.1: Environment Setup ✅
- [x] Clone repository from GitHub
- [x] Analyze project structure
- [x] Review all Swift files
- [x] Identify architecture pattern (UIKit MVC)
- [x] Document current functionality
- [ ] Verify Xcode project opens in Antigravity
- [ ] Confirm build succeeds
- [ ] Run on iOS Simulator
- [ ] Test basic gameplay
- [ ] Document any environment-specific issues

**Priority:** P0  
**Estimated Time:** 2 hours  
**Status:** 80% Complete

---

### Task 1.2: Code Audit ✅
- [x] Review `Card.swift` (Data Model)
- [x] Review `Model.swift` (Singleton State)
- [x] Review `Game.swift` (Game Logic)
- [x] Review `CardStack.swift` (Stack Models)
- [x] Review `CardView.swift` (Card Rendering)
- [x] Review `CardStackView.swift` (Stack Views)
- [x] Review `SolitaireGameView.swift` (Main Game View)
- [x] Review `Utils.swift` (Helpers)
- [x] Identify dependencies
- [x] Map data flow
- [x] Document touch handling flow

**Priority:** P0  
**Estimated Time:** 3 hours  
**Status:** Complete ✅

---

### Task 1.3: Architecture Documentation ✅
- [x] Create implementation plan
- [x] Document current MVC architecture
- [x] Map view hierarchy
- [x] Document delegate patterns
- [x] Identify singleton usage
- [x] Create data flow diagrams (written description)
- [x] Document touch event flow
- [x] Risk assessment

**Priority:** P0  
**Estimated Time:** 4 hours  
**Status:** Complete ✅

---

## Phase 2: Foundation Infrastructure

### Task 2.1: Create GameState Model
**File:** `Solitaire/GameState.swift` (NEW)

**Subtasks:**
- [ ] Create `GameState` struct
- [ ] Implement tableau state capture (7 stacks)
- [ ] Implement foundation state capture (4 stacks)
- [ ] Implement stock stack state capture
- [ ] Implement talon stack state capture
- [ ] Add timestamp property
- [ ] Create initializer: `init(from model: Model)`
- [ ] Create restore method: `restore(to model: Model)`
- [ ] Add Equatable conformance for testing
- [ ] Add CustomStringConvertible for debugging

**Acceptance Criteria:**
- GameState captures complete game state
- State can be restored accurately
- Memory footprint ~400-500 bytes per state
- No reference cycles

**Priority:** P0  
**Estimated Time:** 3 hours  
**Dependencies:** None

---

### Task 2.2: Unit Tests for GameState
**File:** `SolitaireTests/GameStateTests.swift` (NEW)

**Subtasks:**
- [ ] Test state capture from fresh game
- [ ] Test state capture mid-game
- [ ] Test state restoration accuracy
- [ ] Test tableau stack restoration
- [ ] Test foundation stack restoration
- [ ] Test stock/talon restoration
- [ ] Test face-up/face-down preservation
- [ ] Test edge case: empty stacks
- [ ] Test edge case: full foundation
- [ ] Test memory usage with 50 states

**Acceptance Criteria:**
- 100% test coverage for GameState
- All edge cases handled
- No memory leaks

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** Task 2.1

---

### Task 2.3: Create UndoManager
**File:** `Solitaire/GameUndoManager.swift` (NEW)

**Subtasks:**
- [ ] Create `GameUndoManager` class
- [ ] Implement `undoStack: [GameState]`
- [ ] Implement `redoStack: [GameState]`
- [ ] Set `maxUndoSteps = 50`
- [ ] Implement `saveState(_ state: GameState)`
- [ ] Implement `undo() -> GameState?`
- [ ] Implement `redo() -> GameState?`
- [ ] Implement `canUndo() -> Bool`
- [ ] Implement `canRedo() -> Bool`
- [ ] Implement `clearHistory()`
- [ ] Add memory management (LRU if needed)
- [ ] Add state compression (if needed)

**Acceptance Criteria:**
- Stack operations work correctly
- Memory bounded to 50 states max
- Thread-safe (if multi-threaded access)
- Redo stack clears on new move

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** Task 2.1

---

### Task 2.4: Unit Tests for UndoManager
**File:** `SolitaireTests/GameUndoManagerTests.swift` (NEW)

**Subtasks:**
- [ ] Test saveState pushes to undo stack
- [ ] Test undo returns correct state
- [ ] Test redo returns correct state
- [ ] Test canUndo with empty stack
- [ ] Test canRedo with empty stack
- [ ] Test max depth enforcement (51st state)
- [ ] Test clearHistory empties both stacks
- [ ] Test redo stack clears on new save
- [ ] Test undo/redo sequence
- [ ] Performance test: 1000 operations

**Acceptance Criteria:**
- 100% test coverage
- All edge cases pass
- Performance acceptable

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** Task 2.3

---

## Phase 3: Feature 1 - Multi-Card Drag Enhancement

### Task 3.1: Analyze Current Multi-Card Logic
**File:** `Solitaire/SolitaireGameView.swift`

**Subtasks:**
- [x] Document current drag selection (lines 131-166)
- [x] Identify multi-card collection logic (lines 145-150)
- [x] Trace drag stack population
- [ ] Test current multi-card drag behavior
- [ ] Document any bugs or edge cases
- [ ] Create test scenarios

**Priority:** P0  
**Estimated Time:** 1 hour  
**Status:** 75% Complete

---

### Task 3.2: Enhance Multi-Card Validation
**File:** `Solitaire/CardStack.swift`

**Subtasks:**
- [ ] Add method: `canAcceptSequence(_ cards: [Card]) -> Bool` to `TableauStack`
- [ ] Validate first card in sequence
- [ ] Validate internal sequence (descending, alternating)
- [ ] Validate sequence is face-up
- [ ] Add method to `FoundationStack` (reject multi-card)
- [ ] Update documentation

**Acceptance Criteria:**
- Valid sequences accepted
- Invalid sequences rejected
- Edge cases handled (empty target, King to empty, etc.)

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** Task 3.1

---

### Task 3.3: Update Drop Logic
**File:** `Solitaire/SolitaireGameView.swift`

**Subtasks:**
- [ ] Locate drop validation (line 213)
- [ ] Replace `canAccept(droppedCard:)` with `canAcceptSequence(_ cards:)`
- [ ] Update Foundation drop (line 233) - ensure single card only
- [ ] Add visual feedback for invalid drops
- [ ] Test drag and drop flow
- [ ] Handle animation on drop

**Acceptance Criteria:**
- Multi-card drops validated correctly
- Single-card drops still work
- Foundation rejects multi-card
- Visual feedback clear

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** Task 3.2

---

### Task 3.4: Add Visual Feedback
**File:** `Solitaire/DragStackView.swift`

**Subtasks:**
- [ ] Add border highlight during drag
- [ ] Change opacity for valid drop zones
- [ ] Add "shake" animation for invalid drops
- [ ] Highlight valid drop zones in green
- [ ] Dim invalid drop zones
- [ ] Test on device

**Acceptance Criteria:**
- Clear visual indicators
- Smooth animations
- No performance impact

**Priority:** P1  
**Estimated Time:** 2 hours  
**Dependencies:** Task 3.3

---

### Task 3.5: Testing Multi-Card Drag
**File:** Manual Testing + Unit Tests

**Test Scenarios:**
- [ ] Drag K♠️ alone to empty tableau
- [ ] Drag valid sequence: K♥️-Q♠️-J♥️ to empty
- [ ] Drag valid sequence to matching card
- [ ] Attempt invalid sequence (same color)
- [ ] Attempt invalid sequence (non-descending)
- [ ] Drag multi-card to Foundation (should fail)
- [ ] Drag multi-card back to origin
- [ ] Drag with mix of face-down/up (should fail)
- [ ] Performance: Drag 13-card sequence

**Priority:** P0  
**Estimated Time:** 1 hour  
**Dependencies:** Task 3.3

---

## Phase 4: Feature 2 - Auto-Move to Foundation

### Task 4.1: Refactor Current Double-Tap
**File:** `Solitaire/SolitaireGameView.swift`

**Subtasks:**
- [x] Review current implementation (lines 263-298)
- [ ] Extract `addCardToFoundation` to separate method
- [ ] Create `tryMoveToFoundation(from:)` returning Bool
- [ ] Create `tryMoveToTableau(from:)` returning Bool
- [ ] Update `handleDoubleTap` to try both
- [ ] Add haptic feedback on success
- [ ] Add visual animation on auto-move

**Acceptance Criteria:**
- Code is modular and reusable
- Double-tap tries Foundation first, Tableau second
- Clear feedback on move

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** None

---

### Task 4.2: Implement Smart Auto-Move
**File:** `Solitaire/Game.swift`

**Subtasks:**
- [ ] Create `attemptAutoMove(card: Card) -> Bool`
- [ ] Add logic: if Ace → Foundation
- [ ] Add logic: if continues sequence → Foundation
- [ ] Add logic: try all Foundation stacks
- [ ] Add logic: if no Foundation, try Tableau
- [ ] Add logic: find best Tableau match
- [ ] Return success/failure
- [ ] Integrate with double-tap

**Acceptance Criteria:**
- Smart move priority correct
- All valid destinations tried
- No infinite loops

**Priority:** P0  
**Estimated Time:** 3 hours  
**Dependencies:** Task 4.1

---

### Task 4.3: Add Auto-Move All (Optional)
**File:** `Solitaire/Game.swift`

**Subtasks:**
- [ ] Create `autoMoveAll() -> Int` (returns # of cards moved)
- [ ] Scan Tableau for movable cards
- [ ] Scan Talon for movable cards
- [ ] Move safe cards to Foundation
- [ ] Avoid risky moves (blocking other cards)
- [ ] Add UI button for Auto-Move All
- [ ] Add confirmation dialog if > 5 moves
- [ ] Test with various game states

**Acceptance Criteria:**
- Only safe moves made
- User can enable/disable feature
- Clear indication of what moved

**Priority:** P2  
**Estimated Time:** 4 hours  
**Dependencies:** Task 4.2

---

### Task 4.4: Testing Auto-Move
**File:** Manual Testing

**Test Scenarios:**
- [ ] Double-tap Ace (should go to Foundation)
- [ ] Double-tap 2♥️ when A♥️ in Foundation
- [ ] Double-tap card that has no valid move
- [ ] Double-tap card with multiple valid moves
- [ ] Auto-move from Talon
- [ ] Auto-move from Tableau
- [ ] Auto-move after undo
- [ ] Performance: Auto-move with full game

**Priority:** P0  
**Estimated Time:** 1 hour  
**Dependencies:** Task 4.2

---

## Phase 5: Feature 3 - Undo/Redo Integration

### Task 5.1: Add UndoManager to Game
**File:** `Solitaire/Game.swift`

**Subtasks:**
- [ ] Add property: `let undoManager = GameUndoManager()`
- [ ] Create `performMove(_ action: () -> Void)`
- [ ] Save state before action
- [ ] Execute action
- [ ] Clear redo stack on new move
- [ ] Add undo() method
- [ ] Add redo() method
- [ ] Add canUndo/canRedo computed properties

**Acceptance Criteria:**
- All moves go through performMove
- State saved before every move
- Undo/redo work correctly

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** Task 2.3

---

### Task 5.2: Wrap Drag-Drop Moves
**File:** `Solitaire/SolitaireGameView.swift`

**Subtasks:**
- [ ] Locate `touchesEnded` (line 203)
- [ ] Wrap successful tableau move in performMove
- [ ] Wrap successful foundation move in performMove
- [ ] Ensure state saved before move
- [ ] Test undo after drag-drop
- [ ] Handle animation on undo

**Acceptance Criteria:**
- Drag-drop moves are undoable
- State restored correctly
- UI updates properly

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** Task 5.1

---

### Task 5.3: Wrap Auto-Move Actions
**File:** `Solitaire/SolitaireGameView.swift`

**Subtasks:**
- [ ] Wrap `handleDoubleTap` moves
- [ ] Wrap auto-move to Foundation
- [ ] Wrap auto-move to Tableau
- [ ] Test undo after double-tap
- [ ] Ensure proper state capture

**Acceptance Criteria:**
- Auto-moves are undoable
- State matches before double-tap

**Priority:** P0  
**Estimated Time:** 1 hour  
**Dependencies:** Task 5.1, Task 4.1

---

### Task 5.4: Wrap Stock/Talon Moves
**File:** `Solitaire/CardStackView.swift`

**Subtasks:**
- [ ] Locate `StockCardStackView.handleTap` (line 236)
- [ ] Wrap stock-to-talon move
- [ ] Wrap talon-to-stock recycle
- [ ] Test undo after stock tap
- [ ] Test redo after undo

**Acceptance Criteria:**
- Stock taps are undoable
- Recycling is undoable
- State accurate

**Priority:** P0  
**Estimated Time:** 1 hour  
**Dependencies:** Task 5.1

---

### Task 5.5: Create Undo/Redo UI
**File:** `Solitaire/SolitaireGameView.swift`

**Subtasks:**
- [ ] Add Undo button next to "New Deal"
- [ ] Add Redo button next to Undo
- [ ] Wire up button actions
- [ ] Update button enabled state on moves
- [ ] Style buttons (icons?)
- [ ] Add keyboard shortcuts (Cmd+Z, Cmd+Shift+Z)
- [ ] Add haptic feedback on undo/redo
- [ ] Test button interaction

**Acceptance Criteria:**
- Buttons visually clear
- Enabled/disabled states correct
- Keyboard shortcuts work (if on Mac/iPad)
- Smooth user experience

**Priority:** P0  
**Estimated Time:** 3 hours  
**Dependencies:** Task 5.1

---

### Task 5.6: Handle New Deal
**File:** `Solitaire/SolitaireGameView.swift`

**Subtasks:**
- [ ] Locate `newDealAction` (line 85)
- [ ] Clear undo history on new deal
- [ ] Add confirmation dialog if history exists
- [ ] Test: new deal → undo disabled
- [ ] Test: new deal → redo disabled

**Acceptance Criteria:**
- History cleared on new deal
- No memory leaks
- User can confirm or cancel

**Priority:** P0  
**Estimated Time:** 1 hour  
**Dependencies:** Task 5.5

---

### Task 5.7: State Restoration Animation
**File:** `Solitaire/Game.swift` + Views

**Subtasks:**
- [ ] Add `restoreState(_ state: GameState, animated: Bool)`
- [ ] Implement fade-out animation
- [ ] Restore state
- [ ] Implement fade-in animation
- [ ] Test animation smoothness
- [ ] Add option to disable animations

**Acceptance Criteria:**
- Smooth transition on undo/redo
- No visual glitches
- Performance acceptable

**Priority:** P1  
**Estimated Time:** 2 hours  
**Dependencies:** Task 5.1

---

### Task 5.8: Edge Case Handling
**File:** Various

**Subtasks:**
- [ ] Test undo at max depth (50 moves)
- [ ] Test redo after partial undo chain
- [ ] Test undo/redo with multi-card drag
- [ ] Test undo after auto-move
- [ ] Test undo during stock recycle
- [ ] Test rapid undo/redo button presses
- [ ] Test undo with no history
- [ ] Test redo with no future states
- [ ] Memory test: 100 games with undo

**Acceptance Criteria:**
- All edge cases handled gracefully
- No crashes
- No memory leaks
- Correct state always

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** All Task 5.x

---

## Phase 6: Testing & QA

### Task 6.1: Unit Test Coverage
**Files:** `SolitaireTests/*.swift`

**Subtasks:**
- [ ] Test all Card methods
- [ ] Test all Stack validation methods
- [ ] Test GameState capture/restore
- [ ] Test UndoManager operations
- [ ] Test Game move logic
- [ ] Achieve 80%+ code coverage
- [ ] Document uncovered code

**Priority:** P0  
**Estimated Time:** 4 hours  
**Dependencies:** All implementation tasks

---

### Task 6.2: Integration Testing
**Files:** Manual testing with scenarios

**Subtasks:**
- [ ] Test complete game flow with new features
- [ ] Test multi-card drag → undo → redo
- [ ] Test auto-move → undo → manual move
- [ ] Test stock tap → undo → re-tap
- [ ] Test mixed move types in sequence
- [ ] Test win condition with undo available
- [ ] Test new deal with undo history
- [ ] Log any issues found

**Priority:** P0  
**Estimated Time:** 3 hours  
**Dependencies:** All features complete

---

### Task 6.3: Performance Testing
**Files:** Instruments + manual profiling

**Subtasks:**
- [ ] Profile memory usage with 50 undo states
- [ ] Profile CPU during multi-card drag
- [ ] Profile animation smoothness (60 FPS?)
- [ ] Test on older device (iPhone SE)
- [ ] Test on large screen (iPad Pro)
- [ ] Optimize any bottlenecks
- [ ] Document performance metrics

**Priority:** P1  
**Estimated Time:** 2 hours  
**Dependencies:** All features complete

---

### Task 6.4: Antigravity Simulator Testing
**Files:** Run on Antigravity environment

**Subtasks:**
- [ ] Build project in Antigravity
- [ ] Launch iOS Simulator
- [ ] Test all features
- [ ] Verify touch handling
- [ ] Verify rendering
- [ ] Document any simulator-specific issues
- [ ] Test keyboard shortcuts (if applicable)
- [ ] Verify no environment conflicts

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** All features complete

---

### Task 6.5: User Acceptance Testing
**Files:** Real-world gameplay

**Subtasks:**
- [ ] Play 5 complete games
- [ ] Use undo frequently
- [ ] Test all auto-move scenarios
- [ ] Test multi-card drag in complex layouts
- [ ] Verify intuitive UX
- [ ] Collect feedback
- [ ] Make UX improvements if needed

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** Task 6.4

---

## Phase 7: Polish & Documentation

### Task 7.1: Code Cleanup
**Files:** All modified files

**Subtasks:**
- [ ] Remove debug print statements
- [ ] Add code comments
- [ ] Format code consistently
- [ ] Remove unused imports
- [ ] Remove commented-out code
- [ ] Run SwiftLint (if available)
- [ ] Fix any warnings

**Priority:** P1  
**Estimated Time:** 2 hours  
**Dependencies:** All implementation complete

---

### Task 7.2: Update README
**File:** `README.md` (NEW or UPDATE)

**Subtasks:**
- [ ] Add project description
- [ ] Document new features
- [ ] Add build instructions
- [ ] Add usage examples
- [ ] Document undo/redo limits
- [ ] Add screenshots (optional)
- [ ] Credit original author
- [ ] Add license info

**Priority:** P1  
**Estimated Time:** 1 hour  
**Dependencies:** All features complete

---

### Task 7.3: Inline Documentation
**Files:** All new files

**Subtasks:**
- [ ] Add header comments to new files
- [ ] Document public methods
- [ ] Add parameter descriptions
- [ ] Add return value descriptions
- [ ] Document edge cases
- [ ] Add usage examples in comments

**Priority:** P1  
**Estimated Time:** 2 hours  
**Dependencies:** Task 7.1

---

### Task 7.4: Create User Guide
**File:** `USERGUIDE.md` (NEW)

**Subtasks:**
- [ ] Explain game rules
- [ ] Document multi-card drag
- [ ] Document auto-move (double-tap)
- [ ] Document undo/redo
- [ ] Add keyboard shortcuts
- [ ] Add tips and tricks
- [ ] Add troubleshooting section

**Priority:** P2  
**Estimated Time:** 1 hour  
**Dependencies:** All features complete

---

## Phase 8: Deployment Preparation

### Task 8.1: Version Bump
**File:** `Info.plist` or project settings

**Subtasks:**
- [ ] Update version number (e.g., 2.0.0)
- [ ] Update build number
- [ ] Update app description
- [ ] Review deployment target
- [ ] Review Swift version requirement

**Priority:** P1  
**Estimated Time:** 0.5 hours  
**Dependencies:** All features complete

---

### Task 8.2: Create Release Notes
**File:** `CHANGELOG.md` (NEW)

**Subtasks:**
- [ ] Document version 2.0.0 changes
- [ ] List new features
- [ ] List bug fixes
- [ ] List known issues (if any)
- [ ] Add upgrade instructions
- [ ] Add breaking changes (if any)

**Priority:** P1  
**Estimated Time:** 0.5 hours  
**Dependencies:** All features complete

---

### Task 8.3: Final QA Pass
**Files:** Complete app

**Subtasks:**
- [ ] Fresh install test
- [ ] Test on minimum iOS version
- [ ] Test on maximum iOS version
- [ ] Test on smallest screen size
- [ ] Test on largest screen size
- [ ] Verify no crashes
- [ ] Verify no memory leaks
- [ ] Sign-off checklist completion

**Priority:** P0  
**Estimated Time:** 2 hours  
**Dependencies:** All previous tasks

---

## 📊 Progress Tracking

### Summary
- **Total Tasks:** 56
- **Completed:** 8
- **In Progress:** 5
- **Not Started:** 43
- **Blocked:** 0

### Time Estimates
- **Phase 1 (Setup):** 9 hours ✅ (80% complete)
- **Phase 2 (Foundation):** 9 hours
- **Phase 3 (Multi-Card):** 8 hours
- **Phase 4 (Auto-Move):** 10 hours
- **Phase 5 (Undo/Redo):** 14 hours
- **Phase 6 (Testing):** 13 hours
- **Phase 7 (Polish):** 6 hours
- **Phase 8 (Deploy):** 3 hours

**Total Estimated Time:** 72 hours (~2 weeks at 40hr/week)

---

## 🚀 Quick Start Next Steps

1. **Complete Environment Setup** (Task 1.1)
   - [ ] Verify Xcode build
   - [ ] Run on simulator
   - [ ] Test basic gameplay

2. **Begin Foundation Infrastructure** (Phase 2)
   - Start with Task 2.1: GameState model
   - Critical path for undo/redo

3. **Daily Progress Tracking**
   - Update task checkboxes
   - Log blockers immediately
   - Daily commit to GitHub

---

## ⚠️ Known Risks & Mitigation

| Risk | Task | Mitigation |
|------|------|------------|
| GameState too large | 2.1 | Monitor memory, optimize if >1KB |
| Undo animation lag | 5.7 | Profile and simplify if needed |
| Simulator incompatibility | 6.4 | Early testing in Phase 1 |
| Scope creep | All | Strict prioritization, no P3 until P0/P1 done |

---

## 📝 Notes

- Mark tasks with ✅ when complete
- Add 🚧 emoji for in-progress tasks
- Add 🔴 emoji for blocked tasks with reason
- Update progress daily
- Celebrate milestones! 🎉

---

*Last Updated: 2026-01-28*  
*Next Review: Daily during standup*
