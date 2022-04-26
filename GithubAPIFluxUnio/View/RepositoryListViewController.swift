import UIKit

final class RepositoryListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    private lazy var repositoriesView:UITableView = {
        let view = UITableView()
        view.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseIdentifier)
        view.dataSource = dataSource
        return view
    }()
    
    private let searchBar = UISearchBar()
    
    private let dataSource = RepositoryListTableDataSource()
    
    private func setUpLayout(){
        view.backgroundColor = .white
        
        self.navigationItem.titleView = searchBar
        
        repositoriesView.translatesAutoresizingMaskIntoConstraints = false
        repositoriesView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseIdentifier)
        repositoriesView.reloadData()
        view.addSubview(repositoriesView)
        
        NSLayoutConstraint.activate([
            repositoriesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            repositoriesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            repositoriesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            repositoriesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

