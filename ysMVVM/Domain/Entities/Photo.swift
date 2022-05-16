//
//  Photo.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/16.
//

import Foundation
import UIKit

class Photo: Item {
    var image: UIImage
    var imageUrl: URL
    var identifier = UUID()

    init(image: UIImage, imageUrl: URL) {
        self.image = image
        self.imageUrl = imageUrl
    }
}

extension Photo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
