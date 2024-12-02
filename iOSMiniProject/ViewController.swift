//
//  ViewController.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 02/12/24.
//

import UIKit

struct MealResponse: Decodable {
    let meals: [Menu]
}

struct Menu: Decodable {
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumbs: String?
    let strTags: String?
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        fetchData(from: "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken")
    }
    
    func displayDatas(_ datas: [Menu]) {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(datas.count) * 120)
        view.addSubview(scrollView)

        for (index, menu) in datas.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = "\(menu.strMeal) - \(menu.strArea)"
            titleLabel.textAlignment = .left
            titleLabel.numberOfLines = 0
            titleLabel.frame = CGRect(x: 20, y: CGFloat(index) * 20, width: view.frame.width - 40, height: 20)
            scrollView.addSubview(titleLabel)
        }
    }

    
    func fetchData(from urlString: String) {
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
                let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                let menus = mealResponse.meals
                print("Fetched Menus: \(menus)")
                
                DispatchQueue.main.async {
                    self.displayDatas(menus)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}

