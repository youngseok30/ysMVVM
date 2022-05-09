//
//  AppRouter.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/08.
//

import Foundation
import UIKit

let AppRoute = DI.container.resolve(AppRouterService.self)!

protocol AppRouterService {
    
    func changeRootVC(rootViewControllers: [UIViewController])
    func movieListVC() -> ViewController
    
}

class AppRouter: AppRouterService {
    
    func changeRootVC(rootViewControllers: [UIViewController]) {
        let navigationController = UINavigationController()
        navigationController.viewControllers = rootViewControllers
        
        UIApplication.shared.currentWindow?.rootViewController = navigationController
        UIApplication.shared.currentWindow?.makeKeyAndVisible()
    }
    
    func movieListVC() -> ViewController {
        return ViewController.instantiate(with: ViewModel())
    }
    
}
