//
//  GameDetailViewController.swift
//  GameListApp
//
//  Created by Ayşe Nur Bakırcı on 15.07.2021.
//

import UIKit
import ObjectMapper
import SDWebImage
import Alamofire
import CoreData

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var likeClickImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameRelease: UILabel!
    @IBOutlet weak var gameMetacritic: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    
    var game: GameModel? = nil
    var gameIsFavoruite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 414, height: 323), scaleMode: .fill)
        
        gameImage.sd_setImage(with: URL(string: (game?.image!)!), placeholderImage: UIImage(named: "customImage"),context: [.imageTransformer: transformer])
        gameName.text = game?.name ?? "Game Name"
        gameRelease.text = game?.released ?? "00.00.00"
        gameMetacritic.text = "\(game?.metacritc ?? 0.0)"
        
        gameDescription.numberOfLines = 0
        
        if gameIsFavoruite {
            imageButtonConfigurationDeleteFavourite()
        } else {
            imageButtonConfigurationAddFavourite()
        }
        
        getGameDescription(gameID: game?.id ?? 0)
    }
    
    func getGameDescription(gameID: Int) {
        
        let id : String = String(gameID)
        
        let headers : HTTPHeaders = [
            "x-rapidapi-key": "c94aba3348mshcb6bec24ec775dcp1040d3jsnb1f15c31a317",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com",
        ]
        
        spinner.startAnimating()
        spinner.isHidden = false
        
        AF.request("https://api.rawg.io/api/games/\(id)?key=f487e6c36cb54e3a98b0c1bb8cc4a1a4", headers: headers).responseJSON { [self] response in
            
            switch response.result {
            
            case .success(let jsonData):
                if let description = jsonData as? Dictionary<String, Any> {
                    self.gameDescription.text = description["description_raw"] as? String
                }
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
            }
        }
    }
}

extension GameDetailViewController {
    
    func imageButtonConfigurationAddFavourite() {
        
        likeClickImage.image = likeClickImage.image?.withRenderingMode(.alwaysTemplate)
        likeClickImage.tintColor = UIColor.white
        likeClickImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFavourite))
        likeClickImage.addGestureRecognizer(tapRecognizer)
        
    }
    
    func imageButtonConfigurationDeleteFavourite() {
        
        likeClickImage.image = likeClickImage.image?.withRenderingMode(.alwaysTemplate)
        likeClickImage.tintColor = UIColor.orange
        likeClickImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(removeFavourite))
        likeClickImage.addGestureRecognizer(tapRecognizer)
        
    }
    
    @objc func addFavourite() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let newGameID = NSEntityDescription.insertNewObject(forEntityName: "FavouriteGames", into: context)
        newGameID.setValue(game?.id!, forKey: "gameID")
        
        do {
            try context.save()
            likeClickImage.tintColor = UIColor.orange
            makeAlert(title: "Success", message: "Game is your favorites list now.")
        } catch {
            makeAlert(title: "Error", message: "The game could not be added to your favorites list.")
        }
    }
    
    @objc func removeFavourite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteGames")
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    guard let gameID = result.value(forKey: "gameID")as? Int else { return }
                    if game?.id! == gameID {
                        context.delete(result)
                    }
                }
                try context.save()
                likeClickImage.tintColor = UIColor.white
                makeAlert(title: "Success", message: "We're so sorry you don't like this game anymore.")
            }
        } catch {
            print("Error")
            makeAlert(title: "Error", message: "Game could not be removed from favorites.")
        }
    }
}

extension GameDetailViewController {
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
