//
//  DemiurgeCell.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 12.08.2024.
//

import Foundation
import UIKit

enum DemiurgeCellType {
    case dead
    
    case alive
    
    case life
}

struct DemiurgeCell: Hashable {
    
    let uuid = UUID()
    
    let name: String
    
    let description: String
    
    let emoji: String
    
    let type: DemiurgeCellType
    
    let color: UIColor?
    
    let secondaryColor: UIColor?
}

extension DemiurgeCell {
    static func instatiateFor(type: DemiurgeCellType) -> DemiurgeCell {
        switch type {
        case .alive:
            return DemiurgeCell(name: "Живая", description: "и шевелится!", emoji: "💥", type: type, color: .init(named: "AliveCellColor"), secondaryColor: .init(named: "AliveCellSecondaryColor"))
        case .dead:
            return DemiurgeCell(name: "Мертвая", description: "или прикидывается", emoji: "💀", type: type, color: .init(named: "DeadCellColor"), secondaryColor: .init(named: "DeadCellSecondaryColor"))
        case .life:
            return DemiurgeCell(name: "Жизнь", description: "Ку-ку!", emoji: "🐣", type: type, color: .init(named: "LifeCellColor"), secondaryColor: .init(named: "LifeCellSecondaryColor"))
        }
    }
}
