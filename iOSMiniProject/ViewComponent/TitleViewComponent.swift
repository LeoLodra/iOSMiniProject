//
//  TitleViewComponent.swift
//  iOSMiniProject
//
//  Created by Leonardo Marhan on 03/12/24.
//

import UIKit

class TitleViewComponent: UIView {
    private let titleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Choose Your Menu"
        titleLabel.font = .systemFont(ofSize: .init(28))
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

#Preview {
    TitleViewComponent()
}
