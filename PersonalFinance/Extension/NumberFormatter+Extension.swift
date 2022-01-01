//
//  NumberFormatter+Extension.swift
//  PersonalFinance
//
//  Created by Mahmoud Fouad on 01/01/2022.
//

import Foundation
extension NumberFormatter {
    static func currency(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedValue = formatter.string(from: NSNumber(value: value)) ?? ""
        return "$" + formattedValue
    }
}
