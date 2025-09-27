import UIKit

// MARK: - MazeSelectionViewController
class MazeSelectionViewController: UIViewController {

    // MARK: - Maze Data
    
    private let mazes: [String: [[Int]]] = [
        "A. Classic": [
            [1, 4, 1, 1, 1, 1, 1],
            [1, 0, 0, 0, 1, 0, 1],
            [1, 0, 1, 0, 1, 0, 1],
            [1, 0, 1, 0, 0, 0, 1],
            [1, 1, 1, 1, 1, 3, 1]
        ],
        "B. Long Path": [
            [1, 4, 0, 0, 0, 0, 1],
            [1, 1, 1, 1, 1, 0, 1],
            [1, 0, 0, 0, 0, 0, 1],
            [1, 0, 1, 1, 1, 1, 1],
            [1, 0, 0, 0, 0, 0, 1],
            [1, 1, 1, 1, 1, 0, 1],
            [1, 0, 0, 0, 1, 3, 1]
        ],
        "C. Open Field": [
            [ 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
            [ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ],
            [ 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1 ],
            [ 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1 ],
            [ 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1 ],
            [ 1, 0, 1 ,0, 1, 0, 0, 0, 0, 0, 0, 0, 1 ],
            [ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1 ]
        ],
        "D. Citadel" : [
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1],
            [1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 4, 1],
            [1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1],
            [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1],
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
            [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1],
            [1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1],
            [1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1],
            [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
            [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 1],
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        ]
    ]
    
    private var mazeNames: [String] = []

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mazeNames = mazes.keys.sorted()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 10/255, green: 15/255, blue: 30/255, alpha: 1.0)
        
        let titleLabel = UILabel()
        titleLabel.text = "Select a Maze"
        titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 34)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("‹ Home", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20)
        backButton.setTitleColor(.cyan, for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        
        for (index, name) in mazeNames.enumerated() {
            let button = createGradientButton(title: name, tag: index)
            stackView.addArrangedSubview(button)
        }
        
        [titleLabel, stackView, backButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
    }
    
    
    private func createGradientButton(title: String, tag: Int) -> UIButton {
        let gradientButton = GradientButton()
        gradientButton.setTitle(title, for: .normal)
        gradientButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 22)
        gradientButton.setTitleColor(.white, for: .normal)
        gradientButton.layer.cornerRadius = 30
        gradientButton.layer.masksToBounds = true
        gradientButton.tag = tag
        gradientButton.addTarget(self, action: #selector(launchMaze(_:)), for: .touchUpInside)

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0/255, green: 220/255, blue: 255/255, alpha: 1.0).cgColor,
            UIColor(red: 0/255, green: 255/255, blue: 180/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientButton.gradientLayer = gradientLayer
        gradientButton.layer.insertSublayer(gradientLayer, at: 0)
        
        gradientButton.layer.shadowColor = UIColor.cyan.cgColor
        gradientButton.layer.shadowRadius = 15
        gradientButton.layer.shadowOpacity = 0.9
        gradientButton.layer.shadowOffset = .zero
        gradientButton.layer.masksToBounds = false
        
        gradientButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

        return gradientButton
    }
    
    // MARK: - Actions
    
    @objc private func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func launchMaze(_ sender: UIButton) {
        let mazeName = mazeNames[sender.tag]
        guard let selectedMaze = mazes[mazeName] else { return }
        
        if hasLoop(in: selectedMaze) {
            showInvalidMazeSnackbar()
            return
        }
        
        let mazeVC = MazeViewController(maze: selectedMaze)
        mazeVC.modalPresentationStyle = .fullScreen
        present(mazeVC, animated: true, completion: nil)
    }
    
    private func showInvalidMazeSnackbar() {
        let snackbarView = UIView()
        
        snackbarView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
        snackbarView.layer.cornerRadius = 15
        snackbarView.translatesAutoresizingMaskIntoConstraints = false
        snackbarView.layer.shadowColor = UIColor.black.cgColor
        snackbarView.layer.shadowRadius = 5
        snackbarView.layer.shadowOpacity = 0.5
        
        let label = UILabel()
        label.text = "Invalid Maze"
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Medium", size: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        snackbarView.addSubview(label)
        view.addSubview(snackbarView)

        NSLayoutConstraint.activate([
            snackbarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            snackbarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            snackbarView.heightAnchor.constraint(equalToConstant: 50),
            label.leadingAnchor.constraint(equalTo: snackbarView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: snackbarView.trailingAnchor, constant: -20),
            label.centerYAnchor.constraint(equalTo: snackbarView.centerYAnchor)
        ])
        
        snackbarView.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: { snackbarView.alpha = 1.0 }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 0.5, animations: { snackbarView.alpha = 0.0 }) { _ in
                    snackbarView.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: - Maze Validation
    
    private func hasLoop(in maze: [[Int]]) -> Bool {
        guard !maze.isEmpty, !maze[0].isEmpty else { return false }
        // To store all the visited cells
        var visited = Set<[Int]>()
        for r in 0..<maze.count {
            for c in 0..<maze[0].count {
                // Check eligiblity for the cell and the cycle
                if maze[r][c] != 1 && !visited.contains([r, c]) {
                    if isCycle(row: r, col: c, parentRow: -1, parentCol: -1, maze: maze, visited: &visited) {
                        return true
                    }
                }
            }
        }
        return false
    }

    // Depth First Search: Checks if the cycle contains a loop
    private func isCycle(row: Int, col: Int, parentRow: Int, parentCol: Int, maze: [[Int]], visited: inout Set<[Int]>) -> Bool {
        visited.insert([row, col])
        let neighbors = [(row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1)]
        for (nRow, nCol) in neighbors {
            guard nRow >= 0, nRow < maze.count, nCol >= 0, nCol < maze[0].count, maze[nRow][nCol] != 1 else { continue }
            if nRow == parentRow && nCol == parentCol { continue }
            if visited.contains([nRow, nCol]) { return true }
            if isCycle(row: nRow, col: nCol, parentRow: row, parentCol: col, maze: maze, visited: &visited) {
                return true
            }
        }
        return false
    }
}


