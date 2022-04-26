import UIKit

import UIKit

final class RepositoryCell:UITableViewCell{
    
    static let reuseIdentifier = "repository-cell"

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        descriptionLabel.text = ""
        languageLabel.text = ""
        authorNameLabel.text = ""
    }
    
    func configure(viewModel:RepositoryCellViewModel){
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        languageLabel.text = viewModel.language
        authorNameLabel.text = viewModel.authorName
    }
    
    private func setUpLayout(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 2
        contentView.addSubview(descriptionLabel)
        
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.font = UIFont.systemFont(ofSize: 15)
        languageLabel.textColor = .gray
        contentView.addSubview(languageLabel)
        
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.font = UIFont.systemFont(ofSize: 15)
        authorNameLabel.textColor = .gray
        authorNameLabel.textAlignment = .right
        contentView.addSubview(authorNameLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant:  -5),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant:  -5),
            
            languageLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 10),
            languageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 5),
            languageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            
            authorNameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 10),
            authorNameLabel.leftAnchor.constraint(equalTo: languageLabel.rightAnchor,constant: 15),
            authorNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -20),
            authorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let languageLabel = UILabel()
    private let authorNameLabel = UILabel()
}


struct RepositoryCellViewModel{
    let title:String
    
    let description:String
    
    let language:String
    
    let authorName:String
}
