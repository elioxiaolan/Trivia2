//
//  ViewController.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
  private var questions = [TriviaQuestion]()
  private var currQuestionIndex = 0
  private var numCorrectQuestions = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addGradient()
    questionContainerView.layer.cornerRadius = 8.0
    // TODO: FETCH TRIVIA QUESTIONS HERE
    fetchTriviaQuestions()
  }
    
  func fetchTriviaQuestions() {
      TriviaQuestionService().fetchTriviaQuestions { [weak self] questions, error in
        if let error = error {
          print("Error fetching questions: \(error)")
        } else if let questions = questions {
          self?.questions = questions
          DispatchQueue.main.async {
            self?.updateQuestion(withQuestionIndex: 0)
          }
        }
      }
  }
  
  private func updateQuestion(withQuestionIndex questionIndex: Int) {
    currentQuestionNumberLabel.text = "Question: \(questionIndex + 1)/\(questions.count)"
      
    guard questionIndex >= 0, questionIndex < questions.count else {
        // Handle this case (e.g., show an error message)
        return
    }
      
    let question = questions[questionIndex]
    let decodedQuestion = fixText(text: question.question)
    let decodedCategory = fixText(text: question.category)
    questionLabel.text = decodedQuestion
    categoryLabel.text = decodedCategory
    if question.type == "multiple" {
        let answers = ([question.correct_answer] + question.incorrect_answers).shuffled()
        if answers.count > 0 {
            answerButton0.setTitle(fixText(text: answers[0]), for: .normal)
        }
        if answers.count > 1 {
            answerButton1.setTitle(fixText(text: answers[1]), for: .normal)
            answerButton1.isHidden = false
        }
        if answers.count > 2 {
            answerButton2.setTitle(fixText(text: answers[2]), for: .normal)
            answerButton2.isHidden = false
        }
        if answers.count > 3 {
            answerButton3.setTitle(fixText(text: answers[3]), for: .normal)
            answerButton3.isHidden = false
        }
      } else if question.type == "boolean" {
          answerButton0.setTitle("True", for: .normal)
          answerButton1.setTitle("False", for: .normal)
          answerButton0.isHidden = false
          answerButton1.isHidden = false
          answerButton2.isHidden = true
          answerButton3.isHidden = true
      }
  }
  
  private func updateToNextQuestion(answer: String) {
    if isCorrectAnswer(answer) {
      numCorrectQuestions += 1
    }
    currQuestionIndex += 1
    guard currQuestionIndex < questions.count else {
      showFinalScore()
      return
    }
    updateQuestion(withQuestionIndex: currQuestionIndex)
  }
  
  private func isCorrectAnswer(_ answer: String) -> Bool {
      guard currQuestionIndex >= 0, currQuestionIndex < questions.count else {
          return false
      }
      
      return answer == questions[currQuestionIndex].correct_answer
  }
    
  private func resetGame() {
      currQuestionIndex = 0
      numCorrectQuestions = 0
      questions.removeAll()
      
      currentQuestionNumberLabel.text = ""
      questionLabel.text = ""
      categoryLabel.text = ""
      answerButton0.setTitle("", for: .normal)
      answerButton1.setTitle("", for: .normal)
      answerButton2.setTitle("", for: .normal)
      answerButton3.setTitle("", for: .normal)
      
      answerButton1.isHidden = true
      answerButton2.isHidden = true
      answerButton3.isHidden = true
    }
  
  private func showFinalScore() {
    let alertController = UIAlertController(title: "Game over!",
                                            message: "Final score: \(numCorrectQuestions)/\(questions.count)",
                                            preferredStyle: .alert)
    let resetAction = UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
        self.resetGame() // Call the resetGame method here
        self.fetchTriviaQuestions() // Fetch new questions after resetting
    }
    alertController.addAction(resetAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func addGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                            UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    view.layer.insertSublayer(gradientLayer, at: 0)
  }

  private func fixText(text:String) -> String{
      guard let newText = text.data(using: .utf8) else{return text}
      guard let attributedString = try? NSAttributedString(
          data: newText,
          options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
          ],
          documentAttributes: nil
      ) else {
          return text
      }
      
      return attributedString.string
  }
  
  @IBAction func didTapAnswerButton0(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton1(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton2(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
  
  @IBAction func didTapAnswerButton3(_ sender: UIButton) {
    updateToNextQuestion(answer: sender.titleLabel?.text ?? "")
  }
}

