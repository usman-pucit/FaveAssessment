//
//  CoordinatorProvider.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import UIKit

// MARK: - Protocol

/// Abstract functions
protocol CoordinatorProvider {
    var navigationController: UINavigationController { get set }
    func start()
}

