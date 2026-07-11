import SwiftUI

struct CategorySelectView: View {
    @Binding var path: [Route]
    @State private var selectedDifficulty = "Beginner"

    private let difficulties = ["Beginner", "Intermediate", "Advanced"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AWSTheme.spacing) {
                Text("Difficulty")
                    .font(.headline)
                    .foregroundStyle(Color.awsNavy)
                difficultyPicker

                Text("Category")
                    .font(.headline)
                    .foregroundStyle(Color.awsNavy)
                categoryList
            }
            .padding(AWSTheme.spacing)
        }
        .background(Color.awsLightGray)
        .navigationTitle("Choose a Topic")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var difficultyPicker: some View {
        HStack(spacing: 8) {
            ForEach(difficulties, id: \.self) { difficulty in
                Button {
                    Haptics.select()
                    withAnimation(.easeOut(duration: 0.2)) {
                        selectedDifficulty = difficulty
                    }
                } label: {
                    Text(difficulty)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(selectedDifficulty == difficulty ? .white : Color.awsNavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedDifficulty == difficulty ? Color.awsOrange : .white,
                            in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }

    private var categoryList: some View {
        VStack(spacing: 10) {
            ForEach(QuestionBank.categories, id: \.self) { category in
                let count = QuestionBank.questions(category: category,
                                                   difficulty: selectedDifficulty).count
                Button {
                    Haptics.tap()
                    path.append(.quiz(QuizConfig(category: category,
                                                 difficulty: selectedDifficulty)))
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(category)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(count > 0 ? Color.awsNavy : .secondary)
                            Text("\(count) question\(count == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.awsOrange)
                    }
                    .padding(14)
                    .background(.white, in: RoundedRectangle(cornerRadius: AWSTheme.cornerRadius))
                }
                .buttonStyle(ScaleButtonStyle())
                .disabled(count == 0)
                .opacity(count == 0 ? 0.5 : 1)
            }
        }
    }
}
