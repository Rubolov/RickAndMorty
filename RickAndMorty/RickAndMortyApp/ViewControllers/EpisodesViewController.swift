//
//  EpisodesViewController.swift
//  RickAndMortyApp
//
//  Created by Yuriy Yakimenko on 18.12.2022.
//

import UIKit

class EpisodesViewController: UITableViewController {
    
    
    var character: Character!
    var episodes: [Episode] = []
    
    private let identifier = "episodesViewController"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episodes"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.rowHeight = 70
        
        tableView.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 0.7
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.barTintColor = .white
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        character.episode.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 0.7
        )
        
        var content = cell.defaultContentConfiguration()
        let episodeURL = character.episode[indexPath.row]
        content.textProperties.color = .white
        content.textProperties.font = UIFont.boldSystemFont(ofSize: 18)
        
        NetworkManager.shared.fetchEpisode(from: episodeURL) { result in
            switch result {
            case .success(let episode):
                self.episodes.append(episode)
                content.text = episode.name
                cell.contentConfiguration = content
            case .failure(let error):
                print(error)
            }
    }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        let episodeDetailsVC = EpisodeDetailsViewController()
        episodeDetailsVC.episode = episode
        navigationController?.pushViewController(episodeDetailsVC, animated: true)
    }}
