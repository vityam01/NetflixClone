//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 15.05.2022.
//

import UIKit

final class DownloadsViewController: UIViewController {

    @IBOutlet weak private var downloadsTable: UITableView!
    
    private var viewModel: DownloadsViewModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    private func initUI() {
        self.viewModel = DownloadsViewModel()
        
        view.backgroundColor = .systemBackground
        title = viewModel?.titleText ?? ""
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        setupTable()
        fetchLocalStorageForDownloads()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"),
                                               object: nil,
                                               queue: nil) { _ in
            self.fetchLocalStorageForDownloads()
        }
    }
    
    private func setupTable() {
        downloadsTable.register(UINib(nibName: UpcomingTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
    }
    
    private func fetchLocalStorageForDownloads() {
        guard let viewModel = viewModel else { return }
        viewModel.localStorage { [ weak self ] in
            DispatchQueue.main.async {
                self?.downloadsTable.reloadData()
            }
        }
    }
    
    
    
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell, let viewModel = viewModel else { return UITableViewCell() }
        cell.configure(with: viewModel.addContent(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRow() ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel?.deleteRow(indexPath: indexPath, completion: {
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        viewModel.didSelecetRow(indexPath: indexPath) { [weak self] title, videoElement in
            DispatchQueue.main.async {
                let vc = TitlePreviewViewController()
                vc.configure(wirh: TitlePreviewViewModel(title: title.original_name ?? title.original_title ?? "",
                                                         youtubeView: videoElement,
                                                         titleOverview: title.overview ?? ""))
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
