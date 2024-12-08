//
//  MenuViewModel.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 03/12/24.
//

import UIKit

class MenuViewModel {
    var onMenusUpdated: (() -> Void)?
    
    private(set) var menu: [Menu] = [] {
        didSet {
            applyFiltersAndSearch()
        }
    }
    
    private(set) var filteredMenu: [Menu] = []
    
    private var activeFilters: [String] = []
    private var searchText: String = ""
    
    func fetchData(from urlString: String, completion: @escaping () -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let meal = try JSONDecoder().decode(Meal.self, from: data)
                self.menu = meal.meals
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func updateFilters(_ filters: [String]) {
        activeFilters = filters
        applyFiltersAndSearch()
    }

    func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""

        return isActive && !searchText.isEmpty
    }

    func updateSearchController(searchBarText: String?) {
        searchText = searchBarText?.lowercased() ?? ""
        
        guard let searchText = searchBarText?.lowercased(), !searchText.isEmpty else {
            filteredMenu = activeFilters.isEmpty ? menu : filteredMenu
            onMenusUpdated?()
            return
        }

        let searchResult = menu.filter { $0.strMeal.lowercased().contains(searchText) }

        if activeFilters.isEmpty {
            filteredMenu = searchResult
        } else {
            filteredMenu = searchResult.filter { menu in
                activeFilters.contains { filter in
                    menu.strCategory.lowercased().contains(filter.lowercased())
                }
            }
        }
        applyFiltersAndSearch()
    }
    
    private func applyFiltersAndSearch() {
        var results = menu
        
        // Apply filters if active
        if !activeFilters.isEmpty {
            results = results.filter { menu in
                activeFilters.contains { filter in
                    menu.strArea.lowercased().contains(filter.lowercased())
                }
            }
        }
        
        // Apply search if active
        if !searchText.isEmpty {
            results = results.filter { $0.strMeal.lowercased().contains(searchText) }
        }
        
        filteredMenu = results
        onMenusUpdated?()
    }
}

