//
//  FlashCardResult.swift
//  FlashCard
//
//  Created by Tatiana Getling on 22/04/25.
//

import SwiftUI

public struct FlashCardResult: Hashable {
    public let card: FlashCard
    public let wasCorrect: Bool
    public let timeSpent: TimeInterval

    public init(card: FlashCard, wasCorrect: Bool, timeSpent: TimeInterval) {
        self.card = card
        self.wasCorrect = wasCorrect
        self.timeSpent = timeSpent
    }
}
