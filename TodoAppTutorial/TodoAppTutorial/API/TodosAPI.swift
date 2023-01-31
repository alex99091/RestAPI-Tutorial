//
//  TodosAPI.swift
//  TodoAppTutorial
//
//  Created by BOONGKI KWAK on 2023/01/31.
//

import Foundation
import MultipartForm

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
        case jsonEncoding
        case unAuthorized
        case notAllowedUrl
        case badStatus(code: Int)
        case unknown(_ error: Error?)
        
        var info: String {
            switch self {
            case .noContent: return "데이터가 없습니다."
            case .decodingError: return "decoding 에러입니다."
            case .jsonEncoding: return "유효한 json형식이 아닙니다."
            case .unAuthorized: return "인증되지 않은 사용자입니다."
            case .notAllowedUrl: return "올바른 형식이 아닙니다."
            case let .badStatus(code): return "에러 상태코드: \(code)입니다."
            case .unknown(let error): return "알 수 없는 \(String(describing: error)): 에러입니다."
            }
        }
    }
    
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
    
}

