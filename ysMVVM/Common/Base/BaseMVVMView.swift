//
//  BaseMVVMView.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/09.
//

import Foundation
import UIKit

protocol BaseMVVMView {
    
    associatedtype ViewModel: BaseVM
    var viewModel: ViewModel! { get set }
    func bind(to viewModel: ViewModel)
}

extension BaseMVVMView where Self: UIViewController, Self: Storyboarded {
    
    static func instantiate(with viewModel: ViewModel) -> Self {
        
        var viewController = Self.instantiate()
        viewController.viewModel = viewModel
        
        return viewController
    }
}
