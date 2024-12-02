//
//  ViewController.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 02/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    var menu: [Menu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        fetchData(from: "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken")
    }
    
    func displayDatas() {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(menu.count) * 200)
        view.addSubview(scrollView)
        
        for (index, menu) in menu.enumerated() {
            
            if let imageUrlString = menu.strMealThumb, let imageUrl = URL(string: imageUrlString) {
                let cardView = UIView()
                cardView.backgroundColor = .white
                cardView.layer.cornerRadius = 10
                cardView.frame = CGRect(x: 20, y: CGFloat(index) * 210, width: 150, height: 190)
                scrollView.addSubview(cardView)
                
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 10
                imageView.translatesAutoresizingMaskIntoConstraints = false
                cardView.addSubview(imageView)
                
                let titleLabel = UILabel()
                titleLabel.text = "\(menu.strMeal) - \(menu.strArea)"
                titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
                titleLabel.textAlignment = .left
                titleLabel.numberOfLines = 0
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                cardView.addSubview(titleLabel)
                
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
                    imageView.heightAnchor.constraint(equalToConstant: 150),
                    imageView.widthAnchor.constraint(equalToConstant: 150),
                    imageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
                    
                    titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
                    titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 2)
                ])
                
                
                let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let error = error {
                        print("Error fetching image: \(error.localizedDescription)")
                        return
                    }
                    if let data = data, let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    }
                }
                task.resume()
            }
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
                let meal = try JSONDecoder().decode(Meal.self, from: data)
                self.menu = meal.meals
                
                DispatchQueue.main.async {
                    self.displayDatas()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
}

