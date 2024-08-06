//
//  api.swift
//  wish
//
//  Created by ljl-wt on 2024/8/1.
//

import Foundation
import RxSwift
import Alamofire

public protocol ResponseParser {
            
    func parse<T: Codable>(response: DataResponse<ResponseModel<T>, AFError>, query: Query, observer: AnyObserver<T>)

    func toBusinessError<T: Codable>(_ model: ResponseModel<T>, query: Query) -> ApiError
    
    func modelType<T: Codable>(_ type: T.Type) -> ResponseModel<T>.Type
}

public struct WTResponseParser: ResponseParser {
    public func parse<T: Codable>(response: Alamofire.DataResponse<ResponseModel<T>, Alamofire.AFError>, query: Query, observer: RxSwift.AnyObserver<T>) {
        print(response.description)
        switch response.result {
        case .success(let value):
            if value.success {
                observer.onNext(value.data)
                observer.onCompleted()
            } else {
                observer.onError(toBusinessError(value, query: query))
            }
        case .failure(let error):
            observer.onError(WTApiError(error))
        }
    }
    
    public func toBusinessError<T: Codable>(_ model: ResponseModel<T>, query: Query) -> any ApiError {
        WTApiError(model.code, message: model.message)
    }
    
    public func modelType<T: Codable>(_ type: T.Type) -> ResponseModel<T>.Type {
        WTResponseModel<T>.self
    }
}

public enum WTApiError: ApiError {
    public init(_ error: any Error) {
        self = .unkown(obj: error)
    }
    
    public init(_ code: String?, message: String?) {
        self = .bussines(code, message)
    }
    
    case authFailure
    case unkown(obj: Any)
    case bussines(_ code: String?, _ message: String?)
}


public class WTResponseModel<T: Codable>: ResponseModel<T> {
    public override var success: Bool {
        code == "000000"
    }
    
}

