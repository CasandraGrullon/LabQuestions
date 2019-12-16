//
//  Question.swift
//  LabQuestions
//
//  Created by casandra grullon on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct Question: Decodable {
    let id: String
    let createdAt: String //date stamp
    let name: String //random user name
    let avatar: String //random image
    let title: String
    let description: String
    let labName: String
}

//user story = what the user can do. ex: User can add a lab question, or user can see a lab question.
