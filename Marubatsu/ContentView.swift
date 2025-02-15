//
//  ContentView.swift
//  Marubatsu
//
//  Created by 卜部大輝 on 2025/02/15.
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
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]
    
    @State private var currentQuestionNum: Int = 0 // 今、何問目か
    @State private var showingAlert = false        // アラートの表示・非表示を管理
    @State private var alertTitle = ""             // "正解" か "不正解" のタイトル

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(showQuestion()) // 問題文を表示
                    .padding()
                    .frame(width: geometry.size.width * 0.85, alignment: .leading)
                    .font(.system(size: 25))
                    .fontDesign(.rounded)
                    .background(.yellow)
                
                Spacer()
                
                // ○×ボタンを横並びに配置
                HStack {
                    // Oボタン
                    Button {
                        checkAnswer(yourAnswer: true)
                    } label: {
                        Text("⚪︎")
                    }
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                    .font(.system(size: 100, weight: .bold))
                    .foregroundStyle(.white)
                    .background(.red)

                    // ×ボタン
                    Button {
                        checkAnswer(yourAnswer: false)
                    } label: {
                        Text("×")
                    }
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                    .font(.system(size: 100, weight: .bold))
                    .foregroundStyle(.white)
                    .background(.blue)
                }
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height)
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    nextQuestion()
                }
            }
        }
    }

    // 問題を表示する関数
    func showQuestion() -> String {
        return quizExamples[currentQuestionNum].question
    }

    // 回答をチェックする関数
    func checkAnswer(yourAnswer: Bool) {
        let quiz = quizExamples[currentQuestionNum]
        if yourAnswer == quiz.answer {
            alertTitle = "正解！🎉"
        } else {
            alertTitle = "不正解 😢"
        }
        showingAlert = true
    }

    // 次の問題へ進む関数
    func nextQuestion() {
        if currentQuestionNum + 1 < quizExamples.count {
            currentQuestionNum += 1
        } else {
            currentQuestionNum = 0 // 最後の問題の後は最初に戻る
        }
    }
}

#Preview {
    ContentView()
}

