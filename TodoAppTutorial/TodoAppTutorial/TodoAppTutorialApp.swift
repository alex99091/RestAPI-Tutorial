//
//  TodoAppTutorialApp.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/30.
//

import SwiftUI

@main
struct TodoAppTutorialApp: App {
    
    @State var selectedTab: Int = 1
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab){
                // SwiftUI View
                TodosView()
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("SwiftUI")
                    }
                    .tag(0)
                
                // UIKit을 SwiftUI로 가져오는 코드
                MainVC
                    .instantiate()
                    .getRepresentable()
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("UIKit")
                    }
                    .tag(1)
            }
        }
    }
}
