//
//  ContentView.swift
//  Marubatsu
//
//  Created by Hiroki Urabe on 2025/02/15.
//

import SwiftUI

struct Quiz: Identifiable, Codable {
    var id = UUID()      // それぞれの設問を区別するID
    var question: String // 問題文
    var answer: Bool     // 解答
}

struct ContentView: View {
    
    let quizExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true),
    ]
    
    @AppStorage("quiz") var quizzeData = Data()
    @State var quizzesArray: [Quiz] = []
    
    @State var currentQuestionNum: Int = 0
    @State var showingAlert = false
    @State var alertTitle = ""
    
    init() {
        if let decodedQuizzes = try? JSONDecoder().decode([Quiz].self, from: quizzeData) {
            _quizzesArray = State(initialValue: decodedQuizzes)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    Text(showQuestion())
                        .padding()
                        .frame(width: geometry.size.width * 0.8, alignment: .leading)
                        .font(.system(size: 25))
                        .fontDesign(.rounded)
                        .background(.yellow)
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            checkAnswer(yourAnswer: true)
                        } label: {
                            Text("○")
                        }
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                        .font(.system(size: 100, weight: .bold))
                        .foregroundStyle(.white)
                        .background(.red)
                        Button {
                            checkAnswer(yourAnswer: false)
                        } label: {
                            Text("Ｘ")
                        }
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                        .font(.system(size: 100, weight: .bold))
                        .foregroundStyle(.white)
                        .background(.blue)
                    }
                }
                .padding()
                .navigationTitle("マルバツクイズ")
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        //
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            CreateView(quizzesArray: $quizzesArray)
                                .navigationTitle("問題を作ろう")
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                        }
                    }
                }
            }
        }
    }

    func showQuestion() -> String {
        var question = "問題がありません！"
        
        if !quizzesArray.isEmpty {
            let quiz = quizzesArray[currentQuestionNum]
            question = quiz.question
        }
        
        return question
    }

    func checkAnswer(yourAnswer: Bool) {
        if quizzesArray.isEmpty { return }
        let quiz = quizzesArray[currentQuestionNum]
        let ans = quiz.answer
        if yourAnswer == ans {
            alertTitle = "正解"
            if currentQuestionNum + 1 < quizzesArray.count {
                currentQuestionNum += 1
            } else {
                currentQuestionNum = 0
            }
        } else {
            alertTitle = "不正解"
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
