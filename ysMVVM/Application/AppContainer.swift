//
//  AppContainer.swift
//  ysMVVM
//
//  Created by Ethan Lee on 2022/05/08.
//

import Foundation
import Swinject
import SwinjectAutoregistration

typealias DI = AppContainer

struct AppContainer {
    static let container: Container = {
        let container = Container()
        container.registerServices()
        return container
    }()
}

extension Container {
    internal func registerServices() {
        autoregister(NetworkServiceInterface.self, initializer: NetworkService.init)
        autoregister(AppRouterService.self, initializer: AppRouter.init)
        autoregister(MovieListRepository.self, initializer: MovieListApiService.init)
    }
}
