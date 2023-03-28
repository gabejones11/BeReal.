//
//  DateFormatter.swift
//  BeReal
//
//  Created by Gabe Jones on 3/26/23.
//

import Foundation

extension DateFormatter {
    static var postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}
