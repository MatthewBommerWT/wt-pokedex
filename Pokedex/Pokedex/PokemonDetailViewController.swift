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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        nameLabel.text = pokemon.name.capitalized
        heightLabel.text = "Height: \(pokemon.height)"
        weightLabel.text = "Weight: \(pokemon.weight)"
        
        let types = pokemon.types.map { $0.typeName }.joined(separator: ", ")
        typeLabel.text = "Type(s): \(types)"
        
        guard let url = URL(string: pokemon.sprites.splash) else {
            return
        }
        
        let frame = CGSize(width: 200, height: 200)
        let placeHolderImage = UIImage(named: "placeholder")
        let filter = AspectScaledToFillSizeFilter(size: frame)
        pokemonSplashImage.af.setImage(withURL: url, placeholderImage: placeHolderImage, filter: filter)
    }
}
    

