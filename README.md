# SixNetwork

[![CI Status](https://img.shields.io/travis/liujiliu1989@163.com/SixNetwork.svg?style=flat)](https://travis-ci.org/liujiliu1989@163.com/SixNetwork)
[![Version](https://img.shields.io/cocoapods/v/SixNetwork.svg?style=flat)](https://cocoapods.org/pods/SixNetwork)
[![License](https://img.shields.io/cocoapods/l/SixNetwork.svg?style=flat)](https://cocoapods.org/pods/SixNetwork)
[![Platform](https://img.shields.io/cocoapods/p/SixNetwork.svg?style=flat)](https://cocoapods.org/pods/SixNetwork)

## Requirements

  s.dependency 'Alamofire'
  s.dependency 'RxSwift'

## Installation

SixNetwork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/jiliuliu/SixSpecs.git'

pod 'SixNetwork'
```

## 实现原理

### ApiClient
#### ApiClient协议定义了接口请求的基础能力，AFClient基于AF实现ApiClient，也可以实现基于原生的URLSession的ApiClient
#### 隔离网络层实现，支持无感替换底层网络库
#### 支持多域名，多模块化
#### 模块间Session隔离

```swift
public protocol ApiClient {
    var headers: [String: String] { get }
    
    var baseUrl: String { set get }
    
    func request<T: Codable>(_ query: Query) -> Observable<T>
    
    func upload<T: Codable>(_ query: Query, fileURL: URL, uploadProgress: @escaping ProgressHandler) -> Observable<T>
    
    func download(_ query: Query, destinationURL: URL, downloadProgress: @escaping ProgressHandler) -> Observable<URL>
}
```

### Query
#### 定义接口请求配置、ApiClient配置
#### 请求转发
```swift
public class Query {
    public var path: String = ""
    public var method: HTTPMethod = .get
    public var parameters: [String: Any]? = nil
    public var headers: [String: String]? = nil
    public var paramEncoding: ParameterEncoding = URLEncoding.default
    public var responseParser: ResponseParser = WTResponseParser()
    
    public var clientType = ClientType.alamofire
    public var moudleType = MoudleType.common
    
    public func get<T: Codable>() -> Observable<T> {
        request(.get)
    }
    
    public func post<T: Codable>() -> Observable<T> {
        request(.post)
    }
    
    private func request<T: Codable>(_ method: HTTPMethod) -> Observable<T> {
        self.method = method
        return client.request(self)
    }
    
}
    
```

### ResponseParser
#### 统一处理接口外层解析，通用错误处理
    
```swift
Query("/common/country/list", responseParser: WTResponseParser())
```

## Example

```swift

// 发送请求
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        /// 配置域名、请求头等。。
        AFClient.shared.baseUrl = "https://www.api.com"
        AFClient.shared.headers = [:]
        
        // 点击按钮->发送请求->数据可视化转换->在label上显示
        button.rx.tap
            .flatMap(getCountryList)
            .map({$0.description})
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    // 通过声明返回类型，传递model类型，无感解析model
    func getCountryList() -> Observable<Array<CountryModel>> {
        Query("/common/country/list").get()
    }
    
    
//  自定义响应解析
public struct WTResponseParser: ResponseParser {    
    
    public func parse<T: Codable>(response: Alamofire.DataResponse<ResponseModel<T>, Alamofire.AFError>, query: Query, observer: RxSwift.AnyObserver<T>) {
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

```

## Author

liujiliu1989@163.com

## License

SixNetwork is available under the MIT license. See the LICENSE file for more info. 

## fastlane
fastlane SpecTool tag:0.1.4 specName:SixNetwork
