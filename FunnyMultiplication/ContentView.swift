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
    @State private var selectedQuestionsSet = 5
    @State private var answer = 0
    @State private var score = 0
    @State private var round = 0
    @State private var gameIsOn = false
    @State private var correctedAnswer = ""
    @State private var showingResults = false
    @FocusState private var answerIsFocused: Bool
    var grayBlue = Color(red: 0.396078431372549, green: 0.5019607843137255, blue: 0.6235294117647059)
    var darkGrayBlue = Color(red: 0.3764705882352941, green: 0.47058823529411764, blue: 0.5843137254901961)
    var darkestGrayBlue = Color(red: 0.2901960784313726, green: 0.34509803921568627, blue: 0.4117647058823529)
    var lightBrown = Color(red: 0.7568627450980392, green: 0.6078431372549019, blue: 0.4392156862745098)
    var enemyGreen = Color(red: 0.5137254901960784, green: 0.7607843137254902, blue: 0.6666666666666666)
    var enemyPink = Color(red: 0.8980392156862745, green: 0.6274509803921569, blue: 0.7137254901960784)
    var enemyLightBeige = Color(red: 0.8941176470588236, green: 0.8549019607843137, blue: 0.7607843137254902)
    var enemyLightBlue = Color(red: 0.6627450980392157, green: 0.7607843137254902, blue: 0.9058823529411765)
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom ) {
                // Bootom background picture
                Image("enemies")
                    .resizable()
                    .scaledToFit()
                
                if gameIsOn {
                    // Game is running
                    VStack {
                        Spacer()
                        
                        // Greeting and correct/wrong answers
                        if round == 0 {
                            // First round greeting
                            HStack(alignment: .top, spacing: 20) {
                                Image("alienBeige_jump")
                                
                                Text("Let's calculate")
                                    .font(.title.weight(.semibold))
                                    .foregroundColor(enemyLightBeige)
                                    .padding(.bottom, 10)
                            }
                        } else if correctedAnswer.isEmpty {
                            // Correct Answer
                            HStack(alignment: .top, spacing: 20) {
                                Image("alienGreen_swim1")
                                
                                Text("You got that right")
                                    .font(.title.weight(.semibold))
                                    .foregroundColor(enemyGreen)
                                    .padding(.bottom, 10)
                            }
                        } else {
                            // Wrong answer
                            VStack {
                                HStack(alignment: .top, spacing: 10) {
                                    Image("alienPink_hurt")
                                    
                                    Text(correctedAnswer)
                                        .font(.title.weight(.semibold))
                                        .foregroundColor(enemyPink)
                                        .padding(.bottom, 10)
                                }
                            }
                        }
                        
                        // Game progress
                        if !showingResults {
                            HStack {
                                Text("Round: \(round+1)/\(selectedQuestionsSet)")
                                Spacer()
                                Text("Score: \(score)")
                            }
                            .font(.headline)
                            .padding(.horizontal, 10)
                        }
                        
                        // Questions and results table
                        if !showingResults {
                            // Showing questions
                            VStack {
                                Text("\(multiplicand) x \(multiplier) = ?")
                                    .font(.largeTitle)
                                
                                Text("Enter your answer:")
                                    .padding(.top, 5)
                                    .font(.headline)
                                
                                TextField("Your answer:", value: $answer, format: .number)
                                    .padding(5)
                                    .foregroundColor(.white)
                                    .background(darkGrayBlue)
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .focused($answerIsFocused)
                            }
                            .padding(20)
                            .background(enemyLightBlue)
                            .foregroundColor(darkestGrayBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            // Showing results
                            VStack {
                                Text("Game completed!")
                                    .font(.largeTitle)
                                    .padding(.bottom, 10)
                                Text("You got \(score) of \(selectedQuestionsSet) questions right.")
                                    .font(.body.weight(.heavy))
                                    .padding(.bottom, 5)
                                Text("That was fun, right? Let's play again!")
                                    .padding(.bottom, 10)
                            }
                            .padding(20)
                            .foregroundColor(darkestGrayBlue)
                            .background(enemyLightBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        //Buttons
                        if !showingResults {
                            //Check the answer button
                            if answerIsFocused {
                                Button("Check answer") {
                                    checkAnswer()
                                    answerIsFocused = false
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(lightBrown)
                                .foregroundColor(.white)
                                .padding(.top, 30)
                            }
                        } else {
                            //Start new game button
                            Button("Set new game", action: startNewGame)
                                .buttonStyle(.borderedProminent)
                                .tint(lightBrown)
                                .foregroundColor(.white)
                                .padding(.top, 30)
                        }
                        
                        Spacer()
                        Spacer()
                    }
                    .padding(20)
                } else {
                    // Showing game settings
                    VStack {
                        Spacer()
                        
                        // Alien title
                        HStack(alignment: .top, spacing: 15) {
                            Image("alienGreen")
                            
                            Text("Set your game")
                                .font(.title.weight(.semibold))
                                .padding(.bottom, 10)
                            
                            Image("alienPink")
                        }
                        .padding(.bottom, 15)
                        
                        // Settings table
                        VStack(alignment: .leading) {
                            Stepper("Multiplication table: \(multiplicand)", value: $multiplicand, in: 2...12)
                                .font(.headline)
                            
                            Text("Number of questions:")
                                .font(.headline)
                            
                            Picker("Number of questions:", selection: $selectedQuestionsSet) {
                                ForEach(questionsSets, id: \.self) { quantity in
                                    Text("\(quantity)")
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(20)
                        .background(enemyLightBlue)
                        .foregroundColor(darkestGrayBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        // Brown button
                        Button("Start Game", action: startNewGame)
                            .buttonStyle(.borderedProminent)
                            .tint(lightBrown)
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        Spacer()
                    }
                    .padding(20)
                }
            }
            .navigationTitle("FunnyMultiplication")
            .ignoresSafeArea()
            .background(grayBlue)
            
        }
        .preferredColorScheme(.dark)
    }
    
    func startNewGame() {
        gameIsOn = true
        showingResults = false
        answer = 0
        score = 0
        round = 0
        multiplier = Int.random(in: 1...12)
    }
    
    func checkAnswer() {
        if answer == multiplier * multiplicand {
            score += 1
            correctedAnswer = ""
        } else {
            correctedAnswer = "Nope, \(multiplicand) x \(multiplier) is \(multiplicand*multiplier)"
        }
        
        if round+1 < selectedQuestionsSet {
            round += 1
            multiplier = Int.random(in: 1...12)
        } else {
            showingResults = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
