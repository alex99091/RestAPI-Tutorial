//
//  TodosAPI+Closure.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/02/01.
//

import Foundation
import MultipartForm
import SwiftUI

extension TodosAPI {
    
    // 모든 할일 목록 가져오기
    static func fetchTodos(page: Int = 1, completion: @escaping
                           (Result<BaseListResponse<Todo>, ApiError>) -> Void) {
        // 1. urlRequest를 만든다
        let urlString = baseURL + "/todos" + "?page=\(page)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error = error {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            // statusCode에 따른 에러처리
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unAuthorized))
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: jsonData)
                    let todos = listResponse.data
                    print("todosResponse: \(listResponse)")
                    
                    // 상태코드는 200 대인데 파싱한 데이터에 따라서 달라지는 에러처리
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(listResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
            
        }.resume()
        
    }
    
    // 특정 할 일 가져오기
    static func fetchATodo(id: Int, completion: @escaping
                           (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        // 1. urlRequest를 만든다
        let urlString = baseURL + "/todos" + "/\(id)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error = error {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            // statusCode에 따른 에러처리
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    
                    completion(.success(baseResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
            
        }.resume()
        
    }
    
    // 모든 할일 검색하기
    static func searchTodos(searchTerm: String, page: Int = 1, completion: @escaping
                            (Result<BaseListResponse<Todo>, ApiError>) -> Void) {
        // 1. urlRequest를 만든다
        
        let requestUrl = URL(baseUrl: baseURL + "/todos/search", queryItems: ["query": searchTerm, "page": "\(page)"])
        
        //        var urlComponents = URLComponents(string: baseURL + "/todos/search")!
        //        urlComponents.queryItems = [
        //            URLQueryItem(name: "query", value: searchTerm),
        //            URLQueryItem(name: "page", value: "\(page)")
        //        ]
        
        guard let url = requestUrl else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error = error {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            // statusCode에 따른 에러처리
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let listResponse = try JSONDecoder().decode(BaseListResponse<Todo>.self, from: jsonData)
                    let todos = listResponse.data
                    print("todosResponse: \(listResponse)")
                    
                    // 상태코드는 200 대인데 파싱한 데이터에 따라서 달라지는 에러처리
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(listResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
            
        }.resume()
        
    }
    
    // 할일 추가하기
    // - Parameters:
    // - title: 할일 타이틀
    // - isDone: 할일 완료형
    // - completion: 응답 결과
    static func addATodo(title: String, isDone: Bool = false, completion: @escaping
                         (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        // 1. urlRequest를 만든다
        let urlString = baseURL + "/todos"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        let form = MultipartForm(parts: [
            MultipartForm.Part(name: "title", value: title),
            MultipartForm.Part(name: "is_done", value: "\(isDone)")
        ])
        
        print("form.contentType: \(form.contentType)")
        
        urlRequest.addValue(form.contentType, forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpBody = form.bodyData
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error = error {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            // statusCode에 따른 에러처리
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    
                    completion(.success(baseResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
            
        }.resume()
        
    }
    
    // 할일 추가하기 - JSON 방식 구현
    // - Parameters:
    // - title: 할일 타이틀
    // - isDone: 할일 완료형
    // - completion: 응답 결과
    static func addATodoJson(title: String, isDone: Bool = false, completion: @escaping
                             (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        // 1. urlRequest를 만든다
        let urlString = baseURL + "/todos-json"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // From Dictionary to JSON object : 보통 post 방식으로 json을 요청 데이터로 넣을때 사용 httpBody
        
        let requestParams: [String: Any] = ["title": title, "is_done": "\(isDone)"]
        
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            
            urlRequest.httpBody = jsonData
            
        } catch {
            
            return completion(.failure(ApiError.jsonEncoding))
            
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error = error {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            // statusCode에 따른 에러처리
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    
                    completion(.success(baseResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
    }
    
    // 할일 수정하기 - JSON 방식 구현
    // - Parameters:
    // - id:  수정할 아이템 아이디
    // - title: 할일 타이틀
    // - isDone: 완료여부
    // - completion: 응답 결과
    static func editTodoJson(id: Int, title: String, isDone: Bool = false, completion: @escaping
                             (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        // 1. urlRequest를 만든다
        let urlString = baseURL + "/todos-json/\(id)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // From Dictionary to JSON object : 보통 post 방식으로 json을 요청 데이터로 넣을때 사용 httpBody
        
        let requestParams: [String: Any] = ["title": title, "is_done": "\(isDone)"]
        
        do {
            let jsonData = try? JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            
            urlRequest.httpBody = jsonData
            
        } catch {
            
            return completion(.failure(ApiError.jsonEncoding))
            
        }
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error = error {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            // statusCode에 따른 에러처리
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    
                    completion(.success(baseResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
    }
    
    // 할일 수정하기 - PUT urlEncoded
    // - Parameters:
    // - id:  수정할 아이템 아이디
    // - title: 할일 타이틀
    // - isDone: 완료여부
    // - completion: 응답 결과
    static func editTodo(id: Int, title: String, isDone: Bool = false, completion: @escaping
                         (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        // 1. urlRequest를 만든다
        let urlString = baseURL + "/todos/\(id)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        let requestParams: [String: String] = ["title": title, "is_done": "\(isDone)"]
        
        urlRequest.percentEncodeParameters(parameters: requestParams)
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error = error {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            // statusCode에 따른 에러처리
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    
                    completion(.success(baseResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
    }
    
    // 할일 삭제하기 - Delete
    // - Parameters
    // - id:  삭제할 아이템 아이디
    // - completion: 응답 결과
    static func deleteATodo(id: Int, completion: @escaping
                            (Result<BaseResponse<Todo>, ApiError>) -> Void) {
        
        print(#fileID, #function, #line, "- deletedATodo 호출됨 / id: \(id)")
        
        // 1. urlRequest를 만든다
        let urlString = baseURL + "/todos/\(id)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ApiError.notAllowedUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            if let error = error {
                return completion(.failure(ApiError.unknown(error)))
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                print("bad status code")
                return completion(.failure(ApiError.unknown(nil)))
            }
            
            // statusCode에 따른 에러처리
            switch httpResponse.statusCode {
            case 401:
                return completion(.failure(ApiError.unAuthorized))
            case 204:
                return completion(.failure(ApiError.noContent))
            default: print("default")
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                return completion(.failure(ApiError.badStatus(code: httpResponse.statusCode)))
            }
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let baseResponse = try JSONDecoder().decode(BaseResponse<Todo>.self, from: jsonData)
                    
                    completion(.success(baseResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
        }.resume()
    }
    
    
    /// 할일 추가 후, 모든 할일 가져오기
    /// - Parameters:
    ///   - title:
    ///   - isDone:
    ///   - completion:
    static func addTodoAndFetchTodos(title: String,
                                     isDone: Bool = false,
                                     completion: @escaping (Result<BaseListResponse<Todo>, ApiError>) ->
                                        Void) {
        // 1
        self.addATodo(title: title, completion: { result in
            switch result {
                // 1-1
            case .success(_):
                // 2
                self.fetchTodos(completion: {
                    switch $0 {
                        // 2-1
                    case .success(let data):
                        completion(.success(data))
                        // 2-2
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                })
                // 1-2
            case .failure(let failure):
                completion(.failure(failure))
            }
        })
    }
    
    /// 클로져 기반 모두삭제 api 동시처리
    /// 선택된 할일들 삭제하기
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 ID
    ///   - completion: 실제 삭제가 완료된 아이디들
    static func deleteSelectedTodos(selectedTodoIds: [Int],
                                    completion: @escaping ([Int]) -> Void) {
        
        let group = DispatchGroup()
        
        // 성공적으로 삭제가 된 id들
        var deletedTodoIds: [Int] = [Int]()
        
        selectedTodoIds.forEach { aTodoId in
            
            // 디스패치 그룹에 넣기
            group.enter()
            self.deleteATodo(id: aTodoId, completion: { result  in
                switch result {
                case .success(let response):
                    
                    // 삭제된 아이디를 배열에 넣기
                    if let todoId = response.data?.id {
                        deletedTodoIds.append(todoId)
                        print("inner deleteATodo - success: \(todoId)")
                    }
                case .failure(let failure):
                    print("inner deleteATodo - failure")
                }
                group.leave()
            })// 단일 삭제 API 호출
        }
        // Configure a completion callback
        group.notify(queue: .main) {
            // All requests completed
            print("모든 API 완료 됨")
            completion(deletedTodoIds)
        }
    }
    
    /// 클로져 기반 api 동시처리
    /// 선택된 할일들 가져오기 + 에러캐치
    /// - Parameters:
    ///   - selectedTodoIds: 선택된 할일 ID
    ///   - completion: 응답결과
    static func fetchSelectedTodos(selectedTodoIds: [Int],
                                    completion: @escaping (Result<[Todo], ApiError>) -> Void) {
        
        let group = DispatchGroup()
        
        // 가지고온 할일들
        var fetchedTodos: [Todo] = [Todo]()
        
        // 에러들
        var apiErrors: [ApiError] = [ApiError]()
        
        // 응답결과들
        var apiResults = [Int: Result<BaseResponse<Todo>, ApiError>]()
        
        selectedTodoIds.forEach { aTodoId in
            
            // 디스패치 그룹에 넣기
            group.enter()
            
            self.fetchATodo(id: aTodoId,
                            completion: { result  in
                switch result {
                case .success(let response):
                    // 가져온 할일을 가져온 할일배열에 넣기
                    if let todo = response.data {
                        fetchedTodos.append(todo)
                        print("inner fetchATodo - success: \(todo)")
                    }
                case .failure(let failure):
                    apiErrors.append(failure)
                    print("inner fetchATodo - failure")
                }
                group.leave()
            })// 단일 할일 조회 API 호출
        }
        
        // Configure a completion callback
        group.notify(queue: .main) {
            // All requests completed
            print("모든 API 완료 됨")
            
            // 에러처리
            if !apiErrors.isEmpty {
                if let apiError = apiErrors.first {
                    completion(.failure(apiError))
                    return
                }
            }
            
            completion(.success(fetchedTodos))
        }
    }
    
}
