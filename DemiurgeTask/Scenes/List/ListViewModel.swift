//
//  ListViewModel.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 13.08.2024.
//

import Foundation
import Combine

final class ListViewModel {
    @Published private(set) var cells: [DemiurgeCell] = []
    private(set) var hasSavedValues = false
    
    private let cellGenerator: DemiurgeCellGenerator
    private let service: DemiurgeCellDataService
    
    private var bag = Set<AnyCancellable>()
    
    init(generator: DemiurgeCellGenerator = DemiurgeCellGeneratorImplementation(),
         service: DemiurgeCellDataService = .init()) {
        self.cellGenerator = generator
        self.service = service
        
        if service.savedEntities.count > 0 {
            hasSavedValues = true
        }
    }
    func bind(buttonPressed: AnyPublisher<Void, Never>, needToContinue: AnyPublisher<Bool, Never>) {
        buttonPressed.sink { [weak self] in
            self?.addNewCell()
        }.store(in: &bag)
        needToContinue.sink { [weak self] needToContinue in
            guard let self = self else { return }
            if needToContinue {
                for entity in self.service.savedEntities {
                    cells.append(.instatiateFor(type: .init(rawValue: entity.type) ?? .unknown))
                }
            } else {
                self.service.clear()
                hasSavedValues = false
            }
        }.store(in: &bag)
    }
    
    private func addNewCell() {
        let newCell = cellGenerator.generateCell()
        cells.append(newCell)
        service.add(cell: newCell)
        checkForLifeChanges()
    }
    
    private func checkForLifeChanges() {
        guard cells.count >= 3 else { return }
        
        let cellTypes = cells.map({ $0.type })
        let items = cellTypes.suffix(3)
        
        let filtered = Set(items)
        if filtered.count > 1 {
            return
        }
        
        switch filtered.first! {
        case .alive:
            let lifeCell = DemiurgeCell.instatiateFor(type: .life)
            cells.append(lifeCell)
            service.add(cell: lifeCell)
            break
        case .dead:
            let address = cells.lastIndex {
                $0.type == .life
            }
            if let address {
                let lifeCell = cells.remove(at: address)
                service.delete(cell: lifeCell)
            }
        default:
            break
        }
    }
}
