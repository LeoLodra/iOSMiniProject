//
//  DetailViewController.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 09/12/24.
//


import UIKit

class DetailViewController: UIViewController {
    var menuItem: Menu?
    
    private let imageView = UIImageView()
    
    private let categoryView = UIView()
    private let categoryLabel = UILabel()
    
    private let ingredientTitle = UILabel()
    private let ingredientLabel = UILabel()
    
    private let instructionTitle = UILabel()
    private let instructionLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray3
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setupImage()
        self.setupCategory()
        self.setupIngredients()
    }
    
    private func setupImage() {
        guard let menuItem = menuItem else { return }
        
        imageView.contentMode = .scaleAspectFill
        if let imageUrlString = menuItem.strMealThumb, let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupCategory() {
        guard let menuItem = menuItem else { return }
        
        categoryView.backgroundColor = .lightGray
        categoryView.layer.cornerRadius = 10
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryView)

        categoryLabel.text = menuItem.strArea
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 90),
            categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryView.widthAnchor.constraint(equalToConstant: 100),
            categoryView.heightAnchor.constraint(equalToConstant: 30),
            
            categoryLabel.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor)
        ])
    }
    
    private func setupIngredients() {
        
    }
}
