//
//  Array+Extension.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 22.05.2022.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
