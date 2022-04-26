import UIKit

final class RepositoryListTableDataSource:NSObject, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.reuseIdentifier) as! RepositoryCell
        cell.configure(viewModel: .init(title: "title", description: "description", language: "language", authorName: "author"))
        return cell
    }
}
