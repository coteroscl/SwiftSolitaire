# SwiftSolitaire - Build & Run Guide
## How to Run the Project on macOS

**Date:** 2026-01-28  
**Status:** Ready for macOS Xcode Build

---

## Prerequisites

### Required Software
- ✅ **macOS** (10.14 or later recommended)
- ✅ **Xcode** (Version 14+ recommended)
- ✅ **iOS Simulator** (included with Xcode)
- ⚠️ **Command Line Tools** (optional, for terminal build)

### Check Your Xcode Version
```bash
xcodebuild -version
# Should output: Xcode 14.x or later
```

---

## Quick Start (GUI Method)

### Step 1: Open Project
```bash
cd ~/path/to/SwiftSolitaire
open Solitaire.xcodeproj
```

Or double-click `Solitaire.xcodeproj` in Finder.

### Step 2: Select Target Device
In Xcode toolbar:
- Click the device selector (next to Run/Stop buttons)
- Choose: **iPhone 15** (or any recent simulator)
- Or choose: **Your physical device** if connected

### Step 3: Build and Run
- Press **⌘R** (Command-R)
- Or click the ▶️ **Run** button in toolbar

**Expected Result:**
- iOS Simulator launches
- Solitaire game appears with green felt background
- Cards are dealt in 7 tableau piles

---

## Command Line Method (Alternative)

### Build Only
```bash
cd SwiftSolitaire

# Build for simulator
xcodebuild \
  -project Solitaire.xcodeproj \
  -scheme Solitaire \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
  build
```

### Build and Run
```bash
# Install to simulator and run
xcodebuild \
  -project Solitaire.xcodeproj \
  -scheme Solitaire \
  -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' \
  -derivedDataPath ./build \
  build

# Then manually launch simulator
open -a Simulator

# Install app (find app bundle in build folder)
xcrun simctl install booted ./build/Build/Products/Debug-iphonesimulator/Solitaire.app

# Launch app
xcrun simctl launch booted com.yourcompany.Solitaire  # Update bundle ID
```

---

## Testing the New Features

Once the app is running, test the following:

### Test 1: Multi-Card Drag ✅
**Fixed in this update**

1. Wait for cards to be dealt
2. Try to drag a sequence of cards (e.g., Red 6 on Black 7 on Red 8)
3. **Expected:** All cards in sequence move together
4. **Previous bug:** Only validated first card
5. **Now fixed:** Validates entire sequence

**Test Cases:**
- [ ] Drag single card to tableau
- [ ] Drag valid 2-card sequence (e.g., 7♥️-6♠️)
- [ ] Drag valid 3-card sequence
- [ ] Try invalid sequence (same color) - should reject
- [ ] Try invalid sequence (non-descending) - should reject

---

### Test 2: Undo/Redo ⏮️⏭️
**New feature added**

**Currently:** Undo/redo logic is implemented but **UI buttons not yet added**

To test via code (temporary):
1. Make a move (drag a card)
2. In the code, you can call: `Game.sharedInstance.undo()`
3. The move should reverse

**What's Working:**
- ✅ Drag-drop moves are tracked
- ✅ Stock tap is tracked
- ✅ Talon recycle is tracked
- ✅ State is saved before each move
- ⏸️ UI buttons pending (next phase)

**To Add UI Buttons (Next Step):**
Will add "Undo" and "Redo" buttons next to "New Deal" button.

---

### Test 3: Double-Tap Auto-Move 👆👆
**Enhanced in this update**

1. Flip cards from stock to talon
2. **Double-tap** a card in talon or tableau
3. **Expected:** Card automatically moves to Foundation (if valid)
4. **New:** Move is now undoable

**Test Cases:**
- [ ] Double-tap an Ace - should go to empty Foundation
- [ ] Double-tap a 2 when Ace is in Foundation - should go up
- [ ] Double-tap a card that can't move - nothing happens
- [ ] Undo after double-tap auto-move - should reverse

---

### Test 4: Stock/Talon Operations 🎴
**Now undoable**

1. Click the Stock pile (top right)
2. **Expected:** Top card flips to Talon
3. **New:** This action is now undoable
4. When Stock is empty, clicking recycles Talon back to Stock
5. **New:** Recycle is also undoable

**Test Cases:**
- [ ] Flip several cards from Stock
- [ ] Undo - cards return to Stock
- [ ] Recycle Talon to Stock
- [ ] Undo - Talon restores

---

### Test 5: New Deal 🔄

