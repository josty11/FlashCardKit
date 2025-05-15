// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct FlashCard: Equatable, Hashable {
    public let frontText: String
    public let backText: String
    public let hintText: String?
    
    public init( frontText: String, backText: String, hintText: String? = nil) {
        self.frontText = frontText
        self.backText = backText
        self.hintText = hintText
    }
}
