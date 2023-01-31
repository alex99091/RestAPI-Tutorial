//
//  TodosAPI.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/31.
//

import Foundation

enum TodosAPI {
    
    // Prdocut -> Scheme -> Edit Scheme: debug 또는 release 버전으로 baseUrl 변경 가능
    // 버전
    static let version = "v1"
    // if Debug // 디버그
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    // if release // 릴리즈
    static let release = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
    // end if
    
    
    enum ApiError: Error {
        case parsingError
        case noContent
        case decodingError
        case badStatus(code: Int)
    }
    
    static func fetchTodos(page: Int = 1, completion: @escaping(Result<TodosResponse, ApiError>) -> Void) {
        // 1. urlRequest를 만든다
        let urlString = baseURL + "/todos" + "?page=\(page)"
        let url = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        
        // 2. urlSession으로 API를 호출한다
        // 3. API 호출에 대한 응답을 받는다.
        URLSession.shared.dataTask(with: urlRequest) { data, URLResponse, error in
            
            print("data: \(data)")
            print("URLResponse: \(URLResponse)")
            print("error: \(error)")
            
            if let jsonData = data {
                // convert data to our swift model
                do {
                    // JSON -> Struct로 변경 즉 디코딩(data parsing)
                    let todosResponse = try JSONDecoder().decode(TodosResponse.self, from: jsonData)
                    let modelObjects = todosResponse.data
                    print("todosResponse: \(todosResponse)")
                    completion(.success(todosResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
            
        }.resume()
        
    }
    
}

