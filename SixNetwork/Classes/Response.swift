//
//  response.swift
//  wish
//
//  Created by ljl-wt on 2024/8/5.
//

import Foundation
import RxSwift
import Alamofire

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


