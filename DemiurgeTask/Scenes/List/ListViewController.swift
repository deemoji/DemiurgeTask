//
//  ListViewController.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 12.08.2024.
//

import UIKit
import Combine

final class ListViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, DemiurgeCell>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, DemiurgeCell>
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet weak var button: UIButton!
    
    private let gradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        let colorTop = UIColor(named: "ListColor")!.cgColor
        let colorBottom = UIColor.black.cgColor
        layer.colors = [colorTop, colorBottom]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    private var viewModel: ListViewModel = {
        let viewModel = ListViewModel()
        return viewModel
    }()
    
    private var dataSource: DataSource!
    
    private var buttonPublisher = PassthroughSubject<Void, Never>()
    private var loadCachePublisher = PassthroughSubject<Bool, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        buttonPublisher.send()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDataSource()
        bindViewModel()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: Bundle.main), forCellReuseIdentifier: TableViewCell.identifier)
        gradient.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        tableView.backgroundView = backgroundView
        tableView.delegate = self
    }
    private func setupDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
            cell.bind(item)
            return cell
        })
    }
    
    private func showInitialAlarm() {
        let alert = UIAlertController(title: "Найдены сохраненные  данные", message: "Вы можете продолжить или  начать сначала", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Продолжить", style: .default) {[weak self] _ in
            self?.loadCachePublisher.send(true)
        }
        let clearCacheAction = UIAlertAction(title: "Начать сначала", style: .destructive) {
            [weak self] _ in
            self?.loadCachePublisher.send(false)
        }
        alert.addAction(continueAction)
        alert.addAction(clearCacheAction)
        self.present(alert, animated: true)
        
    }
}
// MARK: - Setting up bindings
extension ListViewController {
    func bindViewModel() {
        if viewModel.hasSavedValues {
            showInitialAlarm()
        }
        
        viewModel.bind(buttonPressed: buttonPublisher.eraseToAnyPublisher(), needToContinue: loadCachePublisher.eraseToAnyPublisher())
        viewModel.$cells.sink { [weak self] cells in
            self?.update(cells)
        }.store(in: &bag)
    }
}

extension ListViewController {
    private func update(_ model: [DemiurgeCell]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(model)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

//  MARK: - TableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.rowHeight
    }
    
}

