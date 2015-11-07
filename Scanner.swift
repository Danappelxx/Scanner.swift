//
//  scanner.swift
//  Scanner.swift
//
//  Created by Dan Appel on 11/6/15.
//
//

import Foundation

// MARK: - Delimiter
public enum WordDelimiter: String {
    case Space = " "
    case Comma = ","
    case Period = "."
    case BraceIn = "{"
    case BraceOut = "}"
    case BracketIn = "["
    case BracketOut = "]"
    case QuestionMark = "?"
    case ExclamationMark = "!"
}

// MARK: - Error
public struct ScannerError: ErrorType, CustomStringConvertible {
    public let code: Int
    public let description: String

    public static let WordDoesNotExist = ScannerError(code: 10, description: "The requested word does not exist.")
}

// MARK: - Scanner
public struct Scanner {

    public let string: String
    public private(set) var location: Int

    public init(string: String, atLocation location: Int = 0) {
        self.string = string
        self.location = location
    }

    // MARK: - Basic Movement
    public mutating func advance() {
        self.location++
    }

    public mutating func precede() {
        self.location--
    }

    // MARK: - Jumps
    public mutating func jumpToStartOfString() {
        location = 0
    }
    public mutating func jumpToEndOfString() {
        location = string.characters.count
    }
    public mutating func jumpToStartOfWord() {
        while !atStartOfString && !atDelimiter {
            precede()
        }

        if atDelimiter {
            advance()
        }
    }

    public mutating func jumpToEndOfWord() {
        while !atEndOfString && atDelimiter {
            advance()
        }

        if atDelimiter {
            precede()
        }
    }

    public mutating func jumpToStartOfPreviousWord() throws {
        jumpToStartOfWord()

        if atStartOfString {
            throw ScannerError.WordDoesNotExist
        }
        precede()
    }

    public mutating func jumpToStartOfNextWord() throws {
        jumpToEndOfWord()

        if atEndOfString {
            throw ScannerError.WordDoesNotExist
        }
        advance()
    }

    // MARK: - Information
    public var currentCharacter: String {
        return String(string[string.startIndex.advancedBy(location)])
    }

    public var currentWord: String {

        if atDelimiter {
            return currentCharacter // if is delimiter, word is delimiter
        }

        var scanner = Scanner(string: string, atLocation: location)

        scanner.jumpToStartOfWord()

        var word = ""
        // add character by character until hit delimiter
        while !scanner.atEndOfString && !scanner.atDelimiter {
            word += scanner.currentCharacter
            scanner.advance()
        }

        return word
    }

    public func nextWord() -> String? {

        var scanner = Scanner(string: string, atLocation: location)

        do {
            try scanner.jumpToStartOfNextWord()
        } catch {
            return nil
        }

        return scanner.currentWord
    }

    public func previousWord() -> String? {

        var scanner = Scanner(string: string, atLocation: location)

        do {
            try scanner.jumpToStartOfPreviousWord()
        } catch {
            return nil
        }

        return scanner.currentWord
    }


    // MARK: - Location
    public var atDelimiter: Bool {
        return WordDelimiter(rawValue: currentCharacter) != nil
    }

    public var atStartOfString: Bool {
        return location == 0
    }

    public var atEndOfString: Bool {
        return location == string.characters.count
    }

    public var atStartOfWord: Bool {
        var scanner = Scanner(string: string, atLocation: location)

        scanner.jumpToStartOfWord()

        return location == scanner.location
    }

    public var atEndOfWord: Bool {
        var scanner = Scanner(string: string, atLocation: location)

        scanner.jumpToEndOfWord()

        return location == scanner.location
    }
}
