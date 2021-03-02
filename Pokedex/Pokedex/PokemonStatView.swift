//
//  PokemonStatView.swift
//  Pokedex
//
//  Created by Matt Bommer on 3/2/21.
//

import UIKit

class PokemonStatView: UIView {

    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    var status: PokeStat?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureStatus(maxValue: Float) {
        guard let baseValue = status?.baseValue else {
            return
        }
        let floatBase = Float(baseValue)
        statLabel.text = "\(status?.statName) \(String(baseValue))"
        progressBar.setProgress(floatBase / maxValue, animated: true)
    }
}
