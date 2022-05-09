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

