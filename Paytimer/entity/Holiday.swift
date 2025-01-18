//
//  Holiday.swift
//  Paytimer
//
//  Created by Hu on 2025/1/19.
//

import Foundation

/// 用于表示法定节假日的结构体
struct Holiday: Codable {
    /// 节假日名称
    let name: String
    /// 节假日具体日期（如 "2025-01-01"）
    let date: Date
}
