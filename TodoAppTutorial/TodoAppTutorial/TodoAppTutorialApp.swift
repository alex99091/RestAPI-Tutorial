//
//  TodoAppTutorialApp.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/30.
//

import SwiftUI

@main
struct TodoAppTutorialApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
                // SwiftUI View
                ContentView()
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("SwiftUI")
                    }
                
                // UIKit을 SwiftUI로 가져오는 코드
                MainVC
                    .instantiate()
                    .getRepresentable()
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("UIKit")
                    }
            }
        }
    }
}
