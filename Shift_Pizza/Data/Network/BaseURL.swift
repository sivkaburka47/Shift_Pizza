//
//  BaseURL.swift
//  Shift_Pizza
//
//  Created by Станислав Дейнекин on 29.01.2025.
//

enum BaseURL {
    case shift

    var baseURL: String {
        switch self {
        case .shift:
            return "https://shift-intensive.ru/api"
        }
    }
}
