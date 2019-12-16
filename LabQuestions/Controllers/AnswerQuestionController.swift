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
    
    @IBAction func postAnswer(_ sender: Any) {
        guard let answerText = answerTextView.text,
            !answerText.isEmpty,
            let question = question else {
            showAlert(title: "Missing Fields", message: "Answer is required")
            return
        }
        
        //created a PostedAnswer instance
        let postedAnswer = PostedAnswer(questionTitle: question.title, questionId: question.id, questionLabName: question.labName, answerDescription: answerText)
        
    }

    
    
    
}
