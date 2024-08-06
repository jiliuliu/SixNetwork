//
//  AFClient.swift
//  wish
//
//  Created by ljl-wt on 2024/8/2.
//

import Foundation
import RxSwift
import Alamofire

public class AFClient: ApiClientProtocol {
    
    public static let shared = AFClient()
    
    private var sessionMap: [BussinseType: Session] = [:]
    
    public var headers: [String: String] = [:]
    
    public var baseUrl: String = ""
    
    private func session(_ bussinseType: BussinseType) -> Session {
        if let se = sessionMap[bussinseType] {
            return se
        }
        sessionMap[bussinseType] = Session()
        return sessionMap[bussinseType]!
    }
    
    // 通用请求
    public func request<T: Codable>(_ query: Query) -> Observable<T> {
        observable { observer in
            self.session(query.bussinseType).request(
                self.combineUrl(query.path),
                method: query.method,
                parameters: query.parameters,
                encoding: query.paramEncoding,
                headers: self.combineHeaders(query.headers))
            .validate()
            .responseDecodable(of: query.responseParser.modelType(T.self)) { response in
                query.responseParser.parse(response: response, query: query, observer: observer)
            }
        }
    }
    
    // 上传文件
    public func upload<T: Codable>(_ query: Query, fileURL: URL, uploadProgress: @escaping ProgressHandler) -> Observable<T> {
        observable { observer in
            self.session(query.bussinseType).upload(
                fileURL,
                to: self.combineUrl(query.path),
                method: query.method,
                headers: self.combineHeaders(query.headers))
            .uploadProgress(closure: uploadProgress)
            .validate()
            .responseDecodable(of: query.responseParser.modelType(T.self)) { response in
                query.responseParser.parse(response: response, query: query, observer: observer)
            }
        }
    }
    
    // 下载文件
    public func download(_ query: Query, destinationURL: URL, downloadProgress: @escaping ProgressHandler) -> Observable<URL> {
        observable { observer in
            let destination: DownloadRequest.Destination = { _, _ in
                return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            return self.session(query.bussinseType).download(
                self.combineUrl(query.path),
                method: query.method,
                parameters: query.parameters,
                encoding: query.paramEncoding,
                headers: self.combineHeaders(query.headers),
                to: destination)
            .downloadProgress(closure: downloadProgress)
            .validate()
            .response { response in
                switch response.result {
                case .success(let url):
                    if let url = url {
                        observer.onNext(url)
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "Download Error", code: -1, userInfo: nil))
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
        }
    }
    
    func observable<T>(request: @escaping (AnyObserver<T>) -> Request) -> Observable<T> {
        Observable.create { observer in
            let request = request(observer)
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func combineUrl(_ path: String) -> String {
        if path.hasPrefix("http") {
            return path
        }
        return baseUrl + path
    }
    
    func combineHeaders(_ headers: [String: String]?) -> HTTPHeaders {
        HTTPHeaders(self.headers.merging(headers ?? [:]) { (_, new) in new })
    }
}


