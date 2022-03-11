//
//  String+Array.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/8/22.
//

import Foundation

extension String {
    func keywords() -> [String] {
        guard !self.isEmpty else {
            return []
        }
        
        var stringArray: Set<String> = []

        for index in 1...self.count {
            let subString = self.prefix(index)
            stringArray.insert(String(subString))
            stringArray.insert(String(subString).lowercased())
        }

        return Array(stringArray)
    }
}
