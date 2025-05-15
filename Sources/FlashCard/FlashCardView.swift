//
//  FlashCardView.swift
//  FlashCard
//
//  Created by Tatiana Getling on 21/04/25.
//

import SwiftUI

public struct FlashCardView: View {
    public let flashcard: FlashCard
    @State private var isFlipped = false
    @State private var offset: CGSize = .zero
    private var onSwiped: (() -> Void)?
    let color: Color
    
    public init(flashcard: FlashCard, cardColor: Color, onSwiped: (() -> Void)? = nil) {
        self.flashcard = flashcard
        self.onSwiped = onSwiped
        self.color = cardColor
    }
    
    public var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .shadow(color: .gray, radius: 4)
                .overlay {
                    Text(isFlipped ? flashcard.backText : flashcard.frontText)
                        .font(.title2)
                        .foregroundStyle(Color.black)
                        .padding()
                }
            
        }
        .frame(width: 320, height: 350)
        .onTapGesture {
            withAnimation(.spring()) {
                isFlipped.toggle()
            }
        }
    }
}

#Preview {
    FlashCardView(
        flashcard: FlashCard(
            frontText: "front",
            backText: "back"
        ),
        cardColor: .white,
        onSwiped: nil
    )
}
