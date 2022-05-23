//
//  HeaderTableView.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 17.05.2022.
//

import UIKit

final class HeaderTableView: UIView {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    private var viewModel: HeaderViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configure(with model: TitleViewModel) {
        guard let viewModel = viewModel else { return }
        DispatchQueue.main.async { [weak self] in
            self?.backgroundImage.sd_setImage(with: viewModel.loadPictureForView(model: model), completed: nil)
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(HeaderTableView.identifier, owner: self, options: nil)
        addSubview(contentView)
        self.viewModel = HeaderViewModel()
        addGradient()
        contentView.frame = self.bounds
        updateUI()
    }
    
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }

        playButton.layer.borderWidth = viewModel.borderWidth()
        playButton.layer.cornerRadius = viewModel.buttonCornerRadius()
        backgroundImage.layer.cornerRadius = viewModel.imageCornerRadius()
        playButton.layer.borderColor = UIColor.label.cgColor
        downloadButton.layer.borderWidth = viewModel.borderWidth()
        downloadButton.layer.cornerRadius = viewModel.buttonCornerRadius()
        downloadButton.layer.borderColor = UIColor.label.cgColor
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        gradientView?.layer.addSublayer(gradientLayer)
    }
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        viewModel.playButtonTapped()
    }
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        viewModel.downloadButtonTapped()
    }
    
}


