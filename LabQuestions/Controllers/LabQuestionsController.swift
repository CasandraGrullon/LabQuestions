//
//  ViewController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class LabQuestionsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    private var questions = [Question](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadQuestions()
        configureRefreshControl()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let questionDetailVC = segue.destination as? QuestionDetailController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("segue issue")
        }
        let questionPicked = questions[indexPath.row]
        questionDetailVC.question = questionPicked
    }
    
    func configureRefreshControl(){
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        //programmable target action using objective-c runtime api
        refreshControl.addTarget(self, action: #selector(loadQuestions), for: .valueChanged)
    }
    //loadQuestions is now using objective c runtime
    @objc
    private func loadQuestions(){
        LabQuestionsAPIClient.fetchQuestions { [weak self] (result) in
            //stop the refresh control from running once the completion handler returns
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            
            switch result{
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let questions):
                //sort by most recent
                self?.questions = questions.sorted { $0.createdAt.isoStringToDate() > $1.createdAt.isoStringToDate() }
                DispatchQueue.main.async {
                    self?.navigationItem.title = "Lab Questions - (\(questions.count))"
                }
            }
        }
    }
    
}

extension LabQuestionsController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        let question = questions[indexPath.row]
        
        cell.textLabel?.text = question.title
        cell.detailTextLabel?.text = question.createdAt.convertISODate() + " - \(question.labName)"
        
        return cell
    }
}
