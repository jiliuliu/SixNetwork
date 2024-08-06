Pod::Spec.new do |s|
    s.name             = 'SixNetwork'
    s.version          = '0.1.2'
    s.summary          = 'SixNetwork'
    s.description      = <<-DESC
    SixNetwork是网络库组件，用于发送http请求
    DESC
    s.homepage         = 'https://github.com/jiliuliu/SixNetwork'
    s.author           = { "six" => "liujiliu1989@163.com" }
    s.source           = { :git => 'https://github.com/jiliuliu/SixNetwork.git', :tag => s.version.to_s }
    s.source_files     = 'SixNetwork/Classes/**/*'
    
    s.platform = :ios, "13.0"
    s.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5']
    s.frameworks = 'Foundation'
    s.dependency 'Alamofire', '5.9.1'
    s.dependency 'RxSwift', '6.7.1'
    
end
