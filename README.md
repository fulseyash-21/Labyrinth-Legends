**Labyrinth Legends**

Labyrinth Legends is a neon-themed iOS maze game built programmatically with UIKit (no Storyboards). It features custom animations, multiple mazes, and intuitive swipe controls.

Home Screen:


![a7djwc](https://github.com/user-attachments/assets/8b8edd60-5dc5-42e1-b3d4-6d0e6f79b96c)


Maze traversal and handling:



![a7dk2o](https://github.com/user-attachments/assets/60386475-2751-4b57-adce-edda9ba86dee)




Key Features:
- 100% Programmatic UI: No Storyboards.

- Custom Core Animation: A dynamic, looping neon animation on the home screen.

- Dynamic Grid Layout: UICollectionView renders the maze from a 2D array.

- Intuitive Controls: Supports both tap-to-move and swipe gestures.

- Multiple Levels: Includes several pre-defined mazes.

Technical Highlights
- Home Screen Animation (NeonMazeView.swift): The looping neon animation is built with CAShapeLayer. A CAAnimationGroup animates the strokeStart and strokeEnd properties to create a seamless "snake" effect, while the glow is achieved using the layer's shadow properties.

- Maze Gameplay (MazeViewController.swift): The maze grid is a UICollectionView. Its state is driven by a 2D integer array where each number represents a wall, path, or the player. When the player moves, the array is updated, and collectionView.reloadData() is called to instantly reflect the new game state.


![a7dk03](https://github.com/user-attachments/assets/b5f38c78-7838-4ece-a7e2-51852409b6e4)


How to Run the Project
Prerequisites
- macOS with Xcode installed. You can download Xcode from the Mac App Store.

Steps
- Clone the Repository:
```
git clone 
```
Open the Project:
Navigate to the cloned directory and open the Labyrinth-Legends.xcodeproj file in Xcode.

Running on an iOS Simulator
- In Xcode, select an iOS Simulator from the target device dropdown menu at the top of the window (e.g., "iPhone 16 Pro").

- Click the "Run" button (the triangle icon) or press Cmd+R. Xcode will build the app and launch it in the selected simulator.
