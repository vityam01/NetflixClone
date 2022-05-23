//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Vitya Mandryk on 15.05.2022.
//

import UIKit



final class HomeViewController: UIViewController {
    
    //MARK: IBOutlets
       
    @IBOutlet weak private var mainTableView: UITableView!
    
    
    //MARK: Variables/ Constants
    private var randomTrendingMovie: Title?
    private var headerView: HeaderTableView?
    private var viewModel: HomeViewModel?
    
    
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        initUI()
    }
    
    //MARK: Private methods
    private func initUI() {
        viewModel = HomeViewModel()
        configureTableView()
        configureNavBar()
        titleCell()
        configureHeaderView()
    }
    
    private func configureTableView() {
        mainTableView.register(UINib(nibName: CollectionTableViewCell.identifier,
                                     bundle: nil),
                               forCellReuseIdentifier: CollectionTableViewCell.identifier)
        mainTableView.register(UINib(nibName: HeaderTableView.identifier,
                                     bundle: nil),
                               forHeaderFooterViewReuseIdentifier: HeaderTableView.identifier)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        self.navigationController?.tabBarItem.title = LocalizationKeys.Bar.ItemsName.home.rawValue.localized
    }
    
 
    
    private func titleCell() {
        guard let viewModel = viewModel else { return }

        headerView = HeaderTableView(frame: CGRect(x: viewModel.cgRectForXandY(),
                                                   y: viewModel.cgRectForXandY(),
                                                   width: view.bounds.width,
                                                   height: viewModel.heighForView()))
        mainTableView.tableHeaderView = headerView
    }
    
    
    private func configureHeaderView() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedItem = titles.randomElement()
                self?.randomTrendingMovie = selectedItem
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedItem?.original_title ?? "",
                                                                 posterURL: selectedItem?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar() {
        guard let viewModel = viewModel else { return }

        var image = UIImage(named: viewModel.netflixImage )
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .done,
                                                           target: self,
                                                           action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: viewModel.personImage ),
                            style: .done,
                            target: self,
                            action: nil),
            UIBarButtonItem(image: UIImage(systemName: viewModel.playImage),
                            style: .done,
                            target: self,
                            action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }

}

    //MARK: TableView Extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier,
                                                       for: indexPath) as? CollectionTableViewCell,
                                                       let viewModel = viewModel else { return UITableViewCell() }
        cell.delegate = self
        viewModel.contentForCell(indexPath: indexPath) { [weak cell] result in
            cell?.configure(with: result)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRowAt() ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel?.heightForHeaderInSection() ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20,
                                         y: header.bounds.origin.y,
                                         width: 100,
                                         height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleForHeaderInSection(section: section)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}


extension HomeViewController: CollectionTableViewCellDelegate {
    func collectionTableViewCellDidTappedCell(_ cell: CollectionTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [ weak self ] in
            let vc = TitlePreviewViewController()
            vc.configure(wirh: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    
}
