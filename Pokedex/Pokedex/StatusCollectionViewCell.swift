//
//  StatusCollectionViewCell.swift
//  Pokedex
//
//  Created by Matt Bommer on 3/4/21.
//

import UIKit

enum Status: String {
    case health = "hp"
    case attack
    case defense
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed
}

class StatusCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusValue: UILabel!
    @IBOutlet weak var statusProgress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = CGColor(red: 255, green: 255, blue: 255, alpha: 100)
        self.layer.borderWidth = 5.0
    }
    
    func configure(for viewModel: PokeStat) {
        statusTitle.text = viewModel.statName
        statusValue.text = String(viewModel.baseValue)
        
        guard let status = Status(rawValue: viewModel.statName) else {
            return
        }
        
        let progressValue = calculateMaxStatusValue(for: status, value: Float(viewModel.baseValue))
        statusProgress.setProgress(progressValue, animated: true)
    }

    private func calculateMaxStatusValue(for status: Status, value statusValue: Float) -> Float {
        switch status {
            case .health:
                return statusValue / 255
            case .attack:
                return statusValue / 255
            case .defense:
                return statusValue / 255
            case .specialAttack:
                return statusValue / 255
            case .specialDefense:
                return statusValue / 255
            case .speed:
                return statusValue / 255
        }
    }
}

