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
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]
    
    @AppStorage("quiz") var quizzesData = Data() // UserDefaultsから問題を読み込む(Data型)
    @State var quizzesArray: [Quiz] = []  // 問題を入れておく配列
    
    @State private var currentQuestionNum: Int = 0 // 今、何問目か
    @State private var showingAlert = false        // アラートの表示・非表示を管理
    @State private var alertTitle = ""             // "正解" か "不正解" のタイトル
    
    // 起動時にquizzesDataに読み込んだ値(Data型)を[Quiz]型にデコードしてquizzesArrayに入れる
    init() {
        if let decodedQuizzes = try? JSONDecoder().decode([Quiz].self, from: quizzesData) {
            _quizzesArray = State(initialValue: decodedQuizzes)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
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
                    .padding()
                    .navigationTitle("マルバツクイズ") // ナビゲーションバーにタイトル設定
                    .alert(alertTitle, isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {
                            nextQuestion()
                        }
                    }
                    // 問題作成画面へ遷移するためのボタンを設置
                    .toolbar {
                        // 配置する場所を画面最上部のバーの右端に設定
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                // 遷移先の画面
                                CreateView(quizzesArray: $quizzesArray)
                                    .navigationTitle("問題を作ろう")
                            } label: {
                                // 画面に遷移するためのボタンの見た目
                                Image(systemName: "plus")
                                    .font(.title)
                            }
                        }
                    }
                }
            }
        }
    }

    // 問題を表示する関数
    func showQuestion() -> String {
        var question = "問題がありません!"
        // 問題があるかどうかのチェック
        if !quizzesArray.isEmpty {
            let quiz = quizzesArray[currentQuestionNum]
            question = quiz.question
        }
        return question
    }

    // 回答をチェックする関数
    func checkAnswer(yourAnswer: Bool) {
        if quizzesArray.isEmpty { return } // 問題が無いときは回答チェックしない
        let quiz = quizzesArray[currentQuestionNum]
        let ans = quiz.answer
        if yourAnswer == ans {
            alertTitle = "正解"
            // 現在の問題番号が問題数を超えないように場合分け
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

