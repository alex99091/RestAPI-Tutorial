//
//  Nibbed.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/02/03.
//

import Foundation
import UIKit

extension UITableViewCell : Nibbed { }

protocol Nibbed {
    static var uinib: UINib { get }
}

extension Nibbed {
    static var uinib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}



