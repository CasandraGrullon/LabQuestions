//
//  CreateQuestionController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class CreateQuestionController: UIViewController {
    
    //this view controller is embedded to a navigation controller so that we have access to the navigation bar
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var labPickerView: UIPickerView!
    
    //data for our pickerView
    private let labs = ["Concurrency","Comic","Parsing JSON - Weather, Color, User","Images and Error Handeling","StocksPeople","Intro to Unit Testing - Jokes, Star Wars, Trivia"].sorted()
    
    //variable to keep track of the currently selected lab in picker
    private var labName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure the pickerView
        labPickerView.dataSource = self
        labPickerView.delegate = self
        labName = labs.first // setting picker default
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //want to change the color and border width of the textView
        //EVERY VIEW HAS A CALAYER!
        //semantic colors are new to iOS 13, adapt to light or dark mode
        //cg = core graphics : ca = core animation
        questionTextView.layer.borderColor = UIColor.systemGray.cgColor
        questionTextView.layer.borderWidth = 1
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func createQuestion(_ sender: UIBarButtonItem) {
        // 3 required parameters to create a PostedQuestion
        guard let questionTitle = titleTextField.text,
            !questionTitle.isEmpty,
            let labName = labName,
            let labDescription = questionTextView.text,
            !labDescription.isEmpty else {
                showAlert(title: "Missing Fields", message: "Title, Description are required")
                return
        }
        
        let question = PostedQuestion(title: questionTitle,
                                      labName: labName,
                                      description: labDescription,
                                      createdAt: String.getISOTimestamp())
        
        //POST question using APIClient
        LabQuestionsAPIClient.postQuestion(question: question) { [weak self] (result) in
            switch result{
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error posting question", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "\(questionTitle) was posted")
                }
            }
        }
    }
    
}
extension CreateQuestionController: UIPickerViewDataSource{
    //REQUIRED METHOD 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //1 component => one scrollerable feature
        return 1
    }
    //REQUIRED METHOD 2
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return labs.count
    }
}
extension CreateQuestionController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //only have one component - row
        //if it were multiple components, we need component and row
        return labs[row]
    }
}
