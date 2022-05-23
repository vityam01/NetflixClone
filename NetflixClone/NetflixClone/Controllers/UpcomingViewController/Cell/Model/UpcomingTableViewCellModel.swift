//
//  UpcomingTableViewCellModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 20.05.2022.
//

import Foundation
import UIKit

struct TitleViewModel {
    let titleName: String
    let posterURL: String
}


class UpcomingTableViewCellModel {
    
    func viewCornerRadius() -> CGFloat {
        return 8
    }
    
    func viewBorderColour() -> CGColor {
        return UIColor.gray.cgColor
    }
    
    func viewBorderWidth() -> CGFloat {
        return 2
    }
    
    func pitureCorenerRadius() -> CGFloat {
        return 15
    }
    
    func imageURL(model: TitleViewModel) -> URL {
        guard let url = URL(string: "\(Constants.imageURL)\(model.posterURL)") else { return URL(fileURLWithPath: "")}
        return url
    }
}
