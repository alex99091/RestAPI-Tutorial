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
        case noContent
        case decodingError
        case unAuthorized
        case badStatus(code: Int)
        case unknown(_ error: Error?)
        
        var info: String {
            switch self {
            case .noContent: return "데이터가 없습니다."
            case .decodingError: return "decoding 에러입니다."
            case .unAuthorized: return "인증되지 않은 사용자입니다."
            case let .badStatus(code): return "에러 상태코드: \(code)입니다."
            case .unknown(let error): return "알 수 없는 \(error): 에러입니다."
            }
        }
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
        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            
            print("data: \(data)")
            print("URLResponse: \(urlResponse)")
            print("error: \(error)")
            
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
                    let todosResponse = try JSONDecoder().decode(TodosResponse.self, from: jsonData)
                    let todos = todosResponse.data
                    print("todosResponse: \(todosResponse)")
                    
                    // 상태코드는 200 대인데 파싱한 데이터에 따라서 달라지는 에러처리
                    guard let todos = todos,
                          !todos.isEmpty else {
                        return completion(.failure(ApiError.noContent))
                    }
                    
                    completion(.success(todosResponse))
                } catch {
                    // decoding error
                    completion(.failure(ApiError.decodingError))
                }
            }
            
        }.resume()
        
    }
    
}

