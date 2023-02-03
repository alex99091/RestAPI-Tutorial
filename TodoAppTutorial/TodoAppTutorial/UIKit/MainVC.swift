//
//  MainVC.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/30.
//

import Foundation
import UIKit
import SwiftUI

class MainVC: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var todos: [Todo] = []
    
    var todosVM: TodosVM = TodosVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        self.view.backgroundColor = .systemYellow
        
        self.myTableView.register(TodoCell.uinib, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        self.myTableView.dataSource = self
        
        // 뷰모델 이벤트 받기: 뷰와 뷰모델 바인딩
        self.todosVM.notifyTodosChanged = { updatedTodos in
            self.todos = updatedTodos
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
        
//        MVC business 로직: 메인뷰와 데이터 연결
//        TodosAPI.fetchTodos(page: 1, completion: { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                if let fetchedTodos: [Todo] = response.data {
//                    self.todos = fetchedTodos
//                    DispatchQueue.main.async {
//                        self.myTableView.reloadData()
//                    }
//                }
//            case .failure(let failure):
//                print("failure: \(failure)")
//            }
//        })
        
    }
}

// 1. 갯수
// 2. 어떤 셀을 보여줄지
extension MainVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let cellData = self.todos[indexPath.row]
        
        //데이터 셀에 넣어주기
        cell.updateUI(cellData)
        
        return cell
        
    }
}

extension MainVC {
    
    private struct VCRepresentable : UIViewControllerRepresentable {
        
        let mainVC : MainVC
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return mainVC
        }
    }
    
    func getRepresentable() -> some View {
        VCRepresentable(mainVC: self)
    }
}




