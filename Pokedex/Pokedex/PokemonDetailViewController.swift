//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Matt Bommer on 2/26/21.
//

import UIKit
import AlamofireImage

private let reuseIdentifier = "StatusCollectionViewCell"

class PokemonDetailViewController: UIViewController {

    
    @IBOutlet weak var pokemonSplashImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    
    let spacing: CGFloat = 4.0
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
        configureCollectionView()
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
    
    private func configureCollectionView() {
        let nib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: PokemonCollectionViewCell.self))
        statusCollectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        statusCollectionView.isScrollEnabled = false
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        statusCollectionView.collectionViewLayout = layout
        statusCollectionView.delegate = self
        statusCollectionView.dataSource = self
    }
    
}
extension PokemonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.stats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StatusCollectionViewCell
        cell.configure(for: pokemon.stats[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let itemsPerCol: CGFloat = 3
        
        let totalSpacingHorizontal = (2 * self.spacing) + (itemsPerRow - 1) * self.spacing
        let totalSpacingVertical = (self.spacing) + (itemsPerRow - 1).rounded() * self.spacing
        
        return CGSize(width: (collectionView.frame.width - totalSpacingHorizontal) / itemsPerRow, height: (collectionView.frame.height - totalSpacingVertical) / itemsPerCol)
    }
    
    
}
    

