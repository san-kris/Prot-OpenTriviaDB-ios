//
//  ViewController.swift
//  Proto OpenTriviaDB
//
//  Created by Santosh Krishnamurthy on 2/11/23.
//

import UIKit

class TriviaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func readPressed(_ sender: UIButton) {
        print("Read button pressed")
        getTriviaQuestions()
        
    }
}

func getTriviaQuestions() -> Void {
    let urlAPI = "https://opentdb.com/api.php?amount=10&category=9&difficulty=easy&type=multiplex"
    
    // 1. create URL object
    let url = URL(string: urlAPI)
    print(url?.path(percentEncoded: true))
    
    // 2. create a task with shared session object
    guard let url else {return}
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
            
            print("Response - \(httpResponse.allHeaderFields)")
            
            let trivia = decodeJSON(data)
            
        }

        
    }

    // 4. start task
    task.resume()
}

func decodeJSON(_ data: Data) -> Trivia? {
    // 1. create instance of JSON decoder
    let decoder = JSONDecoder()
    
    do{
        // 2. decode JSON
        let trivia = try decoder.decode(Trivia.self, from: data)
        return trivia

    } catch {
        print("Decode error: \(error)")
    }
    return nil
    
}
