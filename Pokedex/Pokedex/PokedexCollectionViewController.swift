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

class PokedexCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let client = APIClient()
    private let archiver = Archiver()
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
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
        requestPromise()
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
            requestPromise()
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
    
    // MARK: Promises
    func getRequest() -> URLRequest? {
        var urlComponent = URLComponents(string: nextURL ?? baseURL) //Fix this in the future, the collection view will cycle through api forever
        if nextURL == nil {
            let queries = [URLQueryItem(name: "limit", value: "20"), URLQueryItem(name: "offset", value: "0")]
            urlComponent?.queryItems = queries
        }
        
        guard let url = urlComponent?.url else {
            return nil
        }
        return URLRequest(url: url)
    }
    
    private func fetchPokemonPromise(for resource: NamedAPIResource) -> Promise<Pokemon?>{
        let request = URLRequest(url: URL(string: resource.url)!)
        return client.performPromise(request: request).recover { error -> Promise<Pokemon?> in
            return Promise(value: nil)
        }
    }
    
    private func zipPokemonPromise(resourceList: [NamedAPIResource]) -> Promise<[Pokemon?]> {
        return zipArray(resourceList.map({ resource -> Promise<Pokemon?> in
            fetchPokemonPromise(for: resource)
        }))
    }
    
    func requestPromise() {
        guard let request = getRequest() else {
            return
        }
        
        let pokePromise: Promise<[Pokemon?]> = client.performPromise(request: request)
            .flatMap { (apiResourceList: NamedAPIResourceList) in
                self.nextURL = apiResourceList.next
                return self.zipPokemonPromise(resourceList: apiResourceList.results)
            }.onResult { (result: Result<[Pokemon?], Error>) in
                switch result {
                case .success(let listOfPokemon):
                    self.pokemonList.append(contentsOf: listOfPokemon.compactMap { $0 })
                    self.applySnapshot()
                case .failure(let error):
                    print(error)
                }
            }
        
        pokePromise.call()
    }
}
