//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 15.05.2022.
//

import UIKit

final class UpcomingViewController: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak private var upcomingTable: UITableView!
    
    //MARK: Variable/ Constants
    
    private var viewModel: UpcomingViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    
    //MARK: Private methods
    private func initUI() {
        self.viewModel = UpcomingViewModel()
        view.backgroundColor = .systemBackground
        title = viewModel?.titleText ?? ""
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        upcomingTable.register(UINib(nibName: UpcomingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        setData()
    }

    private func setData() {
        viewModel?.getData { [weak self] in
            DispatchQueue.main.async {
                self?.upcomingTable.reloadData()
            }
        }
    }
    
}

//MARK: Extension
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.itemsCount(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell, let viewModel = viewModel else { return UITableViewCell() }
                cell.configure(with: viewModel.initializeCell(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else { return 0}
        return viewModel.heightForRowAt()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let viewModel = viewModel else { return 0}
        return viewModel.heightForHeaderInSection()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectRow(indexPath: indexPath, completion: { [weak self] videoElement,title  in
            DispatchQueue.main.async {
                let vc = TitlePreviewViewController()
                vc.configure(wirh: TitlePreviewViewModel(title: title.original_name ?? title.original_title ?? "",
                                                         youtubeView: videoElement,
                                                         titleOverview: title.overview ?? ""))
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
}
