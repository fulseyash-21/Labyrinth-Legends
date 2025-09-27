import UIKit

class MazeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Maze Model
    private var maze: [[Int]]
    private let originalMaze: [[Int]]
    private let numRows: Int
    private let numCols: Int
    private var startPoint: (Int, Int) = (0, 0)
    private var user: (Int, Int) = (0, 0)
    private var endPoint: (Int, Int) = (0, 0)
    
    // MARK: - UI Properties
    private var collectionView: UICollectionView!
    private static let cellIdentifier = "MazeCell"
    private var winOverlay: UIView?
    
    private enum CellType: Int {
        case path = 0, wall = 1, visited = 2, end = 3, user = 4
    }

    // MARK: - Init
    init(maze: [[Int]]) {
        self.originalMaze = maze
        self.maze = maze
        self.numRows = maze.count
        self.numCols = maze.isEmpty ? 0 : maze[0].count
        super.init(nibName: nil, bundle: nil)
        
        // Find start and end points
        for (r, row) in maze.enumerated() {
            for (c, value) in row.enumerated() {
                if value == CellType.user.rawValue {
                    self.startPoint = (r, c)
                    self.user = (r, c)
                } else if value == CellType.end.rawValue {
                    self.endPoint = (r, c)
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 10/255, green: 15/255, blue: 30/255, alpha: 1.0)
        setupCollectionView()
        setupPanGesture()
        setupBackButton()
    }
    
    // MARK: - UI Setup
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Self.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        let mazeSize = min(view.bounds.width - 40, view.bounds.height - 200)
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: mazeSize),
            collectionView.heightAnchor.constraint(equalToConstant: mazeSize * CGFloat(numRows) / CGFloat(numCols))
        ])
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
        backButton.setTitleColor(.cyan, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numRows * numCols
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellIdentifier, for: indexPath)
        let row = indexPath.item / numCols
        let col = indexPath.item % numCols
        let value = maze[row][col]
        
        // Reset appearance
        cell.layer.shadowOpacity = 0
        cell.layer.borderWidth = 0
        

        switch CellType(rawValue: value) {
            case .path:
                cell.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
            case .wall:
                cell.backgroundColor = .black
                cell.layer.borderColor = UIColor.darkGray.cgColor
                cell.layer.borderWidth = 0.5
            case .visited:
                cell.backgroundColor = .green
                cell.layer.shadowColor = UIColor.green.cgColor
                cell.layer.shadowRadius = 5
                cell.layer.shadowOpacity = 0.9
            case .end:
                cell.backgroundColor = .red
                cell.layer.shadowColor = UIColor.red.cgColor
                cell.layer.shadowRadius = 5
                cell.layer.shadowOpacity = 0.9
            case .user:
                cell.backgroundColor = .cyan
                cell.layer.shadowColor = UIColor.cyan.cgColor
                cell.layer.shadowRadius = 8
                cell.layer.shadowOpacity = 1.0
            default:
                cell.backgroundColor = .gray
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalSpacing = CGFloat(numCols - 1) * 1.0
        let availableWidth = collectionView.bounds.width - totalHorizontalSpacing
        let cellWidth = availableWidth / CGFloat(numCols)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let tapped = (indexPath.item / numCols, indexPath.item % numCols)
        move(to: tapped)
    }
    
    // MARK: - Move Logic
    private func isMoveEligible(from start: (Int, Int), to end: (Int, Int)) -> Bool {
        guard maze[end.0][end.1] != CellType.wall.rawValue, start.0 == end.0 || start.1 == end.1 else { return false }
        
        if start.0 == end.0 {
            for i in min(start.1, end.1)+1..<max(start.1, end.1) where maze[start.0][i] == CellType.wall.rawValue { return false }
        } else {
            for i in min(start.0, end.0)+1..<max(start.0, end.0) where maze[i][start.1] == CellType.wall.rawValue { return false }
        }
        return true
    }
    
    private func move(to destination: (Int, Int)) {
        guard destination.0 != user.0 || destination.1 != user.1 else {
            return
        }
        if !isMoveEligible(from: user, to: destination) { return }
        
        let newPathState = maze[destination.0][destination.1] == CellType.visited.rawValue ? CellType.path.rawValue : CellType.visited.rawValue

        if user.0 == destination.0 {
            for i in min(user.1, destination.1)...max(user.1, destination.1) where maze[user.0][i] != CellType.wall.rawValue { maze[user.0][i] = newPathState }
        } else {
            for i in min(user.0, destination.0)...max(user.0, destination.0) where maze[i][user.1] != CellType.wall.rawValue { maze[i][user.1] = newPathState }
        }
        
        if user == startPoint { maze[user.0][user.1] = CellType.visited.rawValue }
        user = destination
        
        if user == endPoint {
            maze[user.0][user.1] = CellType.end.rawValue
            showWinOverlay() // **MODIFIED:** Call the new custom overlay
        } else {
            maze[user.0][user.1] = CellType.user.rawValue
        }
        collectionView.reloadData()
    }
    
    // MARK: - Alerts & Actions
    private func showWinOverlay() {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlay.alpha = 0
        
        let container = UIView()
        container.backgroundColor = UIColor(red: 20/255, green: 30/255, blue: 50/255, alpha: 1.0)
        container.layer.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "CONGRATULATIONS!"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 24)
        titleLabel.textColor = .white
        
        let playAgainButton = createGradientButton(title: "Play Again")
        playAgainButton.addTarget(self, action: #selector(playAgainTapped), for: .touchUpInside)
        
        let menuButton = createSecondaryButton(title: "Back to Menu")
        menuButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, playAgainButton, menuButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stackView)
        overlay.addSubview(container)
        view.addSubview(overlay)
        self.winOverlay = overlay
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            container.widthAnchor.constraint(equalTo: overlay.widthAnchor, multiplier: 0.8),
            
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            
            playAgainButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            playAgainButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            menuButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        UIView.animate(withDuration: 0.3) {
            overlay.alpha = 1.0
        }
    }
    
    @objc private func playAgainTapped() {
        resetMaze()
    }
    
    private func resetMaze() {
        winOverlay?.removeFromSuperview()
        winOverlay = nil
        self.maze = originalMaze
        self.user = startPoint
        collectionView.reloadData()
    }
    
    @objc private func goBack() {
        winOverlay?.removeFromSuperview()
        winOverlay = nil
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard gesture.state == .ended, winOverlay == nil else { return }
        let velocity = gesture.velocity(in: view)
        guard sqrt(velocity.x*velocity.x + velocity.y*velocity.y) > 500 else { return }
        
        var dRow = 0, dCol = 0
        if abs(velocity.x) > abs(velocity.y) { dCol = velocity.x > 0 ? 1 : -1 }
        else { dRow = velocity.y > 0 ? 1 : -1 }
        
        var furthestValidCell = user
        for i in 1...max(numRows, numCols) {
            let nextCell = (user.0 + dRow * i, user.1 + dCol * i)
            guard nextCell.0 >= 0, nextCell.0 < numRows, nextCell.1 >= 0, nextCell.1 < numCols,
                  maze[nextCell.0][nextCell.1] != CellType.wall.rawValue else { break }
            furthestValidCell = nextCell
        }
        
        if furthestValidCell != user { move(to: furthestValidCell) }
    }
    
    // MARK: - UI Helper Functions for Overlay
    private func createGradientButton(title: String) -> UIButton {
        let gradientButton = GradientButton()
        gradientButton.setTitle(title, for: .normal)
        gradientButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18)
        gradientButton.setTitleColor(.white, for: .normal)
        gradientButton.layer.cornerRadius = 25
        gradientButton.layer.masksToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.cyan.cgColor, UIColor.green.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientButton.gradientLayer = gradientLayer
        gradientButton.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientButton.layer.shadowColor = UIColor.cyan.cgColor
        gradientButton.layer.shadowRadius = 10
        gradientButton.layer.shadowOpacity = 0.8
        gradientButton.layer.shadowOffset = .zero
        gradientButton.layer.masksToBounds = false
        
        return gradientButton
    }
    
    private func createSecondaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        return button
    }
}

