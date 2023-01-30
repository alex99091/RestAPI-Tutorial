//
//  Button+Style.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/31.
//

import Foundation
import SwiftUI

struct MyDefaultBtnStyle: ButtonStyle {
    
    let bgColor: Color
    let textColor: Color
    
    init (bgColor: Color = Color.blue,
         textColor: Color = Color.white
    ){
        self.bgColor = bgColor
        self.textColor = textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .foregroundColor(textColor)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
            Spacer()
        }
        .padding()
        .background(bgColor.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
}
