//
//  CollectionViewCell.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/15.
//

import Foundation
import UIKit

class CollectionViewCell: BaseCollectionViewCell<Photo> {
    
    private let placeholderImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override func setupView() {
        contentView.addSubview(placeholderImageView)
        contentView.addSubview(photoImageView)
    }
    
    override func setupConstraints() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    override func bind(to model: Photo?) {
        guard let model = model else { return }

        self.photoImageView.image = model.image
    }
    
}
