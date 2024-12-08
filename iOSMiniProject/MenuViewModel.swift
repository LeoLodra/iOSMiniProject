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
            self.onMenusUpdated?()
        }
    }
    
    private(set) var filteredMenu: [Menu] = []
    
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
                self.filteredMenu = meal.meals 
                
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

extension MenuViewModel {
    
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        guard let searchText = searchBarText?.lowercased(), !searchText.isEmpty else {
            // Only reset filteredMenu if it’s not already the full menu
            if filteredMenu != menu {
                filteredMenu = menu
                onMenusUpdated?()
            }
            return
        }

        // Filter menu based on the search text
        let newFilteredMenu = menu.filter { $0.strMeal.lowercased().contains(searchText) }
        if newFilteredMenu != filteredMenu {
            filteredMenu = newFilteredMenu
            onMenusUpdated?()
        }
    }


}
