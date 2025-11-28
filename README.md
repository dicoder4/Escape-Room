# 🚪 Escape Room (Flutter)

A bite-sized, puzzle-first escape room built with Flutter. Race against a global countdown as you crack riddles, find sneaky hidden objects, wiggle through a mini-maze, align a starry “constellation,” and—if you’re clever—unlock the final exit. (Spoilers? Nope. You’ll have to outsmart the game for answers.)

---

## 🎲 What to Expect

- The clock? It’s always watching. Tick, tick, tick…
- Each room flips the script: think, search, navigate, align, decode.
- Hints show up if you’re brave enough to fail a few times.
- Nail that last puzzle for a satisfying “aha!” moment.

---

## 🛠️ Tech Stack

- Flutter + Dart
- Custom navigation with Navigator & routes
- Hand-drawn UI (triangles, stars, maze, glowing player) via CustomPainter
- Global timer overlay (Stack magic)
- Launches a secret reward using url_launcher

Main entry: `lib/main.dart`

---

## 🧩 Features (No Spoilers Here!)

- Global countdown overlay—run out, and you’re greeted by a “Time’s Up” screen
- Room 1: Riddle gate (with gentle hints if you get stuck)
- Room 2: Hidden key you’ll have to spot and tap
- Room 3: Mini-maze with collectibles and story popups
- Room 4: “Constellation” — rotate triangles, align the stars, unlock the next step
- Room 5: 4-character passcode dialog (plus an optional mysterious final link)

---

## 🚀 Getting Started (Windows / PowerShell)

```powershell
cd "C:\Users\Diya\msritf\escape"
flutter pub get
flutter run
```

- Run on Chrome: `flutter run -d chrome`
- Run on Windows desktop (if enabled): `flutter run -d windows`

---

## ⚙️ Customizing

- **Timer duration:**  
  Change in `EscapeRoomApp` → `TimerOverlay(600, navigatorKey)`
- **Reward link:**  
  See `_PasscodeScreenState._openYouTubeLink()`
- **Images:**  
  Loaded from the network by default; swap to local assets in `pubspec.yaml` if you want.

---

## 🗂️ Project Structure (partial)

```
escape/
  lib/
    main.dart
  pubspec.yaml
```

---

## 🕹️ Play & Hack

- Clone/download, run `flutter pub get`, then `flutter run`.
- Make it your own—change puzzles, tweak the art, adjust the timer, remix the fun!
- Please don’t spoil the answers in your forks. (It’s way more fun that way.)

---

## 💡 Notes

- If the maze/player feels laggy, tweak `CustomPainter.shouldRepaint` to listen for state changes.
- No secrets in the repo, please! For big files, use Git LFS.



---

Good luck escaping! ⏳🔑🌌
