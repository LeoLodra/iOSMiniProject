//
//  HomeViewController.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 02/12/24.
//

import UIKit

//MARK: Define scope (public, private, internal(default))
//MARK: Jangan lupa pake final kl intendednya tidak inheritance / extension
public class HomeViewController: UIViewController {
    private let vm = MenuViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var selectedFilters: [String] = [] // Tracks selected categories
    
    //MARK: penggunaan lazy (dijalanin saat dipanggil doang)
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray3
        collectionView.register(CardViewComponent.self, forCellWithReuseIdentifier: CardViewComponent.identifier)
        return collectionView
    }()
    
    private let filterScrollView = FilterScrollView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.setupTitleView()
        self.setupSearchController()
        self.setupFilterButtons()
        
        //MARK: Klbs pke delegate pattern
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
        self.searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupFilterButtons() {
        view.addSubview(filterScrollView)
        filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let categories = ["Indian", "Chinese", "Japanese", "French", "Moroccan", "American", "Jamaican", "British", "Portugues", "Mexican", "Polish", "Greek"]
        filterScrollView.configureButtons(categories: categories, target: self, action: #selector(filterButtonTapped(_:)))
        
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterScrollView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    //MARK: @objc untuk expose swift ke objc
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let category = sender.title(for: .normal) else { return }
        
        if selectedFilters.contains(category) {
            // Deselect filter
            selectedFilters.removeAll { $0 == category }
            sender.backgroundColor = .lightGray
        } else {
            // Select filter
            selectedFilters.append(category)
            sender.backgroundColor = .white
        }
        
        self.vm.updateFilters(selectedFilters)
    }
    
    private func displayDatas() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.filteredMenu.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardViewComponent.identifier, for: indexPath) as? CardViewComponent else {
            fatalError("Could not dequeue CardViewComponent")
        }
        
        let menu = self.vm.filteredMenu[indexPath.row]
        cell.configureView(menu: menu)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMenu = self.vm.filteredMenu[indexPath.row]
        
        self.navigationItem.backButtonTitle = selectedMenu.strMeal
        
        let detailVC = DetailViewController()
        detailVC.menuItem = selectedMenu
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = (self.view.frame.width/2.3) //MARK: Hindari magic numbers
        let heightSize = (self.view.frame.height*0.25)
        return CGSize(width: widthSize, height: heightSize)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else { return }
        self.vm.updateSearchController(searchBarText: searchController.searchBar.text)
    }
}

extension HomeViewController: UISearchBarDelegate {
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.vm.updateSearchController(searchBarText: "")
    }
}
