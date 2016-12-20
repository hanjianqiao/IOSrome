//
//  JsonTools.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/20.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import Foundation

class JsonTools{
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
