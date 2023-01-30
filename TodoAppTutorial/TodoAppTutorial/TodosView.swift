//
//  TodosView.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/31.
//

import Foundation
import SwiftUI

struct TodosView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            getHeader()
            UISearchBarWrapper()
            Spacer()
            List {
                TodoRow()
                TodoRow()
                TodoRow()
                TodoRow()
            }.listStyle(.plain)
        }
    }
    fileprivate func getHeader() -> some View {
        Group {
            topHeader
            secondHeader
        }.padding(.horizontal, 10)
    }
    
    fileprivate var topHeader: some View {
        Group{
            Text("TodosView / page: 0")
            Text("선택될 할일: []")
            
            HStack {
                Button(action: { }, label: { Text("클로져").lineLimit(1).minimumScaleFactor(0.7) })
                    .buttonStyle(MyDefaultBtnStyle())
                Button(action: { }, label: { Text("Rx").lineLimit(1) })
                    .buttonStyle(MyDefaultBtnStyle())
                Button(action: { }, label: { Text("콤바인").lineLimit(1).minimumScaleFactor(0.7) })
                    .buttonStyle(MyDefaultBtnStyle())
                Button(action: { }, label: { Text("Async").lineLimit(1).minimumScaleFactor(0.7) })
                    .buttonStyle(MyDefaultBtnStyle())
            }
        }
    }
    fileprivate var secondHeader: some View {
        Group{
            Text("Async 변환 액션들")
            HStack {
                Button(action: { }, label: { Text("클로져 👉 Async").lineLimit(2).minimumScaleFactor(0.7) })
                    .buttonStyle(MyDefaultBtnStyle())
                Button(action: { }, label: { Text("Rx 👉 Async").lineLimit(2).minimumScaleFactor(0.7) })
                    .buttonStyle(MyDefaultBtnStyle())
                Button(action: { }, label: { Text("콤바인 👉 Async").lineLimit(2).minimumScaleFactor(0.7) })
                    .buttonStyle(MyDefaultBtnStyle())
            }
            HStack {
                Button(action: { }, label: { Text("초기화") })
                    .buttonStyle(MyDefaultBtnStyle(bgColor: .purple))
                Button(action: { }, label: { Text("선택될 할일들 삭제").lineLimit(2).minimumScaleFactor(0.7) })
                    .buttonStyle(MyDefaultBtnStyle(bgColor: .black))
                Button(action: { }, label: { Text("할일 추가") })
                    .buttonStyle(MyDefaultBtnStyle(bgColor: .gray))
            }
        }
    }
}

struct TodosView_Previews: PreviewProvider {
    
    static var previews: some View {
        TodosView()
    }
}
