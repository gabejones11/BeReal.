//
//  FeedViewController.swift
//  BeReal
//
//  Created by Gabe Jones on 3/25/23.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController {
    
    //MARK: - UIComponents
    let tableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.backgroundColor = .black
        table.separatorStyle = .none
        return table
    }()

    private var posts = [Post]() {
        didSet {
            //reload the table view data any time the posts variable gets updated
            tableView.reloadData()
        }
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryPosts()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        //create a navigation bar appearance to stop color change on scroll
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                           .font: UIFont(name: "Arial-BoldMT", size: 25)!]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        //create navigation bar
        let navBar = UINavigationBar()

        //create navigation bar elements
        let navItem = UINavigationItem()
        
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonTapped))
        let postButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(postButtonTapped))
        
        logOutButton.tintColor = .white
        postButton.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = logOutButton
        self.navigationItem.rightBarButtonItem = postButton
        self.navigationItem.title = "BeReal."
        
        navBar.setItems([navItem], animated: false)
        
        view.addSubview(tableView)
        view.addSubview(navBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -45),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    //MARK: - Functions
    private func queryPosts() {
        //create a query to fetch posts
        //any properties that are parse objects are stored by reference -> 'include_:'
        //sort the posts be descending order based on created date
        // Get the date for yesterday. Adding (-1) day is equivalent to subtracting a day.
        // NOTE: `Date()` is the date and time of "right now".
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
        let query = Post.query()
            .include("user")
            .order([.descending("createdAt")])
            .where("createdAt" >= yesterdayDate) // <- Only include results created yesterday onwards
            .limit(10) // <- Limit max number of returned posts to 10
        
        //fetch posts defined in query
        query.find { [weak self] result in
            switch result {
            case .success(let posts):
                //update local posts property with fetched posts
                self?.posts = posts
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    @objc private func logOutButtonTapped() {
        showConfirmLogoutAlert()
    }
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of your account?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showAlert(description: String? = nil) {
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    @objc private func postButtonTapped() {
        navigationController?.pushViewController(PostViewController(), animated: true)
    }
    
}

//MARK: - Extensions
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifer)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifer, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        cell.backgroundColor = .black
        return cell
    }
}
