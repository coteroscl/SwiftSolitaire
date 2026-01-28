//
//  CardStack.swift
//  CardStacks
//
//  Created by Gary on 4/22/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import Foundation

// CardDataStacks have the card info for each card in the stack.
// CardStackView's subviews are CardViews based on these cards

protocol CardStackDelegate: AnyObject {
    func refresh()
}
class CardDataStack {
    weak var delegate: CardStackDelegate?

    var cards = [Card]()

    func addCard(card: Card) {
        cards.append(card)
        delegate?.refresh()
    }

    func canAccept(droppedCard: Card) -> Bool {
        return false
    }

    func topCard() -> Card? {
        return cards.last
    }

    func removeAllCards() {
        self.cards.removeAll()
        delegate?.refresh()
    }

    func popCards(numberToPop: Int, makeNewTopCardFaceup: Bool) {
        guard cards.count >= numberToPop else {
            assert(false, "Attempted to pop more cards than are on the stack!")
            return
        }

        cards.removeLast(numberToPop)

        if makeNewTopCardFaceup {
            var card = self.topCard()
            if card != nil {
                cards.removeLast()
                card!.faceUp = true
                cards.append(card!)
            }
        }
        delegate?.refresh()
    }

    var isEmpty: Bool {
        return cards.isEmpty
    }

}
final class TableauStack: CardDataStack {

    override func canAccept(droppedCard: Card) -> Bool {

        if let topCard = self.topCard() {
            let (_, topCardRank) = topCard.getCardSuitAndRank()
            let (_, droppedCardRank) = droppedCard.getCardSuitAndRank()
            if topCard.faceUp && !topCard.cardSuitIsSameColor(card: droppedCard)
                && (droppedCardRank == topCardRank - 1)
            {
                return true
            }
        } else {
            // if pile is empty accept any King
            if droppedCard.isKing {
                return true
            }
        }

        return false
    }

    /// Validates if a sequence of cards can be accepted
    /// - Parameter cards: Array of cards to validate (first card is the one being placed)
    /// - Returns: true if the entire sequence is valid for this tableau stack
    /// - Note: Validates both the first card placement AND the internal sequence validity
    func canAcceptSequence(_ cards: [Card]) -> Bool {
        // Empty sequence is invalid
        guard !cards.isEmpty else {
            return false
        }

        // Single card uses existing validation
        if cards.count == 1 {
            return canAccept(droppedCard: cards[0])
        }

        // Multi-card sequence validation
        // Step 1: Check if first card can be placed on this stack
        let firstCard = cards[0]
        guard canAccept(droppedCard: firstCard) else {
            return false
        }

        // Step 2: Validate internal sequence (descending rank, alternating colors, all face-up)
        for i in 0..<cards.count - 1 {
            let currentCard = cards[i]
            let nextCard = cards[i + 1]

            // All cards must be face-up
            guard currentCard.faceUp && nextCard.faceUp else {
                return false
            }

            // Get ranks
            let (_, currentRank) = currentCard.getCardSuitAndRank()
            let (_, nextRank) = nextCard.getCardSuitAndRank()

            // Next card must be one rank lower (descending)
            guard nextRank == currentRank - 1 else {
                return false
            }

            // Next card must be opposite color (alternating)
            guard !currentCard.cardSuitIsSameColor(card: nextCard) else {
                return false
            }
        }

        return true
    }
}
final class FoundationStack: CardDataStack {

    override func canAccept(droppedCard: Card) -> Bool {
        if cards.isEmpty {
            return droppedCard.isAce  // if pile is empty, take any Ace
        }

        if let topCard = self.topCard() {
            let (topSuit, topRank) = topCard.getCardSuitAndRank()
            let (droppedSuit, droppedRank) = droppedCard.getCardSuitAndRank()
            if topSuit == droppedSuit && droppedRank == topRank + 1 {
                return true
            }
        }

        return false
    }
}
final class TalonStack: CardDataStack {

    override func canAccept(droppedCard: Card) -> Bool {
        // can't drop anything here
        return false
    }
}
final class StockStack: CardDataStack {

    override func canAccept(droppedCard: Card) -> Bool {
        // can't drop anything here
        return false
    }
}
final class DragStack: CardDataStack {

}
