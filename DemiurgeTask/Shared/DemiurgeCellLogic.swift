//
//  DemiurgeCellLogic.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 12.08.2024.
//

import Foundation


protocol DemiurgeCellLogic {
    func getCells() -> [DemiurgeCell]
    func addNewCell()
}

final class DemiurgeCellLogicImplementation: DemiurgeCellLogic {
    
    private var generator: DemiurgeCellTypeGenerator
    private var cells: [DemiurgeCell] = []
    private var lifeAddreses: [Int] = []
    
    init(generator: DemiurgeCellTypeGenerator = DemiurgeCellTypeGeneratorImplementation()) {
        self.generator = generator
    }
    
    func getCells() -> [DemiurgeCell] {
        return cells
    }
    
    func addNewCell() {
        let newCell = generator.generateCell()
        cells.append(newCell)
        let cellTypes = cells.map({ $0.type })
        let items = cellTypes.suffix(3)
        if items.count < 3 {
            return
        }
        let filtered = Set(items)
        if filtered.count > 1 {
            return
        }
        switch filtered.first! {
        case .alive:
            cells.append(DemiurgeCell.instatiateFor(type: .life))
            lifeAddreses.append(cells.count - 1)
            break
        case .dead:
            if let address = lifeAddreses.last {
                cells.remove(at: address)
                lifeAddreses.removeLast()
            }
        default:
            break
        }
    }
}
