//
//  ScannerTests.swift
//  ScannerTests
//
//  Created by Dan Appel on 11/13/15.
//
//

import Quick
import Nimble
@testable import Scanner


class ScannerTests: QuickSpec {
    override func spec() {

        describe("Scanner.swift") {

            let helloWorld = "Hello, world!"

            it("initiates properly") {
                let scanner = Scanner(string: helloWorld)

                expect(scanner.location == 0).to(beTrue())
            }

            // more coming soon!
        }
    }
}
