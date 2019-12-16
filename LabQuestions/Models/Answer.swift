//
//  Answer.swift
//  LabQuestions
//
//  Created by casandra grullon on 12/16/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

//an "UPDATE" http method will be able to partial updates of an object
struct Answer: Decodable {
    let id: String
    let name: String
    let avatar: String
    let questionId: String
    let questionLabName: String
    let questionTitle: String
    let answerDescription: String
    let createdAt: String
}
