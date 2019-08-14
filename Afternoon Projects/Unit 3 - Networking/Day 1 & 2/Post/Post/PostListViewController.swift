//
//  PostListViewController.swift
//  Post
//
//  Created by Sam LoBue on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {

    @IBOutlet weak var postTableViewOutlet: UITableView!
    
    // TAke out shared instance and replace with postController.
    var postController = PostController()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        postTableViewOutlet.refreshControl = refreshControl
        
        postTableViewOutlet.estimatedRowHeight = 45
        postTableViewOutlet.rowHeight = UITableView.automaticDimension
        postTableViewOutlet.delegate = self
        postTableViewOutlet.dataSource = self
        
//        PostController.sharedInstance.fetchPosts {
        postController.fetchPosts {

            DispatchQueue.main.async {
                
                
//                self.postTableViewOutlet.reloadData()
//                self.refreshControlPulled()
                self.reloadTableView()
            }

        }
    }
    
    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: Any) {
        presentNewPostAlert()
    }
    
    // MARK: - Methods
    
    @objc func refreshControlPulled() {
        
        postController.fetchPosts {
//        PostController.sharedInstance.fetchPosts {
            DispatchQueue.main.async {
//                self.refreshControl.endRefreshing()
//                self.postTableViewOutlet.refreshControl?.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.refreshControl.endRefreshing()
                
//                self.reloadTableView()
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.postTableViewOutlet.reloadData()
//            self.reloadTableView()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    func presentNewPostAlert() {
        
        let alert = UIAlertController(title: "Hello", message: "Add your username and message below.", preferredStyle: .alert)
        
        
        
        let alertAction = UIAlertAction(title: "Submit your post", style: .default) { (_) in
            guard let message = (alert.textFields![0] as UITextField).text,
                let username = (alert.textFields![1] as UITextField).text,
                !message.isEmpty,
                !username.isEmpty else {
                    // error
                    self.presentErrorAlert()
                    return
            }
            
            self.postController.addNewPostWith(username: username, text: message, completion: {
            
//            PostController.sharedInstance.addNewPostWith(username: username, text: message, completion: {
                DispatchQueue.main.async {
                    
                    self.reloadTableView()
                }
            })
        }
        
        alert.addAction(alertAction)
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Username"
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Message"
        }
        present(alert, animated: true, completion: nil)
//        reloadTableView()
    }
    
    func presentErrorAlert() {
        let alert = UIAlertController(title: "Ooops", message: "You need a valid username and complete message", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            self.presentNewPostAlert() })
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return PostController.sharedInstance.posts.count
        return postController.posts.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)

//        let post = PostController.sharedInstance.posts[indexPath.row]
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = post.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row > (PostController.sharedInstance.posts.count - 1) {
//            PostController.sharedInstance.fetchPosts(reset: false) {
//                self.reloadTableView()
//            }
        if indexPath.row > (postController.posts.count - 1) {
            postController.fetchPosts(reset: false) {
                self.reloadTableView()
            }
        }
        return
    }
    
}


