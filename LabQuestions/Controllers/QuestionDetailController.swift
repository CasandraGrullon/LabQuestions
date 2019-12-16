//
//  QuestionDetailController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class QuestionDetailController: UIViewController {
  
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var labNameLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //we have two segues in one viewcontroller - so we need to give the segue an identifier
        if segue.identifier == "showAnswerQuestion" {
            //we are segueing to another Navigation Controller
            //we need to first segue to it then connect to its viewController.
            guard let navController = segue.destination as? UINavigationController,
                let answerQuestionVC = navController.viewControllers.first as? AnswerQuestionController  else {
                fatalError("could not downcast to AnswerQuestionController")
            }
            answerQuestionVC.question = question
        } else if segue.identifier == "showAnswers" {
            guard let answersVC = segue.destination as? AnswersViewController else {
                fatalError("could not downcast to AnswersVC")
            }
            answersVC.question = question
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
    }
    
    //if no one outside this view controller needs this function - make it private
    private func updateUI(){
        guard let question = question else {
            fatalError("could not update UI - verify question got set in prepare for segue")
        }
        labNameLabel.text = question.labName
        questionTextView.text = question.description
        questionTitleLabel.text = question.title
        
        userImageView.getImage(with: question.avatar) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.userImageView.image = UIImage(systemName: "person.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.userImageView.image = image
                }
            }
        }
        
        
    }
    
    
}
