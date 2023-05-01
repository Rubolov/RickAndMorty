//
//  EpisodeDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Yuriy Yakimenko on 18.12.2022.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {
    
    
    var episode: Episode!
    
    
    private var characters: [Character] = [] {
        didSet {
            if characters.count == episode.characters.count {
                characters = characters.sorted { $0.id < $1.id}
        }
    }
    }
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Kefa Regular", size: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCharacters()
        
        view.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        
        title = episode.episode
        descriptionLabel.text = episode.description
        
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        
        setupViews()
        setConstraints()
}
    
    
    private func setupViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(characterLabel)
        view.addSubview(tableView)
    }
    
    
    private func setCharacters() {
        episode.characters.forEach { characterURL in
            NetworkManager.shared.fetchCharacter(from: characterURL) { result in
                switch result {
                case .success(let character):
                    self.characters.append(character)
                case .failure(let error):
                    print(error)
        }
}
}
    }}


extension EpisodeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episode.characters.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 0.7
        )
        
        let characterURL = episode.characters[indexPath.row]
        NetworkManager.shared.fetchCharacter(from: characterURL) { character in
            switch character {
            case .success(let character):
                cell.configure(with: character)
            case .failure(let error):
                print(error.localizedDescription)
            }
    }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        let characterDetailsVC = CharacterInfoViewController()
        
        characterDetailsVC.character = character
        navigationController?.pushViewController(characterDetailsVC, animated: true)
    }
}


extension EpisodeDetailsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            characterLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60),
            characterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: characterLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }}
