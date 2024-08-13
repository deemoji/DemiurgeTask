//
//  DemiurgeCellLogicTests.swift
//  DemiurgeCellLogicTests
//
//  Created by Дмитрий Мартьянов on 12.08.2024.
//

import XCTest
@testable import DemiurgeTask


final class DemiurgeCellLogicTests: XCTestCase {

    var generator: TestableDemiurgeCellTypeGenerator!
    var sut: DemiurgeCellLogicImplementation!
    
    override func setUpWithError() throws {
        generator = TestableDemiurgeCellTypeGenerator()
        sut = DemiurgeCellLogicImplementation(generator: generator)
    }

    override func tearDownWithError() throws {
        generator = nil
        sut = nil
    }
    func testAddingCells() throws {
        generator.cells = [DemiurgeCell.instatiateFor(type: .alive),
                           DemiurgeCell.instatiateFor(type: .dead),
                           DemiurgeCell.instatiateFor(type: .dead)]
        
        for _ in generator.cells {
            sut.addNewCell()
        }
        let cells = sut.getCells()
        let last = try XCTUnwrap(cells.last)
        XCTAssertEqual(last.type, .dead)
    }
    
    func testGenerateLife() throws {
        generator.cells = [DemiurgeCell.instatiateFor(type: .alive),
                           DemiurgeCell.instatiateFor(type: .alive),
                           DemiurgeCell.instatiateFor(type: .alive)]
        for _ in generator.cells {
            sut.addNewCell()
        }
        let cells = sut.getCells()
        let last = try XCTUnwrap(cells.last)
        XCTAssertEqual(last.type, .life)
    }
    
    func testKillLife() throws {
        generator.cells = [DemiurgeCell.instatiateFor(type: .alive),
                           DemiurgeCell.instatiateFor(type: .alive),
                           DemiurgeCell.instatiateFor(type: .alive),
                           DemiurgeCell.instatiateFor(type: .dead),
                           DemiurgeCell.instatiateFor(type: .dead),
                           DemiurgeCell.instatiateFor(type: .dead)]
        for _ in generator.cells {
            sut.addNewCell()
        }
        let cells = sut.getCells()
        for cell in cells {
            if cell.type == .life {
              XCTFail()
            }
        }
    }
    func testThreeDeadCells() throws {
        generator.cells = [DemiurgeCell.instatiateFor(type: .dead),
                           DemiurgeCell.instatiateFor(type: .dead),
                           DemiurgeCell.instatiateFor(type: .dead)]
        for _ in generator.cells {
            sut.addNewCell()
        }
        
    }
}
