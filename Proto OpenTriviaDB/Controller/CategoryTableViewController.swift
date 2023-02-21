//
//  CategoryTableViewController.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/13/23.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    var userCategories: [[String: Any]]? {
        didSet{
            print("UserCategories updated. Updating table view")
            tableView.reloadData()
        }
    }
    
    lazy private var addNewCategory: (addNewCategoryNavController: UINavigationController, addNewCategoryViewController: AddNewCategoryViewController) = {
        // create new nav controller and VC fromo storyboard ID and set delegate
        return AddNewCategoryViewController.fromStoryboard(delegate: self)
    }()
    
    lazy private var triviaViewController: TriviaViewController = {
        return TriviaViewController.fromStoryboard()
    }()
    
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
        // categories = TriviaBrain.brain.getCatagories()
        userCategories = TriviaBrain.brain.getUserCategories()
    }

    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        print("Add button pressed")
        print("Trivia Session ID \(TriviaBrain.brain.getSession() ?? "EMPTY")")
        present(addNewCategory.addNewCategoryNavController, animated: true) {
            print("Navigated to Add New Screen from Cat List")
        }

        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userCategories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TriviaCategooriesCell", for: indexPath)
        
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.image = UIImage(systemName: userCategories?[indexPath.row]["image"] as? String ?? "brain.head.profile")
        cellConfiguration.text = userCategories?[indexPath.row]["title"] as? String ?? "Category Title Missing"
        cellConfiguration.secondaryText = userCategories?[indexPath.row]["subTitle"] as? String ?? "Category Sub-Title Missing"
        cellConfiguration.textProperties.color = .red
        cellConfiguration.secondaryTextProperties.color = .gray
        
        cell.contentConfiguration  = cellConfiguration
        
        return cell
    }


    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        
        triviaViewController.categoryImage = userCategories?[indexPath.row]["image"] as? String ?? "brain.head.profile"
        triviaViewController.categoryID = userCategories?[indexPath.row]["categoryID"] as? Int ?? 9
        triviaViewController.categoryDifficulty = userCategories?[indexPath.row]["difficulty"] as? String ?? "easy"
        triviaViewController.categoryName = userCategories?[indexPath.row]["title"] as? String ?? "General Knoowledge"
        
        navigationController?.pushViewController(triviaViewController, animated: true)
    }
}

extension CategoryTableViewController: AddNewCategoryViewControllerDelegate{
    func didAddCategory(_ controller: AddNewCategoryViewController, category: String?, difficulty: String?) {
        // Do nothing if either category or difficulty is blank
        guard let category, let difficulty else {return}
        print("Add New Cat Delegate called with \(category) and \(difficulty)")
        // Add new Category and difficulty level in storage and update the Dict
        let userCategories = TriviaBrain.brain.addNewCategory(category: category, difficulty: difficulty)
        if let userCategories{
            self.userCategories = userCategories
        }
    }
    
    
}

