//
//  Model.swift
//  Solitaire
//
//  Created by Gary on 4/22/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit

class Game {
    static let sharedInstance = Game()

    // MARK: - Undo/Redo Support

    /// Undo manager for tracking game state history
    let undoManager = GameUndoManager()

    private init() {

    }

    // MARK: - Move Operations

    func moveTopCard(
        from: CardDataStack, to: CardDataStack, faceUp: Bool, makeNewTopCardFaceup: Bool
    ) {
        var card = from.topCard()
        if card != nil {
            card!.faceUp = faceUp
            to.addCard(card: card!)
            from.popCards(numberToPop: 1, makeNewTopCardFaceup: makeNewTopCardFaceup)
        }
    }

    func copyCards(from: CardDataStack, to: CardDataStack) {
        from.cards.forEach({ _ in
            self.moveTopCard(from: from, to: to, faceUp: false, makeNewTopCardFaceup: false)
        })
    }

    /// Performs a move operation with undo support
    /// - Parameter action: The move action to perform
    /// - Note: Automatically saves state before move and clears redo stack
    func performMove(_ action: () -> Void) {
        // Save current state before performing move
        let currentState = GameState(from: Model.sharedInstance)
        undoManager.saveState(currentState)

        // Perform the move
        action()
    }

    /// Undoes the last move
    /// - Returns: true if undo was successful
    @discardableResult
    func undo() -> Bool {
        return undoManager.performUndo(on: Model.sharedInstance)
    }

    /// Redoes the last undone move
    /// - Returns: true if redo was successful
    @discardableResult
    func redo() -> Bool {
        return undoManager.performRedo(on: Model.sharedInstance)
    }

    /// Checks if undo is available
    var canUndo: Bool {
        return undoManager.canUndo()
    }

    /// Checks if redo is available
    var canRedo: Bool {
        return undoManager.canRedo()
    }

    // MARK: - Game Management

    func shuffle() {
        Model.sharedInstance.shuffle()
    }

    func initalizeDeal() {
        self.shuffle()

        Model.sharedInstance.tableauStacks.forEach { $0.removeAllCards() }
        Model.sharedInstance.foundationStacks.forEach { $0.removeAllCards() }
        Model.sharedInstance.talonStack.removeAllCards()
        Model.sharedInstance.stockStack.removeAllCards()

        // Clear undo/redo history on new deal
        undoManager.clearHistory()
    }

}
