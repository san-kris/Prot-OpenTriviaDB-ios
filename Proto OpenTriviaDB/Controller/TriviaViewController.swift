//
//  ViewController.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/11/23.
//

import UIKit

class TriviaViewController: UIViewController {
    
    var categoryID: Int?
    var categoryName: String?
    var categoryDifficulty: String?
    var categoryImage: String?
    
    private var triviaQuestions: Trivia? {
        didSet{
            if let triviaQuestions{
                self.totalQuestions = triviaQuestions.questions.count
            }
        }
    }
    private var totalQuestions: Int = 0
    private var answerChoices: [String]?
    private var correctAnswer: String?
    private var currentQuestion: String?
    private var currentQuestionIndex: Int? {
        didSet{
            if let triviaQuestions, let currentQuestionIndex{
                if currentQuestionIndex <= 0{
                    self.currentQuestionIndex = 0
                    DispatchQueue.main.async {
                        self.previousButton.isHidden = true
                    }
                } else if currentQuestionIndex >= totalQuestions-1{
                    self.currentQuestionIndex = totalQuestions-1
                    DispatchQueue.main.async {
                        self.nextButton.isHidden = true
                    }
                    
                } else{
                    DispatchQueue.main.async {
                        self.previousButton.isHidden = false
                        self.nextButton.isHidden = false
                    }
                }
                if currentQuestionIndex < totalQuestions{
                    DispatchQueue.main.async {
                        self.currentQuestion = String(htmlEncodedString: triviaQuestions.questions[currentQuestionIndex].q)
//                        print("string conversion before: \(triviaQuestions.questions[currentQuestionIndex].q) \n after: \(self.currentQuestion ?? "DEFAULT")")
                        self.answerChoices = triviaQuestions.questions[currentQuestionIndex].otherChoices.compactMap ({ choice in
                            String(htmlEncodedString: choice)
                        })
                        if let answer = String(htmlEncodedString: triviaQuestions.questions[currentQuestionIndex].ans){
                            self.correctAnswer = answer
                            self.answerChoices?.append( answer)
                        } else{
                            self.correctAnswer = triviaQuestions.questions[currentQuestionIndex].ans
                            self.answerChoices?.append(triviaQuestions.questions[currentQuestionIndex].ans)
                        }
                        
                        self.answerChoices?.shuffle()
                        
                        print("Question index changed. Update Table")
                        self.loadingView.isHidden = true
                        self.loadingSpinner.stopAnimating()
                        
                        self.questionCountLabel.text = "\((self.currentQuestionIndex ?? 0) + 1) of \(self.totalQuestions)"
                        self.tableView.reloadData()

                    }
                } else {

                    //TODO: - need to handle end of questions list
                    print("End of questions reached. Handle it")
                }
            } else{
                print("Trivia object is nil")
            }
        }
    }
    
    @IBOutlet weak var triviaImage: UIImageView!
    @IBOutlet weak var triviaTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var triviaSubTitleLabel: UILabel!
    @IBOutlet weak var questionView: TriviaTableHeaderView!
    @IBOutlet weak var questionCountLabel: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    static func fromStoryboard() -> TriviaViewController{
        // Creates a new storyboard instance with name Main
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Create the navController with name "AddNewCategoryNavController"
        let viewController = storyboard.instantiateViewController(withIdentifier: "TriviaViewController") as! TriviaViewController
        
        return viewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadingView.isHidden = false
        loadingSpinner.startAnimating()
        
        if let categoryImage,  let categoryName, let categoryDifficulty{
            triviaImage.image = UIImage(systemName: categoryImage)
            triviaTitleLabel.text = categoryName
            triviaSubTitleLabel.text = categoryDifficulty
        }
        tableView.dataSource = self
        tableView.delegate = self
        
        getTriviaQuestions()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("View DidDisappear called")
        triviaQuestions = nil
        currentQuestion = nil
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.currentQuestionIndex = self.currentQuestionIndex! + 1
    }
    
    @IBAction func previousButtonPressed(_ sender: UIButton) {
            self.currentQuestionIndex = self.currentQuestionIndex! - 1
    }
    
    
    
    private func getTriviaQuestions() -> Void {
        let urlParameters: [String: String] = [
            "amount": String(Constant.TriviaQuestion.defaultQuestionCount),
            "category": String(categoryID ?? Constant.TriviaQuestion.defaultCategory) ,
            "difficulty": (categoryDifficulty ?? Constant.TriviaQuestion.defaultDifficulty).lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        TriviaDBConnection.getData(url: Constant.TriviaQuestion.questionListURL, parameters: urlParameters) { (data, response, error) in
            if let error{
                print("Error during API call: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                print("Server Returned Error Code")
                return
            }
                    
            if let data{
    //            let responseData = String(data: data, encoding: String.Encoding.utf8)
    //            debugPrint("Data - \(responseData)")
                
//                print("Response - \(httpResponse.allHeaderFields)")
                
                let trivia = self.decodeJSON(data)
                
                if let trivia{
                    if trivia.responseCode == 0{
                        self.triviaQuestions = trivia
                        self.currentQuestionIndex = 0
                    } else {
                        self.triviaQuestions = nil
                        self.currentQuestionIndex = nil
                    }
                }
                
                
                
            }
        }
    }

    private func decodeJSON(_ data: Data) -> Trivia? {
        // 1. create instance of JSON decoder
        let decoder = JSONDecoder()
        
        do{
            // 2. decode JSON
            let trivia = try decoder.decode(Trivia.self, from: data)
            return trivia

        } catch {
            print("JSON Decode error: \(error)")
        }
        return nil
        
    }

    
}

//MARK: - UITableViewDataSource
extension TriviaViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let currentQuestion{
            questionView.questionLabel.text = currentQuestion
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let answerChoices{
            return answerChoices.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TriviaTableCell", for: indexPath) as? TriviaTableCell
        if let answerChoices{
            cell?.answerOptionLabel.text = answerChoices[indexPath.row]
            cell?.contentView.backgroundColor = .white
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("delegate called")
        tableView.deselectRow(at: indexPath, animated: true)
        if let optionSelected = answerChoices?[indexPath.row]{
            print("Selected optoin: \(optionSelected); correct answer: \(correctAnswer ?? "NO ANSWER")")
            let cell = tableView.cellForRow(at: indexPath) as? TriviaTableCell
            if optionSelected == correctAnswer{
                cell?.contentView.backgroundColor = .green
            } else{
                cell?.contentView.backgroundColor = .red
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    cell?.contentView.backgroundColor = .white
                }
            }
        }
    }
    
}

class TriviaTableHeaderView: UIView {
    
    @IBOutlet weak var questionLabel: UILabel!
    
}


class TriviaTableCell: UITableViewCell{
    
    @IBOutlet weak var answerOptionLabel: UILabel!
    
}


