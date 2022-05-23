//
//  UpcomingTableViewCell.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 19.05.2022.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    
   

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var filmPicture: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var customContentView: UIView!
    
    private var viewModel: UpcomingTableViewCellModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = UpcomingTableViewCellModel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initUI()
    }
    
    private func initUI() {
        guard let viewModel = viewModel else { return }

        customContentView.layer.cornerRadius = viewModel.viewCornerRadius()
        customContentView.layer.borderColor = viewModel.viewBorderColour()
        customContentView.layer.borderWidth = viewModel.viewBorderWidth()
        filmPicture.layer.cornerRadius = viewModel.pitureCorenerRadius()
    }
    
    func configure(with model: TitleViewModel ) {
        guard let viewModel = viewModel else { return }
        filmPicture.sd_setImage(with: viewModel.imageURL(model: model))
        namelabel.text = model.titleName
    }
    
    
    
}
