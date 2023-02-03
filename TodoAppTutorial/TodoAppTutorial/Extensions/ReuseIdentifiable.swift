//
//  ReuseIdentifiable.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/02/03.
//

import Foundation
import UIKit

extension UITableViewCell : ReuseIdentifiable {}

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}


