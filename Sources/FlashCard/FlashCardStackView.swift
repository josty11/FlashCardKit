//
//  FlashCardStackView.swift
//  FlashCard
//
//  Created by Tatiana Getling on 21/04/25.
//

import SwiftUI

public struct FlashCardStackView: View {
    public let cards: [FlashCard]
    public var onDeckFinished: ((DeckStats) -> Void)? = nil
    var onSwipe: ((Bool) -> Void)? = nil
    @State private var isSwipedAway = false
    
    @State private var currentIndex = 0
    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var cardColor: Color = .white
    
    @State private var correctCount: Int = 0
    @State private var incorrectCount: Int = 0
    @State private var cardStartTime: Date = Date()
    @State private var results: [FlashCardResult] = []
    
    public init(cards: [FlashCard], onDeckFinished: ((DeckStats) -> Void)? = nil, currentIndex: Int = 0) {
        self.cards = cards
        self.onDeckFinished = onDeckFinished
        self.currentIndex = currentIndex
    }
    
    public var body: some View {
        VStack {
            if currentIndex < cards.count {
                FlashCardView(flashcard: cards[currentIndex], cardColor: cardColor)
                    .offset(x: offset.width, y: offset.height * 0.2)
                    .rotationEffect(.degrees(Double(offset.width / 40)))
                    .gesture(
                        DragGesture()
                            .updating($dragOffset, body: { value, state, _ in
                                state = value.translation
                            })
                            .onChanged { gesture in
                                offset = gesture.translation
                                withAnimation {
                                    changeColor(width: offset.width)
                                }
                            }
                        
                            .onEnded { _ in
                                withAnimation {
                                    swipeCard(width: offset.width)
                                    changeColor(width: offset.width)
                                    isSwipedAway = true
                                }
                            }
                    )
                    .padding(.horizontal, 24)
            }
        }
    }
    
    func swipeCard(width: CGFloat) {
        let currentCard = cards[currentIndex]
        let timeSpent = Date().timeIntervalSince(cardStartTime)
        let wasCorrect: Bool
        
        switch width {
        //Incorrect
        case -500...(-130):
            offset = CGSize(width: -500, height: 0)
            wasCorrect = false
            
        //Correct
        case 130...500:
            offset = CGSize(width: 500, height: 0)
            wasCorrect = true
            
        default:
            cardColor = .white
            offset = .zero
            return
        }
        let result = FlashCardResult(card: currentCard, wasCorrect: wasCorrect, timeSpent: timeSpent)
        results.append(result)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               currentIndex += 1
               cardStartTime = Date()
               offset = .zero
               cardColor = .white
               isSwipedAway = false

               if currentIndex == cards.count {
                   onDeckFinished?(DeckStats(results: results))
               }
           }
        
    }
    
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-50):
            cardColor = .red
        case 50...500:
            cardColor = .green
        default:
            cardColor = .white
        }
    }
}

#Preview {
    FlashCardStackView(
        cards: [
            FlashCard(frontText: "front1", backText: "back"),
            FlashCard(frontText: "front2", backText: "back"),
            FlashCard(frontText: "front3", backText: "back"),
            FlashCard(frontText: "front4", backText: "back"),
            FlashCard(frontText: "front5", backText: "back"),
            FlashCard(frontText: "front6", backText: "back"),
            FlashCard(frontText: "front7", backText: "back"),
            FlashCard(frontText: "front8", backText: "back")
        ]
    )
}

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

extension DeckStats {
    public var incorrectCards: [FlashCard] {
        results.filter { !$0.wasCorrect }.map { $0.card }
    }
}
