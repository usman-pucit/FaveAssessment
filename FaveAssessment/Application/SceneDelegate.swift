//
//  SceneDelegate.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private let disposeBag = DisposeBag()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = window else {
            fatalError("Application failed to launch!!")
        }
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        .subscribe()
        .disposed(by: disposeBag)
    }
}

