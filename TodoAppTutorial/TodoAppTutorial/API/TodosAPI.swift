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
        case unauthorized
        case notAllowedUrl
        case badStatus(code: Int)
        case unknown(_ error: Error?)
        
        var info: String {
            switch self {
            case .noContent: return "데이터가 없습니다."
            case .decodingError: return "decoding 에러입니다."
            case .jsonEncoding: return "유효한 json형식이 아닙니다."
            case .unauthorized: return "인증되지 않은 사용자입니다."
            case .notAllowedUrl: return "올바른 형식이 아닙니다."
            case let .badStatus(code): return "에러 상태코드: \(code)입니다."
            case .unknown(let error): return "알 수 없는 \(String(describing: error)): 에러입니다."
            }
        }
    }
    
}

