//
//  ViewController.swift
//  GameListApp
//
//  Created by Ayşe Nur Bakırcı on 15.07.2021.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var gameList = [GameModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let game1 = GameModel(id: 1, name: "GameName", image: "customImage", released: "released", rating: 0.0, metacritc: 0.0)
        let game2 = GameModel(id: 2, name: "GameName", image: "customImage", released: "released", rating: 0.0, metacritc: 0.0)
        let game3 = GameModel(id: 3, name: "GameName", image: "customImage", released: "released", rating: 0.0, metacritc: 0.0)
        let game4 = GameModel(id: 4, name: "GameName", image: "customImage", released: "released", rating: 0.0, metacritc: 0.0)
        let game5 = GameModel(id: 5, name: "GameName", image: "customImage", released: "released", rating: 0.0, metacritc: 0.0)
        let game6 = GameModel(id: 6, name: "GameName", image: "customImage", released: "released", rating: 0.0, metacritc: 0.0)
        let game7 = GameModel(id: 7, name: "GameName", image: "customImage", released: "released", rating: 0.0, metacritc: 0.0)
        let game8 = GameModel(id: 8, name: "GameName", image: "customImage", released: "released", rating: 0.0, metacritc: 0.0)
        
        gameList = [game1, game2, game3, game4, game5, game6, game7, game8]
        
    }
    
}

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "openGameInformation", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let game = gameList[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameListCollectionViewCell", for: indexPath) as? GameListCollectionViewCell {
            
            cell.gameImage.image = UIImage(named: game.image)
            cell.gameName.text = game.name
            cell.gameInformation.text = "\(game.rating) - \(game.released)"
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width - 16.0 * 2
        let height: CGFloat = 130.0
        
        return CGSize(width: width, height: height)
    }
    
}
