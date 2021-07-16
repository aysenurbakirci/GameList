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

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameRelease: UILabel!
    @IBOutlet weak var gameMetacritic: UILabel!
    @IBOutlet weak var gameDescription: UILabel!
    
    var game: GameModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 414, height: 323), scaleMode: .fill)
        
        gameImage.sd_setImage(with: URL(string: (game?.image!)!), placeholderImage: UIImage(named: "customImage"),context: [.imageTransformer: transformer])
        gameName.text = game?.name ?? "Game Name"
        gameRelease.text = game?.released ?? "00.00.00"
        gameMetacritic.text = "\(game?.metacritc ?? 0.0)"
        
        gameDescription.numberOfLines = 0
        
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
    
    @IBAction func likeButtonClick(_ sender: Any) {
        
    }
}
