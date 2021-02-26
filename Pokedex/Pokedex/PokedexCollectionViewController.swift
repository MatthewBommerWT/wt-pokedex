//
//  PokedexCollectionViewController.swift
//  Pokedex
//
//  Created by Matt Bommer on 2/24/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class PokedexCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let client = APIClient()
    let baseURL = "https://pokeapi.co/api/v2/pokemon"
    let spacing: CGFloat = 8.0

    var nextURL: String?
    var resultsList: [NamedAPIResource] = []
    var pokemonList: [Pokemon] = []
    var requestInTransit: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let nib = UINib(nibName: "PokemonCollectionViewCell", bundle: Bundle(for: PokemonCollectionViewCell.self))
        collectionView.register(nib, forCellWithReuseIdentifier: "PokemonCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.'
        requestPokemonApiCalls()
    }
    
    func requestPokemonApiCalls() {
        requestInTransit = true
        var urlComponent = URLComponents(string: nextURL ?? baseURL) //Fix this in the future, the collection view will cycle through api forever
        if nextURL == nil {
            let queries = [URLQueryItem(name: "limit", value: "20"), URLQueryItem(name: "offset", value: "0")]
            urlComponent?.queryItems = queries
        }
        
        guard let url = urlComponent?.url else {
            return
        }
        
        let request = URLRequest(url: url)
        client.performDecodable(request: request) { (result: Result<NamedAPIResourceList, Error>) in
            DispatchQueue.main.async {
                self.requestInTransit = false
            }
            switch result {
            case .success(let collection):
                self.nextURL = collection.next
                let _ = collection.results.map { (apiResource) -> Void in
                    self.requestPokemonBy(url: apiResource.url)
                }
                self.resultsList = collection.results
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestPokemonBy(url: String) {
        let request = URLRequest(url: URL(string: url)!)
        client.performDecodable(request: request) { (result: Result<Pokemon, Error>) in
            switch result {
            case .success(let pokemon):
                print(pokemon.name)
                self.pokemonList.append(pokemon)
                DispatchQueue.main.async {
                    self.pokemonList.sort { $0.id < $1.id }
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pokemonList.count
    }

    //TODO figure out why this is broken
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell", for: indexPath) as! PokemonCollectionViewCell
        cell.configure(pokemon: pokemonList[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let itemsPerCol: CGFloat = 5
        
        let totalSpacingHorizontal = (2 * self.spacing) + (itemsPerRow - 1) * self.spacing
        let totalSpacingVertical = (self.spacing) + (itemsPerRow - 1).rounded() * self.spacing
        
        return CGSize(width: (collectionView.frame.width - totalSpacingHorizontal) / itemsPerRow, height: (collectionView.frame.height - totalSpacingVertical) / itemsPerCol)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == pokemonList.count - 1, !requestInTransit{
            requestPokemonApiCalls()
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}