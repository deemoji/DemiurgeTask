//
//  TableViewCell.swift
//  DemiurgeTask
//
//  Created by Дмитрий Мартьянов on 13.08.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    
    @IBOutlet private weak var stackView: UIStackView!
    
    @IBOutlet private weak var emojiLabel: UILabel!
    
    @IBOutlet private weak var stateLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var emojiBackgroundView: UIView!
    
    private var gradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    private func setupViews() {
        emojiBackgroundView.layer.masksToBounds = true
        emojiBackgroundView.layer.insertSublayer(gradient, at: 0)
        stackView.layer.masksToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        emojiBackgroundView.layer.cornerRadius = emojiBackgroundView.frame.width / 2
        gradient.frame = emojiBackgroundView.bounds
        stackView.layer.cornerRadius = 5
    }
}

extension TableViewCell {
    func bind(_  model: DemiurgeCell) {
        emojiLabel.text = model.emoji
        stateLabel.text = model.name
        descriptionLabel.text = model.description
        gradient.colors = [model.color?.cgColor, model.secondaryColor?.cgColor]
    }
}
