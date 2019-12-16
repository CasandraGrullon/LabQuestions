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
    
    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
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
