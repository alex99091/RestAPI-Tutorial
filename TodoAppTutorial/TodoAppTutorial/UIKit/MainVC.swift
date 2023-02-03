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
    @IBOutlet weak var pageInfoLabel: UILabel!
    
    var todos: [Todo] = []
    var todosVM: TodosVM = TodosVM()
    
    // 바텀 인디케이터 뷰
    lazy var bottomIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = UIColor.systemBlue
        indicator.startAnimating()
        indicator.frame = CGRect(x:0, y:0, width: myTableView.bounds.width, height: 44)
        return indicator
    }()
    
    // 당겨서 새로고침
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
//        refreshControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        refreshControl.tintColor = .systemBlue.withAlphaComponent(0.5)
//       refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ")
        self.view.backgroundColor = .systemYellow
        
        // 테이블 뷰 설정
        self.myTableView.register(TodoCell.uinib, forCellReuseIdentifier: TodoCell.reuseIdentifier)
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
        self.myTableView.tableFooterView = bottomIndicator
        self.myTableView.refreshControl = refreshControl
        
        // 뷰모델 이벤트 받기: 뷰와 뷰모델 바인딩
        self.todosVM.notifyTodosChanged = { [weak self] updatedTodos in
            guard let self = self else { return }
            self.todos = updatedTodos
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
        
        // 페이지 변경 이벤트 - 로딩중 여부
        self.todosVM.notifyCurrentPageChanged = { [weak self] currentPage in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.pageInfoLabel.text = "페이지: \(currentPage)"
            }
        }
        
        // 당겨서 데이터 리프레시 완료
        self.todosVM.notifyRefreshEnded = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
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
        
        
    }// viewDidLoad
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

//Mark: - refresh 처리
extension MainVC {
    
    /// - Parameter sender:
    @objc fileprivate func handleRefresh(_ sender: UIRefreshControl) {
        print(#fileID, #function, #line, "- ")
    
    // 뷰모델에 시키기
        self.todosVM.fetchRefresh()
        
    }
}

extension MainVC: UITableViewDelegate {
    
    /// - Parameter scrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(#fileID, #function, #line, "- ")
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        
        if distanceFromBottom - 150 < height {
            print("바닥이다")
            self.todosVM.fetchMore()
        }
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




