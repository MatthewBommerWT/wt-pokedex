//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Matt Bommer on 2/24/21.
//

import UIKit
import AlamofireImage

class PokemonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    var mainType: PokemonType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
    }

    func configure(pokemon: Pokemon) {
        pokemonName.text = pokemon.name.capitalized
        pokemonName.textColor = .white
        pokemonName.sizeToFit()
        
        mainType = PokemonType.init(rawValue: pokemon.types[0].typeName)
        
        self.backgroundColor = mainType?.color
        
        guard let url = URL(string: pokemon.sprites.splash) else {
            return
        }
        let frame = CGSize(width: 100, height: 100)
        let placeHolderImage = UIImage(named: "placeholder")
        let filter = AspectScaledToFillSizeFilter(size: frame)
        pokemonImage.af.setImage(withURL: url, placeholderImage: placeHolderImage, filter: filter)
        }
    
    override func prepareForReuse() {
        pokemonImage.image = nil
        pokemonName.text = nil
        self.backgroundColor = .clear
    }
    
}
