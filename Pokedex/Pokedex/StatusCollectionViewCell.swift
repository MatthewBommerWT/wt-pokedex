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
    var pokemonStat: PokeStat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .white
    }
    
    func configure(for viewModel: PokeStat) {
        statusTitle.text = viewModel.statName
        statusValue.text = String(viewModel.baseValue)
        pokemonStat = viewModel
        
        guard let pokeStat = pokemonStat, let stat = Status(rawValue: pokeStat.statName) else {
            return
        }
        let progressValue = calculateMaxStatusValue(for: stat, value: Float(pokeStat.baseValue))
        // DON'T EVER USE THIS IN ANY OF YOUR OTHER PROJECTS
        UIView.animate(withDuration: 0.0, animations: {
            self.statusProgress.layoutIfNeeded()
        }, completion: { finished in
            self.statusProgress.progress = progressValue
            
            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveLinear], animations: {
                self.statusProgress.layoutIfNeeded()
            })
        })
        
        
        statusProgress.trackTintColor = .clear
        statusProgress.backgroundColor = .lightGray
        
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

