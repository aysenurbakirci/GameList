//
//  TabBarController.swift
//  GameListApp
//
//  Created by Ayşe Nur Bakırcı on 15.07.2021.
//

import UIKit
import CoreData

class TabBarController: UITabBarController {

    @IBOutlet weak var tabbar: UITabBar!
    var favoriteGameIdList : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabbarConfiguration()
        getFavouriteGames()
    }
    
    func getFavouriteGames() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteGames")
        
        do{
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    guard let gameID = result.value(forKey: "gameID") as? Int else {
                        return
                    }
                    favoriteGameIdList.append(gameID)
                }
            }
        } catch{
            print("Error")
        }
    }
    
    func isGameFavorite(game: GameModel) -> Bool{
        
        for gameID in favoriteGameIdList {
            if gameID == game.id {
                return true
            }
        }
        return false
    }
    
    private func tabbarConfiguration() {
        
        tabbar.barTintColor = .darkGray
        tabbar.tintColor = .white
        tabbar.unselectedItemTintColor = .lightGray
        
        tabbar.layer.cornerRadius = 10
        tabbar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabbar.layer.masksToBounds = true
        
    }

}
