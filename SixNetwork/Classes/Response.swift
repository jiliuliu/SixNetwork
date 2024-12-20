//
//  response.swift
//  wish
//
//  Created by ljl-wt on 2024/8/5.
//

import Foundation
import RxSwift
import Alamofire

public protocol ResponseParser {
            
    func parse<T: Codable>(response: DataResponse<ResponseModel<T>, AFError>, query: Query, observer: AnyObserver<T>)

    func toBusinessError<T: Codable>(_ model: ResponseModel<T>, query: Query) -> ApiError
    
    func modelType<T: Codable>(_ type: T.Type) -> ResponseModel<T>.Type
}

public protocol ApiError: Error {
    init(_ error: Error)
    init(_ code: String?, message: String?)
}

public class ResponseModel<T: Codable>: Codable, CustomStringConvertible {
    
    public var message: String?
    public var code: String?
    public var data: T
    
    public var success: Bool {
        true
    }
    
    public var description: String {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted // 格式化 JSON 输出，使其易读
            do {
                let jsonData = try encoder.encode(self)
                return String(data: jsonData, encoding: .utf8) ?? "Invalid JSON"
            } catch {
                return "Failed to encode object to JSON: \(error)"
            }
        }
}


public protocol ResponseParserX<T> {
    associatedtype T

    func modelType() -> T

}

struct xxsdasd: ResponseParserX {
    func modelType() -> String {
        return ""
    }
    
//    typealias T = String
    
    
    

}

