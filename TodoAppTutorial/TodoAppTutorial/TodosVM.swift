//
//  TodosVM.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/31.
//

import Foundation
import Combine
import RxSwift
import RxCocoa
import RxRelay


// ObserverbaleObject를 선언 하면 변경에 대한 감지가 가능
class TodosVM: ObservableObject {
    
    var disposeBag = DisposeBag()
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        print(#fileID, #function, #line, "- ")
        
        Task {
            
            let result : [Todo] = await TodosAPI.fetchTodosClosureToAsyncReturnArray(page: 1)
            print("result: \(result)")
        }
        
    }// init
    
    // - Parameter error: API에러처리
    fileprivate func handleError(_ error: Error) {
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
