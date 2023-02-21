//
//  AddNewCategoryViewController.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/18/23.
//

import UIKit

class AddNewCategoryViewController: UIViewController{
    
    weak var delegate: AddNewCategoryViewControllerDelegate?
    
    // Create a new instance of navController and View Controller
    static func fromStoryboard(delegate: AddNewCategoryViewControllerDelegate? = nil) -> (addNewCategoryNavController: UINavigationController, addNewCategoryViewController: AddNewCategoryViewController){
        // Creates a new storyboard instance with name Main
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Create the navController with name "AddNewCategoryNavController"
        let navController = storyboard.instantiateViewController(withIdentifier: "AddNewCategoryNavController") as! UINavigationController
        // get the first View Controller in the stack
        let viewController = navController.viewControllers.first as! AddNewCategoryViewController
        // set the delegate of view controller
        viewController.delegate = delegate
        
        return (addNewCategoryNavController: navController, addNewCategoryViewController: viewController)
    }
    
    @IBOutlet weak var categoryTextField: UITextField! {
        didSet{
            categoryTextField.text = TriviaDBCategories.getAllCategories()?.first
            categoryTextField.inputView = categoryPicker
        }
    }
    @IBOutlet weak var difficultyTextField: UITextField! {
        didSet{
            difficultyTextField.text = CategoryBrain.difficultyOptions[0]
            difficultyTextField.inputView = difficultyPicker
        }
    }
    
    lazy private var categoryPicker: UIPickerView = {
        let newPicker = UIPickerView()
        newPicker.dataSource = self
        newPicker.delegate = self
        return newPicker
    }()
    
    lazy private var difficultyPicker: UIPickerView = {
        let newPicker = UIPickerView()
        newPicker.dataSource = self
        newPicker.delegate = self
        return newPicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func DoneButtonPressed(_ sender: UIBarButtonItem) {
        print("Done Btn pressed")
        navigationController?.dismiss(animated: true)
        delegate?.didAddCategory(self, category: categoryTextField.text, difficulty: difficultyTextField.text)
    }
    

    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        print("Cancel Btn pressed")
        navigationController?.dismiss(animated: true)
    }
    
}

extension AddNewCategoryViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView{
        case categoryPicker: return TriviaDBCategories.categoryOptions.count
        case difficultyPicker: return CategoryBrain.difficultyOptions.count
        default: fatalError("Unknown picker view")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView{
        case categoryPicker:
            if let categories = TriviaDBCategories.getAllCategories(){
                return categories[row]
            }
            return "No Category Found"
        case difficultyPicker:
            return CategoryBrain.difficultyOptions[row]
        default: fatalError("Unknown picker view")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView{
        case categoryPicker:
            if let categories = TriviaDBCategories.getAllCategories(){
                categoryTextField.text = categories[row]
            }
        case difficultyPicker:
            difficultyTextField.text =  CategoryBrain.difficultyOptions[row]
        default: fatalError("Unknown picker view")
        }
    }
}

protocol AddNewCategoryViewControllerDelegate: AnyObject{
    func didAddCategory(_ controller: AddNewCategoryViewController, category: String?, difficulty: String?) -> Void
}