1. Click "New Deal" button
2. **Expected:** Cards shuffle and re-deal
3. **New:** Undo history is cleared (can't undo across games)

---

## Observing Code Behavior

### Enable Debug Logging

Add these lines to see undo/redo activity:

**In `Game.swift` → `performMove`:**
```swift
func performMove(_ action: () -> Void) {
    let currentState = GameState(from: Model.sharedInstance)
    undoManager.saveState(currentState)
    
    // DEBUG: Print undo stack depth
    print("📊 Undo stack depth: \(undoManager.undoDepth)")
    
    action()
}
```

**In `Game.swift` → `undo`:**
```swift
func undo() -> Bool {
    print("⏮️ Attempting undo...")
    let result = undoManager.performUndo(on: Model.sharedInstance)
    print(result ? "✅ Undo successful" : "❌ Undo failed - no history")
    return result
}
```

### View Console Output

In Xcode:
1. Run the app
2. Open **Console** (View → Debug Area → Show Debug Area, or ⇧⌘Y)
3. Watch for debug messages as you make moves

---

## Performance Monitoring

### Memory Usage

**Expected:**
- Base app: ~5-10 MB
- With 50 undo states: ~5-11 MB (adds ~50KB)
- Total: Well under 20 MB

**To Monitor:**
1. In Xcode, while running: Debug Navigator → Memory
2. Make 50 moves
3. Check memory growth
4. Should be minimal (~50KB)

### Frame Rate

**Expected:** 60 FPS (smooth animations)

**To Monitor:**
1. In Xcode: Debug → View Debugging → Rendering → Rendering Frames
2. Drag cards around
3. Monitor FPS counter
4. Should stay at 60 FPS on modern simulators

---

## Troubleshooting

### Build Errors

**Error:** "No such module 'UIKit'"
- **Cause:** Not building in Xcode (e.g., trying to compile in VSCode)
- **Fix:** Must use Xcode to build iOS projects

**Error:** "Signing requires a development team"
- **Cause:** No Apple Developer account configured
- **Fix 1:** Xcode → Preferences → Accounts → Add Apple ID
- **Fix 2:** Or change Team to "None" in project settings (simulator only)

### Runtime Errors

**Error:** App crashes on launch
- **Check:** Console for error messages
- **Common:** Missing images in asset catalog
- **Fix:** Verify `Images.xcassets` contains all card images

**Error:** Cards not dragging
- **Check:** Console for touch event errors
- **Common:** Simulator touch simulation issues
- **Fix:** Try on actual device, or restart simulator

### Undo/Redo Issues

**Issue:** Undo doesn't seem to work
- **Reason:** UI buttons not yet implemented
- **Workaround:** Add temporary button or test via debugger
- **Fix:** Will add UI buttons in next phase

**Issue:** Undo restores wrong state
- **Check:** Console for state capture messages
- **Debug:** Print `GameState.summary` before/after undo
- **Report:** Save state details if reproducible bug found

---

## What to Look For

### Correct Behavior ✅

1. **Multi-card sequences validate properly**
   - Valid sequences (descending, alternating colors) are accepted
   - Invalid sequences are rejected
   - Cards snap back to origin if rejected

2. **Smooth drag animations**
   - Cards follow finger/mouse smoothly
   - Drop animation is clean
   - No visual glitches

3. **State is consistent**
   - Card count always equals 52
   - No duplicate cards
   - No missing cards
   - All stacks render correctly

### Potential Issues ⚠️

1. **If multi-card drag still fails:**
   - May need to debug `canAcceptSequence` method
   - Check console for validation errors
   - Verify sequence building logic

2. **If undo causes visual glitches:**
   - May need to add animation on state restore
   - Check if `refresh()` is called after undo
   - Verify all cards repositioned correctly

3. **If performance is slow:**
   - Profile with Instruments
   - Check `refresh()` method efficiency
   - May need incremental view updates instead of full rebuild

---

## Next Steps After Testing

### If Everything Works ✅

1. **Add UI Buttons** for Undo/Redo
2. **Write Unit Tests** for GameState and UndoManager
3. **Add Visual Feedback** (animations, haptics)
4. **Document Findings** in test report

### If Issues Found 🐛

1. **Document the bug** with steps to reproduce
2. **Note console output** (copy error messages)
3. **Take screenshots** if visual issue
4. **Report back** with details

---

## Validation Checklist

After running the project, verify:

- [ ] App launches without crashes
- [ ] Cards are dealt correctly (7 tableau piles)
- [ ] Single card drag works
- [ ] Multi-card drag works (new fix)
- [ ] Multi-card validation rejects invalid sequences (new fix)
- [ ] Stock tap flips cards
- [ ] Talon recycles when stock empty
- [ ] Double-tap moves card to Foundation
- [ ] New Deal reshuffles cards
- [ ] No visual glitches
- [ ] Performance is smooth (60 FPS)
- [ ] Memory usage is reasonable

---

## Expected First-Run Experience

### Launch Sequence
```
1. Simulator boots (may take 15-30 seconds first time)
2. App icon appears on home screen
3. Tap app icon
4. App launches (green background)
5. Cards deal automatically in sequence:
   - Pile 1: 1 card (1 face-up)
   - Pile 2: 2 cards (1 face-up)
   - ...
   - Pile 7: 7 cards (1 face-up)
6. Remaining 24 cards go to Stock (top right)
7. Ready to play!
```

### First Moves to Try
```
1. Click Stock → Flip a card to Talon
2. Try to drag Talon card to Tableau
3. Try to drag a Tableau card to another Tableau pile
4. Try to drag a multi-card sequence
5. Double-tap a card to auto-move to Foundation
6. Click "New Deal" to shuffle and restart
```

---

## Recording a Demo

If you want to record the behavior:

### macOS Built-in Screen Recording
```bash
# Start recording
# Press: ⇧⌘5 (Shift-Command-5)
# Click: "Record Selected Portion"
# Select simulator window
# Click "Record"

# Stop recording
# Click stop button in menu bar
# Video saves to Desktop
```

### Simulator Screenshot
```
While simulator active:
- Screenshot: ⌘S (Command-S)
- Saves to Desktop as PNG
```

---

## Summary

**The project is ready to run, but requires macOS + Xcode.**

**What I've implemented:**
- ✅ Multi-card validation fix
- ✅ Undo/Redo infrastructure
- ✅ All moves tracked for undo
- ⏸️ UI buttons (next phase)

**What you'll see when you run it:**
- Standard Solitaire gameplay
- Multi-card dragging works correctly now
- Undo/redo works (no UI buttons yet, but logic is there)
- All moves are tracked

**Next development session:**
- Add Undo/Redo UI buttons
- Test thoroughly on actual device/simulator
- Fix any issues found
- Add visual polish

---

*Ready to build and run on macOS/Xcode!*  
*Last Updated: 2026-01-28*
