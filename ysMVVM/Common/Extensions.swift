//
//  Extensions.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/09.
//

import Foundation
import UIKit

extension Dictionary where Key == String, Value == Any {
    
    mutating func append(_ dic: [String: Any]) -> Dictionary {
        for (key, value) in dic {
            self.updateValue(value, forKey: key)
        }
        
        return self
    }
}

extension NSObject {
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
  
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
}


extension UIApplication {
    
    var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let sd = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate) {
                return sd.window
            }
        } else {
            return UIApplication.shared.delegate?.window ?? nil
        }
        
        return nil
    }
    
}

extension UICollectionViewCell {
    class var registerId: String { return String(describing: self) }
}

extension UICollectionViewLayout {

    static let grid = UICollectionViewCompositionalLayout { section, environment in
        let margin = 2.0
        let numberOfColumn = 2

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                     leading: margin,
                                                     bottom: margin,
                                                     trailing: margin)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: numberOfColumn)

        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}
