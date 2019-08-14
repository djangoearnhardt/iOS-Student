//
//  StateListTableViewController.swift
//  WhyiOS
//
//  Created by Sam LoBue on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateListTableViewController: UITableViewController {

    var toBeSent: [Representative]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return States.all.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)

        cell.textLabel?.text = States.all[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = States.all[indexPath.row]
        getRepresentatives(state: state)
    }
    
    func getRepresentatives(state: String) {
        RepresentativeController.searchRepresentatives(forState: state) { (representative) in
            
            self.toBeSent = representative
            
            DispatchQueue.main.async {
                
                // calls prepare for segue
                self.performSegue(withIdentifier: "toDetailView", sender: self)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // IIDOO
        guard toBeSent != nil else { return }
        
        if segue.identifier == "toDetailView" {
            
            guard let destinationVC = segue.destination as? StateDetailTableViewController else { return }
           
            destinationVC.landingPad = toBeSent
        }
        
        
    }
    

}
