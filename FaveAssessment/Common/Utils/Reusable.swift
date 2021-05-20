//
//  Reusable.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 20/05/2021.
//

import UIKit

protocol NibProvidable {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension NibProvidable {
    static var nibName: String {
        return "\(self)"
    }
    static var nib: UINib {
        return UINib(nibName: self.nibName, bundle: nil)
    }
}

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

extension UITableViewCell: ReusableView, NibProvidable{}
