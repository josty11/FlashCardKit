//
//  FlashCardStackView.swift
//  FlashCard
//
//  Created by Tatiana Getling on 21/04/25.
//

import SwiftUI

public struct FlashCardStackView: View {
    public let cards: [FlashCard]
    public var onDeckFinished: (() -> Void)? = nil
    var onSwipe: ((Bool) -> Void)? = nil
    @State private var isSwipedAway = false
    
    @State private var currentIndex = 0
    @State private var offset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State private var cardColor: Color = .white
    
    
    public init(cards: [FlashCard], onDeckFinished: (() -> Void)? = nil, currentIndex: Int = 0) {
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
            } else {
                Text("You're all done")
            }
        }
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-130):
            offset = CGSize(width: -500, height: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentIndex += 1
                if currentIndex == cards.count {
                    onDeckFinished?()
                }
                offset = .zero
                cardColor = .white
                isSwipedAway = false
            }
            
        case 130...500:
            offset = CGSize(width: 500, height: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentIndex += 1
                if currentIndex == cards.count {
                    onDeckFinished?()
                }
                offset = .zero
                cardColor = .white
                isSwipedAway = false
            }
        default:
            cardColor = .white
            offset = .zero
        }
    }
    
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-100):
            cardColor = .red
        case 100...500:
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
