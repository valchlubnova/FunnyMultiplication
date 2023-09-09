//
//  ContentView.swift
//  FunnyMultiplication
//
//  Created by Valerie Chlubnová on 09.09.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var multiplicand = 2
    @State private var multiplier = 1
    var questionsSets = [5, 10, 15, 20, 25]
    @State private var selectedQuestionsSet = 10
    @State private var answer = 0
    @State private var score = 0
    @State private var round = 1
    @State private var gameIsOn = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var buttonText = ""
    @State private var isShowingAlert = false
    @State private var isShowingResult = false
    @State private var lastQuestionWrong = false
    @FocusState private var answerIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if gameIsOn {
                    Text("Round: \(round)/\(selectedQuestionsSet), Score: \(score)")
                    Text("\(multiplicand) x \(multiplier) = ?")
                    TextField("Your answer:", value: $answer, format: .number)
                        .keyboardType(.numberPad)
                        .focused($answerIsFocused)
                    
                    if answerIsFocused {
                        Button("Check answer") {
                            checkAnswer()
                            answerIsFocused = false
                        }
                    }
                    
                } else {
                    Stepper("Multiplication table: \(multiplicand)", value: $multiplicand, in: 2...12)
                    
                    Picker("Number of questions:", selection: $selectedQuestionsSet) {
                        ForEach(questionsSets, id: \.self) { quantity in
                            Text("\(quantity)")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Button("Start Game", action: startNewGame)
                }
            }
            .navigationTitle("FunnyMultiplication")
            .onSubmit(checkAnswer)
            .alert(alertTitle, isPresented: $isShowingAlert) {
                Button(buttonText) {
                    if lastQuestionWrong {
                        showResults()
                    }
                }
            } message: {
                Text(alertMessage)
            }
            .alert(alertTitle, isPresented: $isShowingResult) {
                Button(buttonText) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func startNewGame() {
        gameIsOn = true
        answer = 0
        score = 0
        round = 1
        multiplier = Int.random(in: 1...12)
    }
    
    func checkAnswer() {
        if answer == multiplier * multiplicand {
            score += 1
        } else {
            lastQuestionWrong = true
            informAboutWrongAnswer()
        }
        
        if round < selectedQuestionsSet {
            round += 1
            multiplier = Int.random(in: 1...12)
            lastQuestionWrong = false
        } else {
            if lastQuestionWrong {
                informAboutWrongAnswer()
            } else {
                showResults()
            }
        }
    }
    
    func showResults() {
        alertTitle = "Game finished"
        alertMessage = "You got \(score) out of \(selectedQuestionsSet) questions right."
        buttonText = "That was fun. Let's play again."
        gameIsOn = false
        isShowingResult = true
    }
    
    func informAboutWrongAnswer() {
        alertTitle = "Wrong answer"
        alertMessage = "\(multiplicand) x \(multiplier) = \(multiplicand*multiplier) not \(answer)."
        buttonText = "OK"
        isShowingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
