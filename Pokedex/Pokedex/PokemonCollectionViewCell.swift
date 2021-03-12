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
        self.backgroundView = buildBackgroundView()
        
        guard let url = URL(string: pokemon.sprites.thumbnail) else {
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
    
    private func buildBackgroundView() -> UIImageView {
        let backgroundImage = Image(named: "pokeballBackground")
        let backgroundImageView = UIImageView(frame: self.frame)
        
        let colorCover = UIView(frame: self.bounds)
        colorCover.backgroundColor = mainType?.color
        colorCover.layer.opacity = 0.95
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.addSubview(colorCover)
        
        return backgroundImageView
    }
}
