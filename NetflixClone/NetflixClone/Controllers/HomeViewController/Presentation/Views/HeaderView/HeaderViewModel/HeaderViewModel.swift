//
//  HeaderViewModel.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 23.05.2022.
//

import Foundation
import UIKit

class HeaderViewModel {
    
    
    func borderWidth() -> CGFloat {
        return 2
    }
    
    func buttonCornerRadius() -> CGFloat {
        return 8
    }
    
    func imageCornerRadius() -> CGFloat {
        return 25
    }
    
    func loadPictureForView(model: TitleViewModel) -> URL {
        guard let url = URL(string: "\(Constants.imageURL)\(model.posterURL)") else { return URL(fileURLWithPath: "") }
        return url
    }
    
    
    //TODO: PlayButton ACtion
    
    func playButtonTapped() {
        
    }
    
    //TODO: DownloadButtonTapped
    
    func downloadButtonTapped() {
        
    }
    
}
