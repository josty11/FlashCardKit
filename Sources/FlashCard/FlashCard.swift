// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct FlashCard: Equatable, Hashable {
    public let frontText: String
    public let backText: String
    
    public init( frontText: String, backText: String) {
        self.frontText = frontText
        self.backText = backText
    }
}
