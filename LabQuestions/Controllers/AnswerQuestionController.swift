//
//  AnswerQuestionController.swift
//  LabQuestions
//
//  Created by casandra grullon on 12/16/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class AnswerQuestionController: UIViewController {
    
    @IBOutlet weak var answerTextView: UITextView!
    
    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func postAnswer(_ sender: UIButton) {
        //disable button once they click it once
        sender.isEnabled = false
        guard let answerText = answerTextView.text,
            !answerText.isEmpty,
            let question = question else {
                showAlert(title: "Missing Fields", message: "Answer is required\n Fellow is waiting...")
                sender.isEnabled = true
                return
        }
        
        // create a PostedAnswer instance
        let postedAnswer = PostedAnswer(questionTitle: question.title, questionId: question.id, questionLabName: question.labName, answerDescription: answerText, createdAt: String.getISOTimestamp())
        
        LabQuestionsAPIClient.postAnswer(postedAnswer: postedAnswer) { [weak self, weak sender] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to Post Answer", message: "\(appError)")
                    sender?.isEnabled = true
                }
                
            case .success:
                DispatchQueue.main.async {
                    //if they were successful - the completion will take them back to the previous page.
                    self?.showAlert(title: "Answer Posted!", message: "Thank you for submitting an answer.") { alert in
                        self?.dismiss(animated: true)
                    }
                }
                
            }
            
        }
        
    }
}





