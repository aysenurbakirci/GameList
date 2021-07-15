//
//  HomeViewController.swift
//  GameListApp
//
//  Created by Ayşe Nur Bakırcı on 15.07.2021.
//

import UIKit

class HomeViewController: UIViewController {

    var gameList = [GameModel]()
    @IBOutlet weak var pageControlScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControlScrollView.delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlChange(_:)), for: .valueChanged)
        pageControlConfiguration()
        
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.frame = CGRect(x: 10, y: view.frame.size.height - 100, width: view.frame.size.width - 20 , height: 70)

        pageControlScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 0.5)
        
        if pageControlScrollView.subviews.count == 2 {
            scrollViewConfiguration()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let game = gameList[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameListCollectionViewCell", for: indexPath) as? GameListCollectionViewCell {
            
            cell.gameImage.image = UIImage(named: "customImage")
            cell.gameName.text = "Game Name"
            cell.gameInformation.text = "rating - released"
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width - 16.0 * 2
        let height: CGFloat = 130.0
        
        return CGSize(width: width, height: height)
    }
    
}
