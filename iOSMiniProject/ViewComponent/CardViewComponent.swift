//
//  CardViewComponent.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 03/12/24.
//

import UIKit

class CardViewComponent: UICollectionViewCell {
    static let identifier = "CardViewComponent"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryView = UIView()
    private let categoryLabel = UILabel()
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        titleLabel.font = .systemFont(ofSize: 10, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        categoryView.backgroundColor = .lightGray
        categoryView.layer.cornerRadius = 5
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(categoryView)

        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: 10)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: self.frame.width),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            
            categoryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            categoryView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            categoryView.widthAnchor.constraint(equalToConstant: 60),
            categoryView.heightAnchor.constraint(equalToConstant: 15),
            
            categoryLabel.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor)
        ])
    }
    
    public func configureView(menu: Menu) {
        setupView()
        titleLabel.text = "\(menu.strMeal)"
        categoryLabel.text = "\(menu.strArea)"
        
        if let imageUrlString = menu.strMealThumb, let imageUrl = URL(string: imageUrlString) {
            let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let error = error {
                    print("Error fetching image: \(error.localizedDescription)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
            task.resume()
        }
    }
}
