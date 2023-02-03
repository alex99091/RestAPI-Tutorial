//
//  Storyboarded.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/02/03.
//

import Foundation
import UIKit

extension UIViewController : StoryBoarded {}

protocol StoryBoarded {
    static func instantiate(_ storyboardName: String?) -> Self
}

extension StoryBoarded {
    
    static func instantiate(_ storyboardName: String? = nil) -> Self {
        
        let name = storyboardName ?? String(describing: self)
        
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! Self
    }
}
