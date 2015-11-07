# Scanner.swift
A tiny library to help you navigate your strings.

# Installation
The preferred installation method is Carthage. Simply add

```
github "Danappelxx/Scanner.swift" "master"
```

to your Cartfile.

Alternatively, you can just drop the single `Scanner.swift` file into your project.

# Usage
## Step 1: Obtain a string

```swift
let string = "Hello, World! My name is Dan and I like Swift."
```

## Step 2: Create a Scanner

```swift
var scanner = Scanner(string: string)
```

## Step 3: ??

```swift
for _ in 1...string.characters.count {
    if !scanner.atDelimiter && scanner.atStartOfWord {
        print(scanner.currentWord)
    }

    scanner.advance()
}
```

## Step 4: Observe Results

```
Hello
World
My
name
is
Dan
and
I
like
Swift
```

# Contributing
If you think there's anything that could be done better, feel free to submit and issue and/or a pull request! I'm completely open to contributions.

# Author
[Dan Appel](https://dvappel.me), [Dan.appel00@gmail.com](mailto:dan.appel00@gmail.com). I'm also almost always on the [swift-lang](http://swift-lang.schwa.io) Slack.
