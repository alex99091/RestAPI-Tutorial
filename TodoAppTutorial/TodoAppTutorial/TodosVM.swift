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
        
        TodosAPI.fetchTodosWithPublisher()
        .sink(receiveCompletion: { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .failure(let failure):
                self.handleError(error: failure)
            case .finished:
                print("TodosVM - finished")
            }
        }, receiveValue: { response in
            print("TodosVM - response: \(response)")
        })
        .store(in: &subscriptions)
        
//        TodosAPI.deleteSelectedTodosWithObservableMerge(selectedTodoIds: [2267, 2266])
//            .subscribe(onNext: { deletedTodo in
//                print("TodoVM - deleteSelectedTodosWithObservable: deletedTodo: \(deletedTodo)")
//            }, onError: { err in
//                print("TodoVM - deleteSelectedTodosWithObservable: err: \(err)")
//            }).disposed(by: disposeBag)
        
        
        //        TodosAPI.deleteSelectedTodosWithObservable(selectedTodoIds: [2265, 2264, 2263, 2262])
        //            .subscribe(onNext: { deletedTodos in
        //                print("TodoVM - deleteSelectedTodosWithObservable: deletedTodos: \(deletedTodos)")
        //            }, onError: { err in
        //                print("TodoVM - deleteSelectedTodosWithObservable: err: \(err)")
        //            }).disposed(by: disposeBag)
        
//        TodosAPI.addATodoAndFetchTodosWithObservable(title: "오늘도 빡코딩 - 0201 ~~") // [Todo]
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] (response: [Todo]) in
//                print("TodoVM - addATodoAndFetchTodoWithObservable: response: \(response)")
//            }).disposed(by: disposeBag)
        
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
