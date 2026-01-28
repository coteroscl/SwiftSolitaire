//
//  GameUndoManager.swift
//  Solitaire
//
//  Created by AI Senior iOS Engineer on 1/28/26.
//  Copyright © 2026 Gary Hanson. All rights reserved.
//

import Foundation

/// Manages undo/redo functionality for the Solitaire game using a state stack pattern.
///
/// This class maintains two stacks:
/// - Undo stack: Previous game states that can be restored
/// - Redo stack: Future game states (populated when user undoes, cleared on new move)
///
/// Memory is bounded by limiting the undo stack to a maximum depth (default 50 states).
class GameUndoManager {
    
    // MARK: - Properties
    
    /// Stack of previous game states (newest at end)
    private var undoStack: [GameState] = []
    
    /// Stack of future game states (newest at end)
    private var redoStack: [GameState] = []
    
    /// Maximum number of undo states to retain (prevents unbounded memory growth)
    /// Default: 50 states × ~1KB = ~50KB maximum memory for undo history
    private let maxUndoDepth: Int
    
    /// Current undo stack depth
    var undoDepth: Int {
        return undoStack.count
    }
    
    /// Current redo stack depth
    var redoDepth: Int {
        return redoStack.count
    }
    
    // MARK: - Initialization
    
    /// Creates a new GameUndoManager with specified maximum undo depth
    /// - Parameter maxUndoDepth: Maximum number of undo states to retain (default: 50)
    init(maxUndoDepth: Int = 50) {
        self.maxUndoDepth = maxUndoDepth
    }
    
    // MARK: - Public Interface
    
    /// Saves the current game state to the undo stack
    /// - Parameter state: The GameState to save
    /// - Note: Automatically enforces max depth by removing oldest states
    func saveState(_ state: GameState) {
        // Add state to undo stack
        undoStack.append(state)
        
        // Enforce maximum depth (FIFO - remove oldest if exceeded)
        if undoStack.count > maxUndoDepth {
            undoStack.removeFirst()
        }
        
        // Clear redo stack when new move is made
        // (can't redo after making a new move)
        redoStack.removeAll()
    }
    
    /// Attempts to undo to the previous state
    /// - Returns: The previous GameState if available, nil if undo stack is empty
    /// - Note: Current state should be saved before calling if you want to enable redo
    func undo() -> GameState? {
        guard !undoStack.isEmpty else {
            return nil
        }
        
        // Pop the most recent state from undo stack
        let previousState = undoStack.removeLast()
        
        return previousState
    }
    
    /// Saves the current state to redo stack before performing undo
    /// This enables the redo functionality
    /// - Parameter currentState: The current game state before undo
    func prepareForUndo(currentState: GameState) {
        redoStack.append(currentState)
    }
    
    /// Attempts to redo to the next state
    /// - Returns: The next GameState if available, nil if redo stack is empty
    /// - Note: Current state should be saved before calling to maintain undo chain
    func redo() -> GameState? {
        guard !redoStack.isEmpty else {
            return nil
        }
        
        // Pop the most recent state from redo stack
        let nextState = redoStack.removeLast()
        
        return nextState
    }
    
    /// Saves the current state to undo stack before performing redo
    /// This maintains the undo chain
    /// - Parameter currentState: The current game state before redo
    func prepareForRedo(currentState: GameState) {
        undoStack.append(currentState)
        
        // Enforce max depth even during redo
        if undoStack.count > maxUndoDepth {
            undoStack.removeFirst()
        }
    }
    
    /// Checks if undo is available
    /// - Returns: true if there are states in the undo stack
    func canUndo() -> Bool {
        return !undoStack.isEmpty
    }
    
    /// Checks if redo is available
    /// - Returns: true if there are states in the redo stack
    func canRedo() -> Bool {
        return !redoStack.isEmpty
    }
    
    /// Clears all undo and redo history
    /// - Note: Call this when starting a new game
    func clearHistory() {
        undoStack.removeAll()
        redoStack.removeAll()
    }
    
    // MARK: - Advanced Operations
    
