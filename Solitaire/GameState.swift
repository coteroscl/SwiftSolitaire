//
//  GameState.swift
//  Solitaire
//
//  Created by AI Senior iOS Engineer on 1/28/26.
//  Copyright © 2026 Gary Hanson. All rights reserved.
//

import Foundation

/// Represents a complete snapshot of the game state at a specific point in time.
/// Used for implementing undo/redo functionality via the Memento pattern.
///
/// This struct captures the state of all card stacks (tableau, foundation, stock, talon)
/// and can restore the game to this exact state later.
struct GameState: Equatable {
    
    // MARK: - Properties
    
    /// State of the 7 tableau stacks (bottom row, where main gameplay occurs)
    let tableauStacks: [[Card]]
    
    /// State of the 4 foundation stacks (top left, Ace to King by suit)
    let foundationStacks: [[Card]]
    
    /// State of the stock stack (top right, face-down cards)
    let stockStack: [Card]
    
    /// State of the talon stack (next to stock, face-up flipped cards)
    let talonStack: [Card]
    
    /// Timestamp when this state was captured (for debugging and analytics)
    let timestamp: Date
    
    // MARK: - Initialization
    
    /// Creates a GameState snapshot from the current Model state
    /// - Parameter model: The Model singleton instance to capture state from
    init(from model: Model) {
        // Capture tableau stacks (7 stacks)
        self.tableauStacks = model.tableauStacks.map { stack in
            stack.cards.map { Card(value: $0.value, faceUp: $0.faceUp) }
        }
        
        // Capture foundation stacks (4 stacks)
        self.foundationStacks = model.foundationStacks.map { stack in
            stack.cards.map { Card(value: $0.value, faceUp: $0.faceUp) }
        }
        
        // Capture stock stack
        self.stockStack = model.stockStack.cards.map { card in
            Card(value: card.value, faceUp: card.faceUp)
        }
        
        // Capture talon stack
        self.talonStack = model.talonStack.cards.map { card in
            Card(value: card.value, faceUp: card.faceUp)
        }
        
        // Record timestamp
        self.timestamp = Date()
    }
    
    /// Creates a custom GameState (primarily for testing)
    /// - Parameters:
    ///   - tableauStacks: Array of 7 card arrays for tableau
    ///   - foundationStacks: Array of 4 card arrays for foundation
    ///   - stockStack: Array of cards for stock
    ///   - talonStack: Array of cards for talon
    ///   - timestamp: Optional timestamp (defaults to now)
    init(tableauStacks: [[Card]],
         foundationStacks: [[Card]],
         stockStack: [Card],
         talonStack: [Card],
         timestamp: Date = Date()) {
        self.tableauStacks = tableauStacks
        self.foundationStacks = foundationStacks
        self.stockStack = stockStack
        self.talonStack = talonStack
        self.timestamp = timestamp
    }
    
    // MARK: - State Restoration
    
    /// Restores the Model to this saved state
    /// - Parameter model: The Model singleton instance to restore state to
    /// - Note: This method performs a complete state restoration, replacing all cards in all stacks
    func restore(to model: Model) {
        // Clear drag stack (should be empty when restoring)
        model.dragStack.removeAllCards()
        
        // Restore tableau stacks (7 stacks)
        for (index, stackCards) in tableauStacks.enumerated() {
            model.tableauStacks[index].removeAllCards()
            stackCards.forEach { card in
                model.tableauStacks[index].addCard(card: card)
            }
        }
        
        // Restore foundation stacks (4 stacks)
        for (index, stackCards) in foundationStacks.enumerated() {
            model.foundationStacks[index].removeAllCards()
            stackCards.forEach { card in
                model.foundationStacks[index].addCard(card: card)
            }
        }
        
        // Restore stock stack
        model.stockStack.removeAllCards()
        stockStack.forEach { card in
            model.stockStack.addCard(card: card)
        }
        
        // Restore talon stack
        model.talonStack.removeAllCards()
        talonStack.forEach { card in
            model.talonStack.addCard(card: card)
        }
    }
    
    // MARK: - Debugging & Analytics
    
    /// Total number of cards across all stacks (should always be 52)
    var totalCards: Int {
        let tableauCount = tableauStacks.reduce(0) { $0 + $1.count }
        let foundationCount = foundationStacks.reduce(0) { $0 + $1.count }
        let stockCount = stockStack.count
        let talonCount = talonStack.count
        return tableauCount + foundationCount + stockCount + talonCount
    }
    
    /// Number of cards in foundation (progress toward winning)
    var foundationCardCount: Int {
        return foundationStacks.reduce(0) { $0 + $1.count }
    }
    
    /// Checks if this state represents a won game (all 52 cards in foundation)
    var isGameWon: Bool {
        return foundationCardCount == 52
    }
    
    /// Returns a summary description of the game state
    var summary: String {
        return """
        GameState Summary:
        - Timestamp: \(timestamp)
        - Total Cards: \(totalCards)/52
        - Foundation: \(foundationCardCount) cards
        - Tableau: \(tableauStacks.map { $0.count })
        - Stock: \(stockStack.count)
        - Talon: \(talonStack.count)
        - Game Won: \(isGameWon)
        """
    }
}

// MARK: - Equatable Conformance

extension GameState {
    /// Two GameStates are equal if all their card stacks contain the same cards in the same order
    /// Note: Timestamp is intentionally ignored in equality check
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        return lhs.tableauStacks == rhs.tableauStacks &&
               lhs.foundationStacks == rhs.foundationStacks &&
               lhs.stockStack == rhs.stockStack &&
               lhs.talonStack == rhs.talonStack
    }
}

// MARK: - CustomStringConvertible

extension GameState: CustomStringConvertible {
    var description: String {
        return summary
    }
}

// MARK: - Memory Estimation

extension GameState {
    /// Estimated memory footprint of this state snapshot
    /// - Returns: Approximate size in bytes
    /// - Note: Used for monitoring memory usage with large undo stacks
    static var estimatedMemoryFootprint: Int {
        // Each Card struct: ~16 bytes (Int + Bool + padding)
        // 52 cards × 16 bytes = 832 bytes
        // Plus array overhead and metadata ≈ 100 bytes
        // Total per state: ~1 KB (conservative estimate)
        return 1024
    }
}
