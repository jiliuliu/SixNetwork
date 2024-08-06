//
//  ViewController.swift
//  wish
//
//  Created by ljl-wt on 2024/7/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SixNetwork

class ViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("获取国家列表", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.equalTo(-100)
            make.centerX.equalToSuperview()
        }
        return button
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.red.cgColor
        textView.frame = CGRectInset(view.bounds, 50, 200)
        textView.textColor = .black
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        AFClient.shared.baseUrl = AppEnv.shared.env.baseUrl
        AFClient.shared.headers = headers
        
        let _ = button.rx.tap.subscribe { _ in
            let _ = self.getCountryList().subscribe { value in
                self.textView.text = value.description
            } onError: { error in
                print(error)
            }
        }
        
    }
    
    func getCountryList() -> Observable<Array<CountryModel>> {
        Query("/common/country/list").get()
    }
    
    func launchCheck()-> Observable<CountryModel> {
        Query("/app/launch/check").post()
    }
    
    
}



struct CountryModel: Codable, CustomStringConvertible {
    let areaEnglishName: String?
    let areaFirstName: String?
    let areaId: String?
    
    var description: String {
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

let headers: [String : String] = [
    "Client-End":"iOS",
    "Version":"V1.3.0",
    "Device-Id":"6335799D-99B2-496C-B317-0AC661AD0084",
    "System":"Alpha Lite",
    "Connection":"keep-alive",
    "operation_date":"1722564005183",
    "content-type":"application/json",
    "Accept-Language":"zh-CN",
    "Authorization":"eyJhbGciOiJIUzUxMiJ9.eyJ1c2VyX2lkIjoienE2MkhWTjV1eDJvcDFudVh1ViIsImxvZ2luX3VzZXJfcm9sZSI6IltcImluc3RhbGxlclwiLFwiZGV2XCIsXCJ0cGFkbWluXCJdIiwidXNlcl9rZXkiOiJhZDdmYWE2Yi04MzM0LTQyM2ItYjBjMi04M2YyOTVkZDJmNjYiLCJleHBpcmVfdGltZSI6MTcyNTE1NTk1NjYyNiwiZXJlY3Rvcl9pbmZvIjoibnVsbCIsImxvZ2luQ29JZCI6bnVsbCwidXNlcm5hbWUiOiJ3ZW50YW8uemhhbmdAYWxwaGEtZXNzLmNvbSJ9.tKFyprsrpd9Jh9m618keaK_XbLRlxQXDDHVo2kWcEVOCGWDlcckauMywq9gbg9lF-nXsz6AUGzJgXnxTt01k1Q"]
