//
//  Query.swift
//  wish
//
//  Created by ljl-wt on 2024/8/2.
//

import Foundation
import RxSwift
import Alamofire

public enum ClientType {
    case alamofire, urlSession
}

public enum MoudleType {
    case common
    case home
    case mine
    case login
}

public typealias ProgressHandler = (Progress) -> Void

public class Query {
    public var path: String = ""
    public var method: HTTPMethod = .get
    public var parameters: [String: Any]? = nil
    public var headers: [String: String]? = nil
    public var paramEncoding: ParameterEncoding = URLEncoding.default
    public var responseParser: ResponseParser = WTResponseParser()
    
    public var clientType = ClientType.alamofire
    public var moudleType = MoudleType.common
    
    public var client: ApiClient {
        get {
            switch clientType {
            case .alamofire:
                return AFClient.shared
            case .urlSession:
                return AFClient.shared
            }
        }
    }
    
    public init(_ path: String,
         parameters: [String : Any]? = nil,
         headers: [String : String]? = nil,
         paramEncoding: ParameterEncoding = URLEncoding.default,
         clientType: ClientType = ClientType.alamofire,
         moudleType: MoudleType = MoudleType.common) {
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.paramEncoding = paramEncoding
        self.clientType = clientType
        self.moudleType = moudleType
    }
    
    public class func home(_ path: String,
                      parameters: [String : Any]? = nil,
                      headers: [String : String]? = nil) -> Query {
        Query(path, parameters: parameters, headers: headers, moudleType: .home)
    }
}


extension Query {
    public func get<T: Codable>() -> Observable<T> {
        request(.get)
    }
    
    public func post<T: Codable>() -> Observable<T> {
        request(.post)
    }
    
    public func put<T: Codable>() -> Observable<T> {
        request(.put)
    }
    
    public func detele<T: Codable>() -> Observable<T> {
        request(.delete)
    }
    
    public func head<T: Codable>() -> Observable<T> {
        request(.head)
    }
    
    private func request<T: Codable>(_ method: HTTPMethod) -> Observable<T> {
        self.method = method
        return client.request(self)
    }
    
    public func upload<T: Codable>(fileURL: URL, uploadProgress: @escaping ProgressHandler = {_ in }) -> Observable<T> {
        client.upload(self, fileURL: fileURL, uploadProgress: uploadProgress)
    }
    
    public func download(destinationURL: URL, downloadProgress: @escaping ProgressHandler = {_ in }) -> Observable<URL> {
        client.download(self, destinationURL: destinationURL, downloadProgress: downloadProgress)
    }
}


