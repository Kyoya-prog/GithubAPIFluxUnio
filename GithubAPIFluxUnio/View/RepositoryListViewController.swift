import UIKit
import RxCocoa
import RxSwift

func void<T>(_: T) {}

final class RepositoryListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewStream.output.searchedRepositories.map(void).bind(to: Binder(repositoriesView){ tableView,_ in
            tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewStream.output.errorOccured.subscribe { errorString in
            self.presentErrorAlert(errorString)
        }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty.asDriver()){($0,$1)}.subscribe { [weak self] _, keyword in
            self?.viewStream.input.search.onNext(keyword)
            self?.searchBar.resignFirstResponder()
        }.disposed(by: disposeBag)



    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var repositoriesView:UITableView = {
        let view = UITableView()
        view.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.reuseIdentifier)
        view.dataSource = dataSource
        return view
    }()
    
    private let viewStream = RepositoryViewStream()
    
    private let searchBar = UISearchBar()
    
    private lazy var dataSource = RepositoryListTableDataSource(viewStream: viewStream)
    
    private let disposeBag = DisposeBag()
    
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
    
    private func presentErrorAlert(_ message: String){
        let alertController = UIAlertController(title: "検索失敗",
                                                message: message,
                                                preferredStyle: .alert)

        present(alertController, animated: true)
    }
}

