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
    
    
    @State private var showHint: Bool = false

    
    public init(cards: [FlashCard], onDeckFinished: ((DeckStats) -> Void)? = nil, currentIndex: Int = 0) {
        self.cards = cards
        self.onDeckFinished = onDeckFinished
        self.currentIndex = currentIndex
    }
    
    public var body: some View {
            VStack(spacing: 16) {
                VStack(alignment: .center) {
                    HStack {
                        ForEach(0..<cards.count, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 5)
                                .foregroundColor(
                                    index < currentIndex ? Color(
                                        "accentYellowF6CA83",
                                        bundle: .module
                                    ) : Color("lightGreyD9D9D9", bundle: .module)
                                )
                        }
                    }
                    .padding(.top, 16)
                    
                    HStack {
                        Button {
                            print("more tapped")
                        } label: {
                            Image("more", bundle: .module)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color("darkGrey4E4E4E", bundle: .module))
                        }
                        Spacer()
                        Button {
                            print("queue tapped")
                        } label: {
                            Image("queue", bundle: .module)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(Color("darkGrey4E4E4E", bundle: .module))

                        }
                    }.padding(.top, 16)
                }
                .padding(.horizontal, 40)
                
                Spacer()

                // Flashcard View
                if currentIndex < cards.count {
                    FlashCardView(flashcard: cards[currentIndex], cardColor: cardColor)
                        .offset(x: offset.width, y: offset.height * 0.2)
                        .rotationEffect(.degrees(Double(offset.width / 40)))
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, _ in
                                    state = value.translation
                                }
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
                        .onAppear {
                            showHint = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showHint = true
                            }
                        }
                }

                // Hint Button
                if showHint,
                    currentIndex < cards.count
                    //,let hintText = cards[currentIndex].hintText
                {
                    Button(action: {
                        // Display hint in your preferred way
                    }) {
                        Text("Need a hint? 💡")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }

                Spacer()

                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            offset = CGSize(width: -300, height: 0)
                            changeColor(width: offset.width)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            swipeCard(width: offset.width)
                            offset = .zero
                            changeColor(width: offset.width)
                            isSwipedAway = true
                        }
                    }) {
                        VStack {
                            Image("wrong", bundle: .module)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.red)
                            Text("Wrong")
                                .foregroundColor(.red)
                        }
                    }
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            offset = CGSize(width: 300, height: 0)
                            changeColor(width: offset.width)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            swipeCard(width: offset.width)
                            offset = .zero
                            changeColor(width: offset.width)
                            isSwipedAway = true
                        }
                    }) {
                        VStack {
                            Image("correct", bundle: .module)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
                            Text("Right")
                                .foregroundColor(.green)
                        }
                    }
                }.padding(.horizontal, 80)

                Spacer()
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
