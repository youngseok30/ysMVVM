//
//  ViewController.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/08.
//

import UIKit
import RxSwift

class ViewController: UIViewController, BaseMVVMView, Storyboarded {
    static var storyboardName: String = Constants.Storyboard.main
    static var storyboardID: String = ViewController.className
        
    lazy var disposeBag : DisposeBag = {
        return DisposeBag()
    }()
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }
    
    func bind(to viewModel: ViewModel) {
        viewModel.items.asDriver(onErrorJustReturn: nil)
            .drive(onNext: {[weak self] value in
                self?.update()
            }).disposed(by: disposeBag)
    }

    func update() {
    }

}

