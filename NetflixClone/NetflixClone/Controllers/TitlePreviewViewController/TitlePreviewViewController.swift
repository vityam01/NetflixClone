//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 21.05.2022.
//

import WebKit
import UIKit

class TitlePreviewViewController: UIViewController {

    @IBOutlet weak private var videoView: WKWebView!
    @IBOutlet weak private var titleName: UILabel!
    @IBOutlet weak private var overviewLabel: UILabel!
    @IBOutlet weak private var downloadButton: UIButton!
    
    var model: TitlePreviewViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }


    private func initUI() {
        view.backgroundColor = .systemBackground
        downloadButton.layer.cornerRadius = 8
        downloadButton.layer.masksToBounds = true
        titleName.text = model?.title
        overviewLabel.text = model?.titleOverview
        launchVideo()
        
    }
  
    func configure(wirh model: TitlePreviewViewModel) {
        self.model = model
       
    }
    
    private func launchVideo() {
        guard let url = URL(string: "https://www.youtube.com/embed/\(model?.youtubeView.id.videoId ?? "")") else { return }
        videoView.load(URLRequest(url: url))
    }
}
