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
    
    let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView()
        return blurView
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
        contentView.addSubview(blurView)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            postImageView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            postImageView.heightAnchor.constraint(equalToConstant: screenWidth),
            postImageView.widthAnchor.constraint(equalToConstant: screenWidth),
            
            captionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 5),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            blurView.topAnchor.constraint(equalTo: postImageView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor),
            blurView.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor),
            blurView.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor)
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
        
        // A lot of the following returns optional values so we'll unwrap them all together in one big `if let`
        // Get the current user.
        if let currentUser = User.current,

            // Get the date the user last shared a post (cast to Date).
           let lastPostedDate = currentUser.lastPostedDate,

            // Get the date the given post was created.
           let postCreatedDate = post.createdAt,

            // Get the difference in hours between when the given post was created and the current user last posted.
           let diffHours = Calendar.current.dateComponents([.hour], from: postCreatedDate, to: lastPostedDate).hour {

            // Hide the blur view if the given post was created within 24 hours of the current user's last post. (before or after)
            blurView.isHidden = abs(diffHours) < 24
        } else {

            // Default to blur if we can't get or compute the date's above for some reason.
            blurView.isHidden = false
            blurView.effect = UIBlurEffect(style: .regular)
        }
    }

}
