//
//  scanner.swift
//  Scanner.swift
//
//  Created by Dan Appel on 11/6/15.
//
//

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

extension String {
    var isDelimiter: Bool {
        return WordDelimiter(rawValue: self) != nil
    }
}

// MARK: - Error
public struct ScannerError: ErrorType, CustomStringConvertible {
    public let code: Int
    public let description: String

    public static let WordDoesNotExist = ScannerError(code: 10, description: "The requested word does not exist.")
    public static let PastBounds = ScannerError(code: 20, description: "Attempting to move outside of the bounds.")
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
    public mutating func advance() throws {
        try advanceBy(1)
    }

    public mutating func advanceBy(x: Int) throws {
        var i = x
        while i-- > 0 {
            if location == string.characters.count-1 {
                throw ScannerError.PastBounds
            }
            location++
        }
    }

    public mutating func precede() throws {
        try precedeBy(1)
    }

    public mutating func precedeBy(x: Int) throws {
        var i = x
        while i-- > 0 {
            if location == 0 {
                throw ScannerError.PastBounds
            }
            location--
        }
    }

    public mutating func advanceUntil(stopper: Scanner -> Bool) throws {
        while !stopper(self) {
            try advance()
        }
    }

    public mutating func precedeUntil(stopper: Scanner -> Bool) throws {
        while !stopper(self) {
            try precede()
        }
    }


    // MARK: - Jumps
    public mutating func jumpToStartOfString() {
        location = 0
    }
    public mutating func jumpToEndOfString() {
        location = string.characters.count - 1
    }
    public mutating func jumpToStartOfWord() throws {
        try precedeUntil { $0.atStartOfWord }
    }

    public mutating func jumpToEndOfWord() throws {
        try advanceUntil { $0.atEndOfWord }
    }

    public mutating func jumpToStartOfPreviousWord() throws {
        try jumpToStartOfWord()

        if atStartOfString {
            throw ScannerError.WordDoesNotExist
        }

        try precedeUntil { !$0.atDelimiter }
    }

    public mutating func jumpToStartOfNextWord() throws {
        try jumpToEndOfWord()

        if atEndOfString {
            throw ScannerError.WordDoesNotExist
        }

        try advanceUntil { !$0.atDelimiter }
    }

    // MARK: - Information
    public var currentCharacter: String {
        return String(string[string.startIndex.advancedBy(location)])
    }
    
    public var previousCharacter: String? {
        if atStartOfString {
            return nil
        } else {
            return String(string[string.startIndex.advancedBy(location - 1)])
        }
    }

    public var nextCharacter: String? {
        if atEndOfString {
            return nil
        } else {
            return String(string[string.startIndex.advancedBy(location + 1)])
        }
    }
    
    public func currentWord() throws -> String {

        if atDelimiter {
            return currentCharacter // if is delimiter, word is delimiter
        }

        var scanner = Scanner(string: string, atLocation: location)

        try scanner.jumpToStartOfWord()

        var word = ""
        // add character by character until hit delimiter
        while !scanner.atEndOfString && !scanner.atDelimiter {
            word += scanner.currentCharacter
            try scanner.advance()
        }

        return word
    }
    
    public func nextWord() throws -> String {

        var scanner = Scanner(string: string, atLocation: location)

        try scanner.jumpToStartOfNextWord()

        return try scanner.currentWord()
    }

    public func previousWord() throws -> String {

        var scanner = Scanner(string: string, atLocation: location)

        try scanner.jumpToStartOfPreviousWord()

        return try scanner.currentWord()
    }

    public func relativeRange(from from: Int, to: Int) throws -> String {

        if location - from < 0 {
            throw ScannerError.PastBounds
        }

        var scanner = Scanner(string: string, atLocation: location - from)

        if from + to > scanner.charactersLeft {
            throw ScannerError.PastBounds
        }

        var chars = ""
        var i = from + to
        while i-- > 0 {
            try scanner.advance()
            chars += scanner.currentCharacter
        }

        return chars
    }

    public func nextXCharacters(x: Int) throws -> String {

        var scanner = Scanner(string: string, atLocation: location)

        var i = x
        var chars = ""
        while i-- > 0 {

            if scanner.atEndOfString {
                break
            }

            try scanner.advance()
            chars += scanner.currentCharacter
        }

        return chars
    }


    public var charactersLeft: Int {
        return (string.characters.count - 1) - location
    }

    // MARK: - Location
    public var atDelimiter: Bool {
        return currentCharacter.isDelimiter
    }

    public var atStartOfString: Bool {
        return location == 0
    }

    public var atEndOfString: Bool {
        return location+1 == string.characters.count
    }

    public var atStartOfWord: Bool {

        guard !atEndOfString else { return false }
        guard !atDelimiter else { return false}
        guard let nextCharacter = nextCharacter else { return false }
        guard !nextCharacter.isDelimiter else { return false }

        if let previousIsDelimiter = previousCharacter?.isDelimiter {
            if !previousIsDelimiter {
                return false
            }
        }

        return true
    }

    public var atEndOfWord: Bool {

        guard !atStartOfString else { return false }
        guard !atDelimiter else { return false }
        guard let previousCharacter = previousCharacter else { return false }
        guard !previousCharacter.isDelimiter else { return false }

        if let nextIsDelimiter = nextCharacter?.isDelimiter {
            if !nextIsDelimiter {
                return false
            }
        }

        return true
    }
}
