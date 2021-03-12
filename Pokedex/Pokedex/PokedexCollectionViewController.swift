//
//  PokedexCollectionViewController.swift
//  Pokedex
//
//  Created by Matt Bommer on 2/24/21.
//

import UIKit
import PinkyPromise

private let reuseIdentifier = "PokemonCollectionViewCell"

enum Section {
    case main
}

protocol PokemonDataTransfer {
    func fillPokemonListAndUpdateCollectionView(filteredPokeList: [Pokemon])
}

class PokedexCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PokemonDataTransfer {
    
    private let pokemon = PokemonPromise()
    private let archiver = Archiver()
    private let spacing: CGFloat = 8.0
    
    private lazy var dataSource = makeDataSource()
    var nextURL: String?
    var pokemonList: [Pokemon] = []
    var requestInTransit: Bool = false
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Pokemon>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        pokemon.inject(handler: self)
        pokemon.requestPromise()
    }
    
    func configureCollectionView() {
        let nib = UINib(nibName: reuseIdentifier, bundle: Bundle(for: PokemonCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: UICollectionViewDiffableDataSource
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, pokemon) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PokemonCollectionViewCell
            cell?.configure(pokemon: pokemon)
            return cell
        }
        return dataSource
    }
    
    // MARK: NSDiffableDataSourceSnapshot
    func applySnapshot(animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(pokemonList)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let itemsPerCol: CGFloat = 5
        
        let totalSpacingHorizontal = (2 * self.spacing) + (itemsPerRow - 1) * self.spacing
        let totalSpacingVertical = (self.spacing) + (itemsPerCol - 1).rounded() * self.spacing
        
        return CGSize(width: (collectionView.frame.width - totalSpacingHorizontal) / itemsPerRow, height: (collectionView.frame.height - totalSpacingVertical) / itemsPerCol)
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == pokemonList.count - 1, !requestInTransit {
            pokemon.requestPromise()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let bundle = Bundle(for: PokemonDetailViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let viewController = storyboard.instantiateViewController(identifier: "PokemonDetailViewController") as! PokemonDetailViewController
        guard let pokemon = dataSource.itemIdentifier(for: indexPath) else {
            return false
        }
        viewController.pokemon = pokemon
        navigationController?.pushViewController(viewController, animated: true)
        return true
    }
    
    //MARK: PokemonDataTransfer
    func fillPokemonListAndUpdateCollectionView(filteredPokeList: [Pokemon]) {
        pokemonList.append(contentsOf: filteredPokeList)
        applySnapshot(animated: true)
    }
}
