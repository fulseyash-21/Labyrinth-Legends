import UIKit

// MARK: - HomeViewController
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private var neonMazeView: NeonMazeView!

    private func setupUI() {
        view.backgroundColor = UIColor(red: 10/255, green: 15/255, blue: 30/255, alpha: 1.0)
        
        let titleImageView = UIImageView()
        titleImageView.image = UIImage(named: "LabyrinthLegends")
        titleImageView.contentMode = .scaleAspectFit
        
        neonMazeView = NeonMazeView()

        let playButton = createGradientButton(title: "PLAY NOW")
        playButton.addTarget(self, action: #selector(playNowTapped), for: .touchUpInside)

        let optionsButton = createSecondaryButton(title: "OPTIONS")
        let leaderboardButton = createSecondaryButton(title: "LEADERBOARD")

        let buttonStack = UIStackView(arrangedSubviews: [optionsButton, leaderboardButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually

        [neonMazeView, titleImageView, playButton, buttonStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.99),

            
            neonMazeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            neonMazeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            neonMazeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            neonMazeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            playButton.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -50),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            playButton.heightAnchor.constraint(equalToConstant: 60),

            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Start the animation when the view appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        neonMazeView.startAnimation()
    }
    
    // MARK: - UI Helper Functions

    private func createGradientButton(title: String) -> UIButton {
        let gradientButton = GradientButton()
        gradientButton.setTitle(title, for: .normal)
        gradientButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 22)
        gradientButton.setTitleColor(.white, for: .normal)
        gradientButton.layer.cornerRadius = 30
        gradientButton.layer.masksToBounds = true
        
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
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.layer.masksToBounds = false
        
        return button
    }
    
    // MARK: - Actions

    @objc private func playNowTapped() {
        let selectionVC = MazeSelectionViewController()
        selectionVC.modalPresentationStyle = .fullScreen
        selectionVC.modalTransitionStyle = .crossDissolve
        present(selectionVC, animated: true, completion: nil)
    }
}

// MARK: - GradientButton
class GradientButton: UIButton {
    var gradientLayer: CAGradientLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
