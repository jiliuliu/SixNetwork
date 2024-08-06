//
//  AppEnv.swift
//  wish
//
//  Created by ljl-wt on 2024/8/1.
//

import Foundation

public enum AppEnvType {
    case prod, test, dev
    
    public var baseUrl: String {
        get {
            switch (self) {
            case .prod:
                "https://vitapower.alphaess.com/api/lite/mobile"
            case .test:
                "https://www.carbon2030.com/stable/lite/mobile"
            case .dev:
                "http://www.carbon2030.com:9111/api/lite/mobile"
            }
        }
    }
}


public class AppEnv {
    public static let shared = AppEnv()
    
    public var env = AppEnvType.dev

    private init() {
        
    }
}
