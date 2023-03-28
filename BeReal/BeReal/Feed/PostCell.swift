//
//  PostCell.swift
//  BeReal
//
//  Created by Gabe Jones on 3/26/23.
//

import UIKit
import Alamofire
import AlamofireImage

class PostCell: UITableViewCell {
    
    static let identifer = "PostCell"
    
    //MARK: - UIComponents
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    let postImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private var imageDataRequest: DataRequest?
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupUI
    func setupUI() {
        contentView.addSubview(userNameLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(captionLabel)
        contentView.addSubview(dateLabel)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            postImageView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            postImageView.heightAnchor.constraint(equalToConstant: screenWidth * 1.3),
            postImageView.widthAnchor.constraint(equalToConstant: screenWidth),
            
            captionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 5),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    //MARK: - Functions
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //reset image view image
        postImageView.image = nil
        
        //cancel image request
        imageDataRequest?.cancel()
    }
    
    func configure(with post: Post){
        //username
        if let user = post.user {
            userNameLabel.text = user.username
        }
        
        //image
        if let imageFile = post.imageFile,
           let imageURL = imageFile.url {
            
            //use AlamofireImage helper to fetch remote image from URL
            imageDataRequest = AF.request(imageURL).responseImage { [weak self]
                response in
                switch response.result {
                case .success(let image):
                    
                    //set the image with the fetched image
                    self?.postImageView.image = image
                case .failure(let error):
                    print("Error fetching image: \(error.localizedDescription)")
                    break
                }
            }
        }
        
        //caption
        captionLabel.text = post.caption
        
        //date
        if let date = post.createdAt {
            dateLabel.text = DateFormatter.postFormatter.string(from: date)
        }
    }

}
