//
//  LabQuestionsTests.swift
//  LabQuestionsTests
//
//  Created by Alex Paul on 12/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
@testable import LabQuestions

struct CreatedLab: Codable {
  let title: String
  let createdAt: String
}

class LabQuestionsTests: XCTestCase {
  func testPostLabQuestion() {
    // arrange
    let title = "How do we get the flag image"
    let labName = "Concurrency Lab"
    let description = "Not able to use the svg url, what else can we do to get the image url"
    let createdAt = String.getISOTimestamp() //extension on String.
    
    let lab = PostedQuestion(title: title, labName: labName, description: description, createdAt: createdAt)
    
    let data = try! JSONEncoder().encode(lab)
    
    let exp = XCTestExpectation(description: "lab posted successfully")
    
    let url = URL(string: "https://5df04c1302b2d90014e1bd66.mockapi.io/questions")!
    
    //Post request steps
    //1. make request as usual
    var request = URLRequest(url: url)
    //2. HAVE to say if it is POST, automatically assigned GET
    request.httpMethod = "POST" //upload
    //3. we are sending data to our API
    request.httpBody = data
    //4. required to be valid JSON data being uploaded
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // act
    NetworkHelper.shared.performDataTask(with: request) { (result) in
      switch result {
      case .failure(let appError):
        XCTFail("failed with error: \(appError)")
      case .success(let data):
        // assert
        let createdlab = try! JSONDecoder().decode(CreatedLab.self, from: data)
        XCTAssertEqual(title, createdlab.title)
        exp.fulfill()
      }
    }
    
    wait(for: [exp], timeout: 5.0)
  }
}
