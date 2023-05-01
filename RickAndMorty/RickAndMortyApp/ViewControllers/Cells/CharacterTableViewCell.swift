//
//  CharacterTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Yuriy Yakimenko on 18.12.2022.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    static let identifier = "CharacterTableViewCell"
    
   
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.color = .white
        activity.startAnimating()
        activity.hidesWhenStopped = true
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
   
    
    private var imageURL: URL? {
        didSet {
            characterImageView.image = nil
            updateImage()
        }
    }
    
    
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(characterImageView)
        addSubview(nameLabel)
        characterImageView.addSubview(activityIndicator)
        setConstraints()
 }
   
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        characterImageView.layer.cornerRadius = characterImageView.frame.height / 2
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
  
    
    func configure(with character: Character?) {
        nameLabel.text = character?.name ?? ""
        imageURL = URL(string: character?.image ?? "")
    }
  
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        getImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                if imageURL == self.imageURL {
                    self.characterImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error)
    }
        }}
  
    
   
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        
        if let cacheImage = ImageCache.shared.object(forKey: url.lastPathComponent as NSString) {
            
            completion(.success(cacheImage))
            return
            
        }
  
        
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                ImageCache.shared.setObject(image, forKey: url.lastPathComponent as NSString)
               
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }}
}


extension CharacterTableViewCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5),
            characterImageView.widthAnchor.constraint(equalToConstant: 50),
            characterImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: characterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor)
        ])
        
}
}
