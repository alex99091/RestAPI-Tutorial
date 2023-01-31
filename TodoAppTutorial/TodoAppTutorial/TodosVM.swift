//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/31.
//

import Foundation
import Combine

// ObserverbaleObject를 선언해요 변경에 대한 감지가 가능
class TodosVM: ObservableObject {
    
    init() {
        print(#fileID, #function, #line, "- "    )
        TodosAPI.fetchTodos { result in
            switch result {
            case .success(let todosResponse):
                print("TodosVM - todosResponse: \(todosResponse)")
            case .failure(let failure):
                print("TodosVM - failure: \(failure)")
            }
            
        }
    }// init
    
}
