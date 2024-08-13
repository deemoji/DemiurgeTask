//
//  Testable.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 13.08.2024.
//

import Foundation

final class TestableDemiurgeCellTypeGenerator: DemiurgeCellTypeGenerator {
    func generateCell() -> DemiurgeCell {
        let cell = cells[currentIdx]
        currentIdx = currentIdx + 1 == cells.count ? 0 : currentIdx + 1
        return cell
    }
    private var currentIdx = 0
    var cells: [DemiurgeCell] = []
}
