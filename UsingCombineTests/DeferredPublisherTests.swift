//
//  DeferredPublisherTests.swift
//  UsingCombineTests
//
//  Created by Joseph Heck on 8/11/19.
//  Copyright © 2019 SwiftUI-Notes. All rights reserved.
//

import XCTest
import Combine

class DeferredPublisherTests: XCTestCase {


    func testDeferredPublisher() {
        let expectation = XCTestExpectation(description: self.debugDescription)

        let deferredPublisher = Deferred {
            return Just("hello")
            }.eraseToAnyPublisher()

        let cancellable = deferredPublisher
            .sink(receiveCompletion: { completion in
                print(".sink() received the completion", String(describing: completion))
                switch completion {
                case .finished:
                    break
                case .failure(let anError):
                    XCTFail("No failure should be received from empty")
                    print("received error: ", anError)
                    break
                }
                expectation.fulfill()
            }, receiveValue: { valueReceived in
                XCTAssertEqual(valueReceived, "hello")
                print(".sink() data received \(valueReceived)")
            })

        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cancellable)

    }
}
