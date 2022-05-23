//
//  HomeCollectionViewCellModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 23.05.2022.
//

import Foundation
import UIKit

class HomeCollectionViewCellModel {
    
    func cornerRadius() -> CGFloat {
        return 18
    }
    
    func getImage(model: String ) -> URL {
        guard let url = URL(string: "\(Constants.imageURL)\(model)") else { return URL(fileURLWithPath: "") }
        return url
    }
}
