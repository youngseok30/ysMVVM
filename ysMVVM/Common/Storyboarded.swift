//
//  Storyboarded.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/09.
//

import UIKit

protocol Storyboarded {
    static var storyboardName: String { get set }
    static var storyboardID: String { get set }
    static func instantiate() -> Self
    init?(coder: NSCoder)
}

extension Storyboarded where Self: UIViewController {

    static func instantiate() -> Self {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
            return storyboard.instantiateViewController(identifier: storyboardID) { (coder) -> Self? in
                return Self(coder: coder)
            }
        } else {
            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: storyboardID) as! Self
            return vc
        }
    }
}
