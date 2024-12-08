//
//  ViewController.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 02/12/24.
//

import UIKit

class ViewController: UIViewController {
    private let vm = MenuViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray
        collectionView.register(CardViewComponent.self, forCellWithReuseIdentifier: CardViewComponent.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.setupTitleView()
        self.setupSearchController()
        self.vm.onMenusUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        self.vm.fetchData(from: "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken") { [weak self] in
            DispatchQueue.main.async {
                self?.displayDatas()
            }
            
        }
    }
    
    private func setupTitleView() {
        self.navigationItem.title = "Choose Your Menu"
    }
    
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func displayDatas() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return self.vm.menu.count
        let inSearchMode = self.vm.inSearchMode(searchController)
        return inSearchMode ? self.vm.filteredMenu.count : self.vm.menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardViewComponent.identifier, for: indexPath) as? CardViewComponent else {
            fatalError("Could not dequeue CardViewComponent")
        }
        
        let inSearchMode = self.vm.inSearchMode(searchController)
        //        let menu = self.vm.menu[indexPath.row]
        let menu = inSearchMode ? self.vm.filteredMenu[indexPath.row] : self.vm.menu[indexPath.row]
        cell.configureView(menu: menu)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (self.view.frame.width/2.3)
        let heightSize = (self.view.frame.height*0.3)
        return CGSize(width: widthSize, height: heightSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else { return }
        self.vm.updateSearchController(searchBarText: searchController.searchBar.text)
    }
}

