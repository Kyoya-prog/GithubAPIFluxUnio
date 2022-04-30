import UIKit
import RxCocoa
import RxSwift

final class RepositoryListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewStream.output.repositories.map(void).bind(to: Binder(repositoriesView){ tableView,_ in
            tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewStream.output.errorOccurred.subscribe { errorString in
            self.presentErrorAlert(errorString)
        }.disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty.asDriver()){($0,$1)}.subscribe { [weak self] _, keyword in
            self?.viewStream.input.search.onNext(keyword)
            self?.searchBar.resignFirstResponder()
        }.disposed(by: disposeBag)

        viewStream.output.shouldSearchRepositories.bind(to: Binder(self){[weak self] _,_  in
            self?.indicator.startAnimating()
        }).disposed(by: disposeBag)
        
        viewStream.output.didEndSearchRepositories.bind(to: Binder(self){[weak self]_,_ in
            self?.indicator.stopAnimating()
        }).disposed(by: disposeBag)
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
    
    private let indicator = UIActivityIndicatorView()
    
    private lazy var dataSource = RepositoryListTableDataSource(viewStream: viewStream)
    
    private let disposeBag = DisposeBag()
    
    private func setUpLayout(){
        view.backgroundColor = .white
        
        self.navigationItem.titleView = searchBar
        
        repositoriesView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(repositoriesView)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            repositoriesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            repositoriesView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            repositoriesView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            repositoriesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func presentErrorAlert(_ message: String){
        let alertController = UIAlertController(title: "検索失敗",
                                                message: message,
                                                preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "閉じる", style: .cancel) {_ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(closeAction)
        present(alertController, animated: true)
    }
}

