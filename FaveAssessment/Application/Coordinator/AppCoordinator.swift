//
//  AppCoordinator.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import UIKit
import RxSwift

// MARK: - Class

class AppCoordinator: RxCoordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        
        let navigationController = UINavigationController(rootViewController: MoviesViewController.instantiate(fromAppStoryboard: .Main))
        
        let mainCoordinator = MoviesCoordinator(rootViewController: navigationController.viewControllers[0])
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return coordinate(to: mainCoordinator)
    }
}
