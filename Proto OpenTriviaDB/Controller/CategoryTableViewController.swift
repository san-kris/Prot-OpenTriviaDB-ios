//
//  CategoryTableViewController.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/13/23.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    var categories: [[String: Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let uiLabel = UILabel()
//        uiLabel.text = "Table Header"
//        let headerView = UIView()
//        headerView.addSubview(uiLabel )
//        // headerView.frame.size.height = tableView.frame.width
//        headerView.frame.size.height = 50
//        headerView.backgroundColor = .green
//        tableView.tableHeaderView = headerView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("in ViewWillAppear")
        categories = TriviaBrain.brain.getCatagories()
        
    }

    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        print("Add button pressed")
        print("Trivia Session ID \(TriviaBrain.brain.getSession() ?? "EMPTY")")
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 0
    }

    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TriviaCategooriesCell", for: indexPath)
        
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.image = UIImage(systemName: "brain.head.profile")
        cellConfiguration.text = categories?[indexPath.row]["title"] as? String ?? "Category Title Missing"
        cellConfiguration.secondaryText = categories?[indexPath.row]["subTitle"] as? String ?? "Category Sub-Title Missing"
        cellConfiguration.textProperties.color = .red
        cellConfiguration.secondaryTextProperties.color = .gray
        
        cell.contentConfiguration  = cellConfiguration

        return cell
    }
    



}
