import UIKit

final class RepositoryListTableDataSource:NSObject, UITableViewDataSource{
    
    private let viewStream: RepositoryViewStreamProtocol

    init(viewStream: RepositoryViewStreamProtocol) {
        self.viewStream = viewStream
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewStream.output.searchedRepositories.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseIdentifier) as! RepositoryCell
        let repository = viewStream.output.searchedRepositories.value[indexPath.row]
        cell.configure(viewModel: .init(title: repository.name, description: repository.description ?? "", language: repository.language ?? "", authorName: repository.owner.login))
        return cell
    }
}
