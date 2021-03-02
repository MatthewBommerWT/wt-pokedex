//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Matt Bommer on 2/26/21.
//

import UIKit
import AlamofireImage

class PokemonDetailViewController: UIViewController {

    
    @IBOutlet weak var pokemonSplashImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var hpBar: UIProgressView!
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        navigationItem.title = pokemon.name.capitalized
        idLabel.text = pokemonIDStyler()
        heightLabel.text = "Height: \(pokemon.height)"
        weightLabel.text = "Weight: \(pokemon.weight)"
        
        let types = pokemon.types.map { $0.typeName }.joined(separator: ", ")
        typeLabel.text = "Type(s): \(types)"
        
        let abilities = pokemon.abilities.map { $0.name }.joined(separator: ", ")
        abilitiesLabel.text = "Abilities: \(abilities)"
        
        guard let url = URL(string: pokemon.sprites.splash) else {
            return
        }
        pokemonSplashImage.af.setImage(withURL: url)
    }
    
    private func pokemonIDStyler() -> String {
        let id = String(pokemon.id)
        var placeholderZeros = ""
        if id.count < 3 {
            for _ in 0..<(3 - id.count) {
                placeholderZeros += "0"
            }
        }
        return "#\(placeholderZeros)\(id)"
    }
}
    

