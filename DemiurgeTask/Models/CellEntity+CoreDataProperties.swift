//
//  CellEntity+CoreDataProperties.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 14.08.2024.
//
//

import Foundation
import CoreData


extension CellEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CellEntity> {
        return NSFetchRequest<CellEntity>(entityName: "CellEntity")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var type: Int16

}

extension CellEntity : Identifiable {

}
