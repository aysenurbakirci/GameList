//
//  HomeViewController.swift
//  GameListApp
//
//  Created by Ayşe Nur Bakırcı on 15.07.2021.
//

import UIKit
import Alamofire
import SDWebImage
import ObjectMapper

class HomeViewController: UIViewController {
    
    @IBOutlet weak var pageControlScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var gameList = [GameModel]()
    var filteredGameList = [GameModel]()
    
    var isSearchBarEmpty: Bool {
        let searchText = searchController.searchBar.text
        return searchText!.count >= 4 ? false : true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControlScrollView.delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlChange(_:)), for: .valueChanged)
        pageControlConfiguration()
        scrollViewConfiguration()
        searchControllerConfiguration()
        getGameList()
    }
    
    private func searchControllerConfiguration() {
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search Game"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func filterContextForSearchText(searchText: String) {
        filteredGameList = gameList.filter({ (game: GameModel) -> Bool in
            return (game.name?.lowercased().contains(searchText.lowercased()))!
        })
        
        collectionView.reloadData()
    }
    
    func getGameList() {
        
        let headers : HTTPHeaders = [
            "x-rapidapi-key": "c94aba3348mshcb6bec24ec775dcp1040d3jsnb1f15c31a317",
            "x-rapidapi-host": "rawg-video-games-database.p.rapidapi.com",
        ]
        
        spinner.startAnimating()
        spinner.isHidden = false
        
        AF.request("https://api.rawg.io/api/games?key=f487e6c36cb54e3a98b0c1bb8cc4a1a4", headers: headers).responseJSON { [self] response in
            
            switch response.result {
            
            case .success(let jsonData):
                if let response = jsonData as? Dictionary<String,Any> {
                    if let gameList = response["results"] as? [[String : Any]] {
                        for game in gameList {
                            let mappingGame = Mapper<GameModel>().map(JSON: game)
                            self.gameList.append(mappingGame!)
                            self.collectionView.reloadData()
                        }
                    } else {
                        print("Json mapping error")
                    }
                }else{
                    print("JSON parse error")
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
    
    @objc private func pageControlChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        pageControlScrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }

}

extension HomeViewController: UIScrollViewDelegate {
    
    private func pageControlConfiguration() {
        pageControl.numberOfPages = 3
        pageControl.backgroundColor = .clear
    }
    
    private func scrollViewConfiguration() {
        
        pageControlScrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: pageControlScrollView.frame.size.height)
        pageControlScrollView.isPagingEnabled = true
        pageControlScrollView.showsHorizontalScrollIndicator = false
        
        let colorList: [UIColor] = [.red, .green, .blue]
        
        for i in 0..<3 {
            let page = UIView(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: 0, width: view.frame.width, height: pageControlScrollView.frame.height))
            page.backgroundColor = colorList[i]
            pageControlScrollView.addSubview(page)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = gameList[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "GameDetailViewController") as! GameDetailViewController
        
        viewController.game = game
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            if filteredGameList.count == 0 {
                self.collectionView.setEmptyMessage("The game was not found.")
            } else {
                self.collectionView.restore()
            }
            return filteredGameList.count
        }
        self.collectionView.restore()
        return gameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let game: GameModel
        
        if isFiltering {
            game = filteredGameList[indexPath.row]
        } else {
            game = gameList[indexPath.row]
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameListCollectionViewCell", for: indexPath) as? GameListCollectionViewCell {
            
            cell.gameImage.sd_setImage(with: URL(string: game.image!), placeholderImage: UIImage(named: "customImage"))
            cell.gameName.text = game.name ?? "Game Name"
            cell.gameInformation.text = "\(game.rating ?? 0.0) - \(game.released ?? "00.00.00")"
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width - 16.0 * 2
        let height: CGFloat = 100.0
        
        return CGSize(width: width, height: height)
    }
    
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContextForSearchText(searchText: searchBar.text!)
    }
    
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
    
}

