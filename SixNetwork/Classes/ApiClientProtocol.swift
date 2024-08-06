//
//  ApiClient.swift
//  wish
//
//  Created by ljl-wt on 2024/8/1.
//

import Foundation
import RxSwift
import Alamofire

public protocol ApiClientProtocol {
    var headers: [String: String] { get }
    
    var baseUrl: String { set get }
    
    func request<T: Codable>(_ query: Query) -> Observable<T>
    
    func upload<T: Codable>(_ query: Query, fileURL: URL, uploadProgress: @escaping ProgressHandler) -> Observable<T>
    
    func download(_ query: Query, destinationURL: URL, downloadProgress: @escaping ProgressHandler) -> Observable<URL>
}




