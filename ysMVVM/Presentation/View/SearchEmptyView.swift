//
//  SearchEmptyView.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/16.
//

import Foundation
import UIKit

class SearchEmptyView: UIView {
    lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "검색창에서 키워드로\n영화 포스터를 검색해주세요."
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        setupViews()
        addSubviews()
        makeConstraints()
    }

    private func setupViews() {
        backgroundColor = .white
    }

    private func addSubviews() {
        addSubview(informationLabel)
    }

    private func makeConstraints() {
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            informationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            informationLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
