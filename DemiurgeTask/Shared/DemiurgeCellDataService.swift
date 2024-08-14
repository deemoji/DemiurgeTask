//
//  DemiurgeCellDataService.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 14.08.2024.
//

import Foundation
import CoreData

final class DemiurgeCellDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "CellContainer"
    private let entityName: String = "CellEntity"
    
    private(set) var savedEntities: [CellEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getEntities()
        }
    }
    
    func add(cell: DemiurgeCell) {
        let entity = CellEntity(context: container.viewContext)
        entity.uuid = cell.uuid
        entity.type = cell.type.rawValue
        applyChanges()
    }
    func delete(cell: DemiurgeCell) {
        if let entity = savedEntities.first(where: {
            $0.uuid == cell.uuid
        }) {
            container.viewContext.delete(entity)
        }
        applyChanges()
    }
    
    func clear() {
        for entity in savedEntities {
            container.viewContext.delete(entity)
        }
        applyChanges()
    }
    private func applyChanges() {
        save()
        getEntities()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func getEntities() {
         let request = NSFetchRequest<CellEntity>(entityName: entityName)
         do {
             savedEntities = try container.viewContext.fetch(request)
         } catch let error {
             print("Error fetching Cell Entities. \(error)")
         }
     }
    
}
