//
//  PostedAnswer.swift
//  LabQuestions
//
//  Created by casandra grullon on 12/16/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation


struct PostedAnswer: Encodable {
  let questionTitle: String
  let questionId: String // for searching all answers to a question
  let questionLabName: String
  let answerDescription: String
  let createdAt: String // timestamp of the created date of the Question
}
