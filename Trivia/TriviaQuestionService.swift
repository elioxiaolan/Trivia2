//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Xiao Lan on 10/13/23.
//

import Foundation

class TriviaQuestionService {
  let apiURL = "https://opentdb.com/api.php?amount=5&difficulty=easy"
  
  func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
      guard let url = URL(string: apiURL) else {
          completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
          return
      }

      URLSession.shared.dataTask(with: url) { data, response, error in
          if let error = error {
              completion(nil, error)
              return
          }

          if let data = data {
              do {
                  let decoder = JSONDecoder()
                  let triviaResponse = try decoder.decode(TriviaQuestionsResponse.self, from: data)
                    let triviaQuestions = triviaResponse.results
                    completion(triviaQuestions, nil)
              } catch {
                  completion(nil, error)
              }
          }
      }.resume()
  }
}

