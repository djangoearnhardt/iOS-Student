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
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        postTableViewOutlet.refreshControl = refreshControl
        
        postTableViewOutlet.estimatedRowHeight = 45
        postTableViewOutlet.rowHeight = UITableView.automaticDimension
        postTableViewOutlet.delegate = self
        postTableViewOutlet.dataSource = self
        
        PostController.sharedInstance.fetchPosts { 

            DispatchQueue.main.async {
                
                
                self.postTableViewOutlet.reloadData()
                self.refreshControlPulled()
                self.reloadTableView()
            }

        }
    }
    
    // MARK: - Methods
    
    @objc func refreshControlPulled() {
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        PostController.sharedInstance.fetchPosts {
            DispatchQueue.main.async {
//                self.refreshControl.endRefreshing()
//                self.postTableViewOutlet.refreshControl?.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.postTableViewOutlet.refreshControl?.endRefreshing()
                
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.sharedInstance.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)

        let post = PostController.sharedInstance.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = post.username
        return cell
    }
    
}
