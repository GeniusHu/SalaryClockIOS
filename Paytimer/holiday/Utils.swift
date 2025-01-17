//
//  Utils.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation
let weekdayMapping: [String: String] = [
    "Monday": "星期一",
    "Tuesday": "星期二",
    "Wednesday": "星期三",
    "Thursday": "星期四",
    "Friday": "星期五",
    "Saturday": "星期六",
    "Sunday": "星期日"
]
func localizedWeekday(_ englishWeekday: String) -> String {
    return weekdayMapping[englishWeekday] ?? englishWeekday
}

func saveCustomWorkdays(_ customWorkdays: [String: Bool]) {
    let englishCustomWorkdays = customWorkdays.reduce(into: [String: Bool]()) { result, item in
        if let englishName = mapChineseWeekdayToEnglish(item.key) {
            result[englishName] = item.value
        }
    }
    UserDefaults.standard.set(englishCustomWorkdays, forKey: "CustomWorkdays")
}

func loadCustomWorkdays() -> [String: Bool] {
    return UserDefaults.standard.dictionary(forKey: "CustomWorkdays") as? [String: Bool] ?? [
        "Monday": true,
        "Tuesday": true,
        "Wednesday": true,
        "Thursday": true,
        "Friday": true,
        "Saturday": false,
        "Sunday": false
    ]
}

// 映射中文到英文
func mapChineseWeekdayToEnglish(_ chineseWeekday: String) -> String? {
    return weekdayMapping.first(where: { $0.value == chineseWeekday })?.key
}

// 映射英文到中文
func mapEnglishWeekdayToChinese(_ englishWeekday: String) -> String? {
    return weekdayMapping[englishWeekday]
}
