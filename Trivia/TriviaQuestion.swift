//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion: Codable {
  let category: String
  let question: String
  let type: String
  let correct_answer: String
  let incorrect_answers: [String]
}
