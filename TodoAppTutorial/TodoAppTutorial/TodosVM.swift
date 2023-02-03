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
import RxCombine


// ObserverbaleObject를 선언 하면 변경에 대한 감지가 가능
class TodosVM: ObservableObject {
    
    var disposeBag = DisposeBag()
    var subscriptions = Set<AnyCancellable>()
    
    // 가공된 최종 데이터
    var todos: [Todo] = [] {
        didSet {
            print(#fileID, #function, #line, "- ")
            self.notifyTodosChanged?(todos)
        }
    }
    
    var currentPage = 1 {
        didSet {
            print(#fileID, #function, #line, "- ")
            self.notifyCurrentPageChanged?(currentPage)
        }
    }
    var isLoading: Bool = false {
        didSet {
            print(#fileID, #function, #line, "- ")
            notifyLoadingStateChanged?(isLoading)
        }
    }
    
    // 데이터 로딩중 여부 변경 이벤트
    var notifyLoadingStateChanged: ((_ isLoading: Bool) -> Void)? = nil
    
    // 데이터 변경 이벤트
    var notifyTodosChanged: (([Todo]) -> Void)? = nil
    
    // 현재 페이지 변경
    var notifyCurrentPageChanged: ((Int) -> Void)? = nil
    
    init() {
        print(#fileID, #function, #line, "- ")
        
        fetchTodos()
    }// init
    
    // 더 가져오기 (페이징 처리)
    func fetchMore(){
        print(#fileID, #function, #line, "- ")
        self.fetchTodos(page: currentPage + 1)
    }
    
    
    // 할일 가져오기
    func fetchTodos(page:Int = 1) {
        
        if isLoading {
            print("로딩중입니다")
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            // 서비스 로직
            TodosAPI.fetchTodos(page: 1, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    // 페이지 갱신
                    self.currentPage = page
                    if let fetchedTodos: [Todo] = response.data {
                        if page == 1 {
                            self.todos = fetchedTodos
                        } else {
                            self.todos.append(contentsOf: fetchedTodos)
                        }
                    }
                    
                case .failure(let failure):
                    print("failure: \(failure)")
                }
                self.isLoading = false
            })
        })
    }
    
    // - Parameter error: API에러처리
    fileprivate func handleError(_ error: Error) {
        if error is TodosAPI.ApiError {
            let apiError = error as! TodosAPI.ApiError
            print("handleError: error = \(apiError.info)")
            switch apiError {
            case .noContent:
                print("컨텐츠가 없습니다.")
            case .unauthorized:
                print("인증되지 않았습니다.")
            default:
                print("default")
            }
        }
    }// handleError
    
}
