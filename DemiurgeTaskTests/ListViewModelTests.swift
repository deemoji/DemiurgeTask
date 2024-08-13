//
//  ListViewModelTests.swift
//  DemiurgeTaskTests
//
//  Created by Дмитрий Мартьянов on 13.08.2024.
//

import XCTest
import Combine
@testable import DemiurgeTask

final class ListViewModelTests: XCTestCase {

    var cellTypeGeneartor: TestableDemiurgeCellTypeGenerator!
    var logic: DemiurgeCellLogic!
    var sut: ListViewModel!
    var bag: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        cellTypeGeneartor = .init()
        logic = DemiurgeCellLogicImplementation(generator: cellTypeGeneartor)
        sut = ListViewModel(demiurgeCellLogic: logic)
        bag = []
    }

    override func tearDownWithError() throws {
        sut = nil
        logic = nil
        cellTypeGeneartor = nil
        bag = nil
    }

    func testViewModelResponce() throws {
        for _ in 0...2 {
            cellTypeGeneartor.cells.append(DemiurgeCell.instatiateFor(type: .alive))
        }
        let expectation = expectation(description: "Responce")
        let subject = PassthroughSubject<Void, Never>()
        var count = 0
        sut.bind(buttonPressed: subject.eraseToAnyPublisher())
        subject.send()
        subject.send()
        sut.$cells.sink { cells in
            print("Cells count:", cells.count)
            count = cells.count
            expectation.fulfill()
        }.store(in: &bag)

        waitForExpectations(timeout: 3)
        XCTAssertTrue(count == 2)
    }
}
