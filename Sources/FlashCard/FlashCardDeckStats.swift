//
//  DeckStats.swift
//  FlashCard
//
//  Created by Tatiana Getling on 22/04/25.
//

import SwiftUI

public struct DeckStats: Equatable, Hashable {
    public let results: [FlashCardResult]
    public var correctCount: Int { results.filter { $0.wasCorrect }.count }
    public var incorrectCount: Int { results.filter { !$0.wasCorrect }.count }
    public var totalCards: Int { results.count }
    public var accuracy: Double {
        guard totalCards > 0 else { return 0 }
        return Double(correctCount) / Double(totalCards)
    }
}

extension DeckStats {
    public var incorrectCards: [FlashCard] {
        results.filter { !$0.wasCorrect }.map { $0.card }
    }
}
