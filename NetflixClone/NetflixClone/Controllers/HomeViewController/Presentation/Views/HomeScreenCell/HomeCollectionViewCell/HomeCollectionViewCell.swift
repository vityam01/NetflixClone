//
//  HomeCollectionViewCell.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 19.05.2022.
//

import UIKit
import SDWebImage


final class HomeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var posterImage: UIImageView!
    
    private var viewModel: HomeCollectionViewCellModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = HomeCollectionViewCellModel()
        posterImage.layer.cornerRadius = viewModel?.cornerRadius() ?? 0
    }

    func configure(with model: String) {
        guard let viewModel = viewModel else { return }
        self.posterImage.sd_setImage(with: viewModel.getImage(model: model), completed: nil)
    }
}
