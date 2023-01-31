//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/31.
//

import Foundation
import Combine

// ObserverbaleObject를 선언 하면 변경에 대한 감지가 가능
class TodosVM: ObservableObject {
    
    init() {
        print(#fileID, #function, #line, "- "    )
        TodosAPI.deleteATodo(id: 2248, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let aTodoResponse):
                print("TodosVM deleteATodo - aTodoResponse: \(aTodoResponse)")
            case .failure(let failure):
                print("TodosVM deleteATodo - failure: \(failure)")
                self.handleError(error: failure)
            }
        })
        
        
        //        TodosAPI.editTodo(id: 2250, title: "오늘도 빡코딩?- 0423", isDone: true, completion: { [weak self] result in
        //            guard let self = self else { return }
        //            switch result {
        //            case .success(let aTodoResponse):
        //                print("TodosVM addATodo - aTodoResponse: \(aTodoResponse)")
        //            case .failure(let failure):
        //                print("TodosVM addATodo - failure: \(failure)")
        //                self.handleError(error: failure)
        //            }
        //        })
        
        
        //        TodosAPI.searchTodos(searchTerm: "빡코딩") { [weak self] result in
        //            guard let self = self else { return }
        //
        //            switch result {
        //            case .success(let todosResponse):
        //                print("TodosVM - search todosResponse: \(todosResponse)")
        //            case .failure(let failure):
        //                print("TodosVM - failure: \(failure)")
        //                self.handleError(error: failure)
        //            }
        //        }
        
        //        TodosAPI.fetchATodo(id: 1500, completion: { [weak self] result in
        //            guard let self = self else { return }
        //            switch result {
        //            case .success(let aTodoResponse):
        //                print("TodosVM - aTodoResponse: \(aTodoResponse)")
        //            case .failure(let failure):
        //                print("TodosVM - failure: \(failure)")
        //                self.handleError(error: failure)
        //            }
        //        })
        
        //        TodosAPI.fetchTodos { [weak self] result in
        //            guard let self = self else { return }
        //
        //            switch result {
        //            case .success(let todosResponse):
        //                print("TodosVM - todosResponse: \(todosResponse)")
        //            case .failure(let failure):
        //                print("TodosVM - failure: \(failure)")
        //                self.handleError(error: failure)
        //            }
        //        }
    }// init
    
    // - Parameter error: API에러
    fileprivate func handleError(error: Error) {
        if error is TodosAPI.ApiError {
            let apiError = error as! TodosAPI.ApiError
            print("handleError: error = \(apiError.info)")
            switch apiError {
            case .noContent:
                print("컨텐츠가 없습니다.")
            case .unAuthorized:
                print("인증되지 않았습니다.")
            default:
                print("default")
            }
        }
    }// handleError
    
}
