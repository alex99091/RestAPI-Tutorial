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
    
    /// <#Description#>
    init() {
        print(#fileID, #function, #line, "- "    )
        
        TodosAPI.fetchSelectedTodos(selectedTodoIds: [2250, 2251, 2245], completion: { result in
            switch result {
            case .success(let data):
                print("TodosVM - fetchSelectedTodos: data: \(data)")
            case .failure(let failure):
                print("TodosVM - fetchSelectedTodos: failure: \(failure)")
            }
        })
        
//        TodosAPI.deleteSelectedTodos(selectedTodoIds: [2251, 2249, 2247, 2246],
//                                     completion: { [weak self] deletedTodos in
//            print("TodosVM deletedTodos - deletedTodos: \(deletedTodos)")
//        })
        
//        TodosAPI.deleteATodo(id: 2252,
//                             completion: { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let aTodoResponse):
//                print("TodosVM deleteATodo - deleteATodo: \(aTodoResponse)")
//            case .failure(let failure):
//                print("TodosVM todolistResponse - failure: \(failure)")
//                self.handleError(error: failure)
//            }
//        })
        
        //        TodosAPI.addTodoAndFetchTodos(
        //                                    title: "할일추가하고전체보기 123",
        //                                    completion: { [weak self] result in
        //            guard let self = self else { return }
        //            switch result {
        //            case .success(let todolistResponse):
        //                print("TodosVM todolistResponse - aTodoResponse: \(todolistResponse.data?.count)")
        //            case .failure(let failure):
        //                print("TodosVM todolistResponse - failure: \(failure)")
        //                self.handleError(error: failure)
        //            }
        //        })
        
    }// init
    
    // - Parameter error: API에러처리
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
