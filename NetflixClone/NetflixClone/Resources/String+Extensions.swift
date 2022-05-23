//
//  String+Extensions.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 19.05.2022.
//

import Foundation


//MARK: Identifier
extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}

//MARK: Localized
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
