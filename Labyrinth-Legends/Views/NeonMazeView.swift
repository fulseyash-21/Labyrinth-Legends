import UIKit

// A custom UIView to draw and animate the neon maze.
class NeonMazeView: UIView {
    
    private let bluePathLayer = CAShapeLayer()
    private let greenPathLayer = CAShapeLayer()
    private let redPathLayer = CAShapeLayer()
    
    private let animationDuration: CFTimeInterval = 2.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayers() {
        // Blue Layer
        configureLayer(bluePathLayer, color: .cyan)
        layer.addSublayer(bluePathLayer)
        
        // Green Layer
        configureLayer(greenPathLayer, color: .green)
        layer.addSublayer(greenPathLayer)
        
        // Red Layer
        configureLayer(redPathLayer, color: .red)
        layer.addSublayer(redPathLayer)
    }
    
    private func configureLayer(_ layer: CAShapeLayer, color: UIColor) {
        layer.lineWidth = 4
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.lineCap = .round
        layer.lineJoin = .round
        
        // Neon Glow Effect
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.95
        layer.shadowOffset = .zero
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Define the maze paths based on the view's bounds
        let blueMazePath = UIBezierPath()
        blueMazePath.move(to: CGPoint(x: bounds.width * 0.1, y: bounds.height * 0.9))
        blueMazePath.addLine(to: CGPoint(x: bounds.width * 0.1, y: bounds.height * 0.1))
        blueMazePath.addLine(to: CGPoint(x: bounds.width * 0.9, y: bounds.height * 0.1))
        blueMazePath.addLine(to: CGPoint(x: bounds.width * 0.9, y: bounds.height * 0.6))
        blueMazePath.addLine(to: CGPoint(x: bounds.width * 0.4, y: bounds.height * 0.6))
        blueMazePath.addLine(to: CGPoint(x: bounds.width * 0.4, y: bounds.height * 0.4))
        bluePathLayer.path = blueMazePath.cgPath

        let greenMazePath = UIBezierPath()
        greenMazePath.move(to: CGPoint(x: bounds.width * 0.9, y: bounds.height * 0.9))
        greenMazePath.addLine(to: CGPoint(x: bounds.width * 0.6, y: bounds.height * 0.9))
        greenMazePath.addLine(to: CGPoint(x: bounds.width * 0.6, y: bounds.height * 0.3))
        greenMazePath.addLine(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.3))
        greenMazePath.addLine(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.7))
        greenMazePath.addLine(to: CGPoint(x: bounds.width * 0.7, y: bounds.height * 0.7))
        greenPathLayer.path = greenMazePath.cgPath
        
        let redMazePath = UIBezierPath()
        redMazePath.move(to: CGPoint(x: bounds.width * 0.8, y: bounds.height * 0.15))
        redMazePath.addLine(to: CGPoint(x: bounds.width * 0.8, y: bounds.height * 0.65))
        redMazePath.addLine(to: CGPoint(x: bounds.width * 0.3, y: bounds.height * 0.65))
        redMazePath.addLine(to: CGPoint(x: bounds.width * 0.3, y: bounds.height * 0.2))
        redMazePath.addLine(to: CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.2))
        redPathLayer.path = redMazePath.cgPath

    }
    
    // This is the currently active animation. It creates a seamless "snake" effect
    // where the line appears to continuously draw and erase itself.
    func startAnimation() {
            // Remove any existing animations to prevent conflicts
            bluePathLayer.removeAllAnimations()
            greenPathLayer.removeAllAnimations()
            redPathLayer.removeAllAnimations()

            // Create and apply the animation to each layer with a slight delay for a staggered effect
            applySeamlessAnimation(to: bluePathLayer, withDelay: 0.0)
            applySeamlessAnimation(to: greenPathLayer, withDelay: 0.2)
            applySeamlessAnimation(to: redPathLayer, withDelay: 0.7)
    }
        
    
    private func applySeamlessAnimation(to layer: CAShapeLayer, withDelay delay: CFTimeInterval) {
        // This animation animates the "end" of the stroke from 0 (start) to 1 (end), effectively drawing the line.
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = animationDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // This animation animates the "start" of the stroke from 0 to 1. By starting this
        // after the strokeEndAnimation finishes, it creates an "erasing" effect from the beginning of the line.
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.duration = animationDuration
        strokeStartAnimation.beginTime = animationDuration // Start this animation after the "draw" animation has finished
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Grouping the two animations makes them run sequentially as a single, repeatable unit.
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeEndAnimation, strokeStartAnimation]
        animationGroup.duration = animationDuration * 2 // Total duration for one full cycle (draw and erase)
        animationGroup.repeatCount = .infinity // Loop forever
        animationGroup.beginTime = CACurrentMediaTime() + delay // Apply the initial delay
        
        layer.add(animationGroup, forKey: "seamlessStrokeAnimation")
    }

    // ALTERNATIVE ANIMATION 1: Simple Draw-In Effect
    // This function provides a simpler animation where the lines just draw themselves once and then stop.
    // It's a good alternative if the continuous loop is too distracting.
    /*
    func startAnimationSimpleDraw() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 5.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Set the final state of the strokeEnd to 1 so the line stays visible after the animation
        bluePathLayer.strokeEnd = 1.0
        greenPathLayer.strokeEnd = 1.0
        redPathLayer.strokeEnd = 1.0
        
        // Stagger the animations for a more dynamic entrance
        bluePathLayer.add(animation, forKey: "drawBluePath")
        
        // By re-using the same animation object but adding it with a delay to different layers,
        // we can create a nice staggered effect without much extra code.
        animation.beginTime = CACurrentMediaTime() + 0.2
        greenPathLayer.add(animation, forKey: "drawGreenPath")

        animation.beginTime = CACurrentMediaTime() + 0.4
        redPathLayer.add(animation, forKey: "drawRedPath")
    }
    */

    // ALTERNATIVE ANIMATION 2: Reversing "Erase" Effect
    // This animation is similar to the seamless one, but it erases the line by retracting
    // from the end point back to the start point, rather than from the start point forward.
    /*
    private func applyReversingAnimation(to layer: CAShapeLayer, withDelay delay: CFTimeInterval) {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.duration = animationDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let strokeEndReverseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndReverseAnimation.fromValue = 1
        strokeEndReverseAnimation.toValue = 0
        strokeEndReverseAnimation.duration = animationDuration
        strokeEndReverseAnimation.beginTime = animationDuration // Start after the first animation
        strokeEndReverseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeEndAnimation, strokeEndReverseAnimation]
        animationGroup.duration = animationDuration * 2
        animationGroup.repeatCount = .infinity
        animationGroup.beginTime = CACurrentMediaTime() + delay
        
        layer.add(animationGroup, forKey: "reversingStrokeAnimation")
    }
    */
}

