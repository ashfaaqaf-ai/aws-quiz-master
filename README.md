# AWS Quiz Master

Offline AWS certification prep quiz app for iPhone. SwiftUI + SwiftData, **iOS 26+**.

## Requirements
- Xcode 26 or later (iOS 26 SDK)
- iOS 26.0+ deployment target

## Getting Started (on a Mac)
1. Open `AWSQuizMaster.xcodeproj` in Xcode.
2. Select your development team under *Signing & Capabilities* (or run on the simulator with no team).
3. Build and run (⌘R).

New Swift files dropped into the `AWSQuizMaster/` folder are picked up automatically — no need to edit the project file.

## Building & Testing WITHOUT a Mac

You don't need to own a Mac to verify and even try this app:

**1. GitHub Actions (included, free for public repos)**
Push this folder to a public GitHub repository. The included workflow
[`.github/workflows/ios-build.yml`](.github/workflows/ios-build.yml) builds the app on a
cloud macOS runner on every push — compile errors show up right in the Actions tab.
It also uploads `AWSQuizMaster-simulator.zip` as a downloadable build artifact.

**2. Appetize.io (run the app in your browser)**
Download the simulator zip from the GitHub Actions artifact, then upload it to
[appetize.io](https://appetize.io) (free tier available). You get a streaming iPhone
simulator in the browser where you can tap through the real app.

**3. Rented cloud Macs** — [MacinCloud](https://macincloud.com), MacStadium, or
Scaleway offer hourly/monthly remote Macs with Xcode if you need the full IDE.

**4. Deploying to a real iPhone** requires an Apple Developer account; services like
Codemagic or Xcode Cloud can build and distribute via TestFlight entirely from CI.

## Features
- **Start Quiz** — 10 random questions across all categories and difficulties.
- **Browse Categories** — pick one of 10 AWS categories + Beginner/Intermediate/Advanced.
- **Practice Mode** — spaced repetition over questions you previously got wrong; answering correctly removes them from the pool.
- **Stats** — total attempted, accuracy %, and a day streak, computed from persisted sessions.
- **Review** — flip through every answered question with your answer, the correct answer, and an explanation.
- Answer options are re-shuffled every quiz so answer positions can't be memorized.
- Haptics on every interaction, animated answer feedback (green fill + checkmark, red fill + shake), animated progress bar, and a score count-up with haptic ticks.

## Question Bank
`AWSQuizMaster/Resources/questions.json` holds **300 questions** (10 categories ×
Beginner/Intermediate/Advanced). To add more, append objects with the same shape —
the loader picks up any count automatically:

```json
{
  "id": "q301",
  "text": "…",
  "options": ["A", "B", "C", "D"],
  "correctAnswer": 1,
  "explanation": "…",
  "category": "Compute",
  "difficulty": "Beginner"
}
```

`category` must match one of the entries in the `categories` array; `difficulty` is
`Beginner`, `Intermediate`, or `Advanced`. Ids must be unique.

## Structure
```
AWSQuizMaster/
├── AWSQuizMasterApp.swift      App entry, SwiftData container
├── Models/                     Question, QuestionBank, SwiftData models, stats, routes
├── ViewModels/QuizEngine.swift Quiz session state machine + persistence
├── Views/                      Home, CategorySelect, Quiz, Results, Review + components
├── Theme/                      AWS color palette + layout constants
├── Utilities/                  Haptics, shake effect, scale button style
└── Resources/questions.json    Offline question bank (300 questions)
.github/workflows/ios-build.yml Cloud build via GitHub Actions (no Mac needed)
```
