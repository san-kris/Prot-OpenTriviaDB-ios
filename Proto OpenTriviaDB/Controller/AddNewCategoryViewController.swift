//
//  AddNewCategoryViewController.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/18/23.
//

import UIKit

class AddNewCategoryViewController: UIViewController {
    
//    weak var delegate: AddNewCategoryViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // Create a new instance of navController and View Controller
    static func fromStoryboard() -> (addNewCategoryNavController: UINavigationController, addNewCategoryViewController: AddNewCategoryViewController){
        // Creates a new storyboard instance with name Main
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Create the navController with name "AddNewCategoryNavController"
        let navController = storyboard.instantiateViewController(withIdentifier: "AddNewCategoryNavController") as! UINavigationController
        let viewController = navController.viewControllers[0] as! AddNewCategoryViewController
        return (addNewCategoryNavController: navController, addNewCategoryViewController: viewController)
    }
    

    @IBAction func DoneButtonPressed(_ sender: UIBarButtonItem) {
        print("Done Btn pressed")
    }
    

    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        print("Cancel Btn pressed")
        navigationController?.dismiss(animated: true)
    }
}
