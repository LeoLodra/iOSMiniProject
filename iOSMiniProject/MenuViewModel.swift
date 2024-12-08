//
//  MenuViewModel.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 03/12/24.
//

import UIKit

class MenuViewModel {
    public var menu: [Menu] = []
    
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
}
