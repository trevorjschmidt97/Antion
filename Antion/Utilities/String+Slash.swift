//
//  String+:.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/29/21.
//

import Foundation

extension String {
    func slashToDash() -> String {
        return self.replacingOccurrences(of: "/", with: "-")
    }
    
    func dashToSlash() -> String {
        return self.replacingOccurrences(of: "-", with: "/")
    }
}
