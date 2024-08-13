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
    
    private var demiurgeCellLogic: DemiurgeCellLogic
    
    private var bag = Set<AnyCancellable>()
    
    init(demiurgeCellLogic: DemiurgeCellLogic) {
        self.demiurgeCellLogic = demiurgeCellLogic
    }
    func bind(buttonPressed: AnyPublisher<Void, Never>) {
        buttonPressed.sink { [weak self] in
            guard let self = self else { return }
            self.demiurgeCellLogic.addNewCell()
            self.cells = self.demiurgeCellLogic.getCells()
        }.store(in: &bag)
    }
}
