//
//  LabQuestionsAPIClient.swift
//  LabQuestions
//
//  Created by casandra grullon on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct LabQuestionsAPIClient {
    
    static func fetchQuestions(completion: @escaping (Result<[Question], AppError>) -> ()){
        
        let labEndpointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
        
        guard let url = URL(string: labEndpointURLString) else {
            completion(.failure(.badURL(labEndpointURLString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        //set the http method (GET, POST, DELETE, PUT, UPDATE)
        //by default we are "GET"
        
        //FOR POST REQUEST
        //request.httpMethod = "POST"
        //request.httpBody = data
        //******REQUIRED********
        //inform the post request of the data type. without providing the header value as "application/json" we will get a decoding error when attempting to decode the JSON
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                //construct our [Question] array
                
                do{
                    //for POST need JSONEncoder()
                    let questions = try JSONDecoder().decode([Question].self, from: data)
                    completion(.success(questions))
                }catch{
                    completion(.failure(.decodingError(error)))
                }
                
            }
        }
    }
    
    static func postQuestion(question: PostedQuestion, completion: @escaping (Result<Bool, AppError>) -> ()) {
        
        let endpointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
        
        guard let url = URL(string: endpointURLString) else {
            completion(.failure(.badURL(endpointURLString)))
            return
        }
        
        //convert PostedQuestion to Data
        do {
            let data = try JSONEncoder().encode(question)
            
            //configure to URLRequest
            var request = URLRequest(url: url)
            //type of http method
            request.httpMethod = "POST"
            // type of data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // provide data being sent to api
            request.httpBody = data
            
            //execute POST request
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
            
        } catch {
            completion(.failure(.encodingError(error)))
        }
    }
    
    // making a POST request - to send an answer to the Web API
    static func postAnswer(postedAnswer: PostedAnswer) {
        
        let answerEndpointString = "https://5df04c1302b2d90014e1bd66.mockapi.io/answers"
        
        guard let url = URL(string: answerEndpointString) else {
            return
        }
        
        //Steps to make a POST request
        //before anything -- we need to put everything in a do/catch because converting to data throws an error
        
        //1. convert Swift model to Data --> by using JSONEncoder()
        do{
            let data = try JSONEncoder().encode(postedAnswer)
            
            //2. Create a mutable URLRequest and assign it to the endpoint URL
            var request = URLRequest(url: url)
            
            //3: Tell Web API the type of data being sent
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //4. Use httpBody on request to add the data created from Swift model. --> This is the data we are sending to the Web API
            /*
             Example of the body:
             {
                 "id": "12",
                 "createdAt": "2019-12-14T16:12:40.407Z",
                 "name": "Donald King IV",
                 "avatar": "https://s3.amazonaws.com/uifaces/faces/twitter/enda/128.jpg",
                 "questionId": "77",
                 "questionLabName": "Comic",
                 "questionTitle": "Are you scared for Friday the 13th?",
                 "answerDescription": "I was born on Friday the 13th bruh hahaha"
             }
             */
            request.httpBody = data
            
            //5. Clarify that the httpMethod is POST --> by default its GET
            request.httpMethod = "POST"
            
            //use NetworkHelper ==> (URLSession wrap up class) to make the network POST request
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                <#code#>
            }
            
        }catch{
            
        }
        
    }
    
    //making a GET request - to get answers from the Web API
    static func fetchAnswers() {
        
    }
    
}
