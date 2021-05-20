//
//  UIViewController.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import UIKit

// MARK: - Extension

extension UIViewController {
    
    // MARK: - Property
    
    class var storyboardID: String {
        return "\(self)"
    }
    
    // MARK: - Function to initiate UIViewController with a StoryBoard
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    // MARK: - Enum for All storyboard in the App. Handle and initialize UIViewController in an easy way.
    
    enum AppStoryboard: String {
        case Main
        
        var instance: UIStoryboard {
            return UIStoryboard(name: rawValue, bundle: Bundle.main)
        }
        
        func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
            let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
            return instance.instantiateViewController(withIdentifier: storyboardID) as! T
        }
        
        func initialViewController() -> UIViewController? {
            return instance.instantiateInitialViewController()
        }
    }
}

