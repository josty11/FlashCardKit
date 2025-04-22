// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct FlashCard: Identifiable, Equatable, Hashable {
    public let id: UUID
    public let frontText: String
    public let backText: String
    
    public init(id: UUID = UUID(), frontText: String, backText: String) {
        self.id = id
        self.frontText = frontText
        self.backText = backText
    }
}
