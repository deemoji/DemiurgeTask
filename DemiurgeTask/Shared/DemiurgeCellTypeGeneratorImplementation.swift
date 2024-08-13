//
//  DemiurgeCellGeneratorImplementation.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 13.08.2024.
//

import Foundation

final class DemiurgeCellTypeGeneratorImplementation: DemiurgeCellTypeGenerator {
    func generateCell() -> DemiurgeCell {
        return Int.random(in: 0...1) == 0 ? DemiurgeCell.instatiateFor(type: .dead) : DemiurgeCell.instatiateFor(type: .alive)
    }
}