    /// Peeks at the most recent undo state without removing it
    /// - Returns: The most recent GameState in undo stack, or nil if empty
    func peekUndo() -> GameState? {
        return undoStack.last
    }
    
    /// Peeks at the most recent redo state without removing it
    /// - Returns: The most recent GameState in redo stack, or nil if empty
    func peekRedo() -> GameState? {
        return redoStack.last
    }
    
    /// Removes the most recent state from undo stack without returning it
    /// - Returns: true if a state was removed, false if stack was empty
    @discardableResult
    func popUndo() -> Bool {
        guard !undoStack.isEmpty else {
            return false
        }
        undoStack.removeLast()
        return true
    }
    
    /// Removes the most recent state from redo stack without returning it
    /// - Returns: true if a state was removed, false if stack was empty
    @discardableResult
    func popRedo() -> Bool {
        guard !redoStack.isEmpty else {
            return false
        }
        redoStack.removeLast()
        return true
    }
    
    // MARK: - Memory Management
    
    /// Estimated total memory usage by undo/redo stacks
    /// - Returns: Approximate memory in bytes
    var estimatedMemoryUsage: Int {
        let totalStates = undoStack.count + redoStack.count
        return totalStates * GameState.estimatedMemoryFootprint
    }
    
    /// Compacts the undo stack by removing older states
    /// - Parameter keepCount: Number of most recent states to keep
    /// - Note: Use this if memory becomes a concern
    func compactUndoStack(keepCount: Int) {
        guard undoStack.count > keepCount else {
            return
        }
        
        let removeCount = undoStack.count - keepCount
        undoStack.removeFirst(removeCount)
    }
    
    // MARK: - Debugging
    
    /// Detailed summary of undo manager state (for debugging)
    var debugDescription: String {
        return """
        GameUndoManager State:
        - Max Depth: \(maxUndoDepth)
        - Undo Stack: \(undoStack.count) states
        - Redo Stack: \(redoStack.count) states
        - Can Undo: \(canUndo())
        - Can Redo: \(canRedo())
        - Memory Usage: ~\(estimatedMemoryUsage / 1024)KB
        """
    }
    
    /// Prints detailed history of all states in both stacks
    func printHistory() {
        print("=== UNDO HISTORY ===")
        for (index, state) in undoStack.enumerated() {
            print("[\(index)] \(state.timestamp) - Foundation: \(state.foundationCardCount) cards")
        }
        
        print("\n=== REDO HISTORY ===")
        for (index, state) in redoStack.enumerated() {
            print("[\(index)] \(state.timestamp) - Foundation: \(state.foundationCardCount) cards")
        }
    }
}

// MARK: - Convenience Extensions

extension GameUndoManager {
    
    /// Performs undo operation with automatic state management
    /// - Parameters:
    ///   - model: The Model instance to capture current state and restore previous state
    /// - Returns: true if undo was successful, false if no undo available
    func performUndo(on model: Model) -> Bool {
        guard canUndo() else {
            return false
        }
        
        // Save current state to redo stack
        let currentState = GameState(from: model)
        prepareForUndo(currentState: currentState)
        
        // Get and restore previous state
        if let previousState = undo() {
            previousState.restore(to: model)
            return true
        }
        
        return false
    }
    
    /// Performs redo operation with automatic state management
    /// - Parameters:
    ///   - model: The Model instance to capture current state and restore next state
    /// - Returns: true if redo was successful, false if no redo available
    func performRedo(on model: Model) -> Bool {
        guard canRedo() else {
            return false
        }
        
        // Save current state to undo stack
        let currentState = GameState(from: model)
        prepareForRedo(currentState: currentState)
        
        // Get and restore next state
        if let nextState = redo() {
            nextState.restore(to: model)
            return true
        }
        
        return false
    }
}

// MARK: - CustomStringConvertible

extension GameUndoManager: CustomStringConvertible {
    var description: String {
        return "UndoManager(undo: \(undoDepth), redo: \(redoDepth), memory: ~\(estimatedMemoryUsage/1024)KB)"
    }
}
