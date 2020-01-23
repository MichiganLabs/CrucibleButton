//
//  MLButton.swift
//  GOATButton
//
//  Created by John DeLong on 12/6/19.
//  Copyright © 2019 John DeLong. All rights reserved.
//

import UIKit

// https://www.raywenderlich.com/5294-how-to-make-a-custom-control-tutorial-a-reusable-knob

// Background in GREEN
// Content View in Purple
// Wrapper views in BLUE
// Main items in RED

@IBDesignable
class MLButton: UIControl {
    public enum Layout: String {
        static let `default` = Layout.horizontal

        case horizontal
        case vertical
    }

    /// Defines which side of the primary content (the title) should the secondary content (the icon)
    /// be placed.
    public enum Bias: String {
        static let `default` = Bias.leading

        case leading
        case trailing
    }

    /// Defines how the contents should be layed out within the button
    public enum Alignment: String {
        static let `default` = Alignment.spaceAround

        // In the following examples, I = icon, T = text, S = secondary

        /// [ I -- T -- ]
        /// [ I - T - S ]
        case spaceAround

        /// [ I ----- T ]
        /// [ I - T - S ]
        case spaceBetween

        /// [ I T ----- ]
        case start

        /// [ ----- I T ]
        case end

        /// [ -- I T -- ]
        case center

        /// [ I TTTTTTT ]
        case stretch
    }

    public enum TextAlign {
        static let `default` = TextAlign.center

        case left
        case center
        case right
        case justify
    }


    @IBInspectable
    public var layoutString : String {
        set { self.layout = Layout(rawValue: newValue)! }
        get { return self.layout.rawValue }
    }

    public var layout: Layout = .default {
        didSet {
            self.refresh()
        }
    }

    @IBInspectable
    public var biasString : String {
        set { self.bias = Bias(rawValue: newValue)! }
        get { return self.bias.rawValue }
    }

    /// Determines the position of the content within the button
    public var bias: Bias = .default {
        didSet {
            self.refresh()
        }
    }

    @IBInspectable
    public var alignmentString : String {
        set { self.alignment = Alignment(rawValue: newValue)! }
        get { return self.alignment.rawValue }
    }

    public var alignment: Alignment = .default {
        didSet {
            self.refresh()
        }
    }

    public var textAlign: TextAlign = .default {
        didSet {
            self.refresh()
        }
    }

    public var contentEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            self.layoutMargins = self.contentEdgeInsets
        }
    }

    /// The minimum distance between items in the button
    public var itemSpacing: CGFloat = 8

    @IBInspectable
    public var image: UIImage? = nil {
        didSet {
            self.refresh()
        }
    }

    @IBInspectable
    public var image2: UIImage? = nil {
        didSet {
            self.refresh()
        }
    }

    public var imageSize: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            self.refresh()
        }
    }

    private lazy var animator = UIViewPropertyAnimator(
        duration: self.animationDuration,
        dampingRatio: self.dampingRatio,
        animations: nil
    )

    private var renderer = MLButtonRenderer()

    /// The main title of the button
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Button"
        label.textAlignment = .center

//        label.setContentHuggingPriority(.required, for: .horizontal)
//        label.setContentHuggingPriority(.required, for: .vertical)

        label.backgroundColor = .red

        return label
    }()

    // MARK: Button Title
    private var titles = [UInt: String]()
    public func setTitle(_ title: String?, for state: UIControl.State) {
        self.titles[state.rawValue] = title
        self.updateTitle()
    }

    private func updateTitle() {
        self.titleLabel.text = self.titles[self.state.rawValue]
    }

    // MARK: Button Center View
    private var centerViews = [UInt: UIView]()
    public func setCenterView(_ view: UIView, for state: UIControl.State) {
        self.centerViews[state.rawValue] = view
    }

    private var observerBag = [NSKeyValueObservation]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    override var isSelected: Bool {
        didSet {
            print("is selected")
        }
    }

    deinit {
        // Not sure if this is required or not to clean up our observers
        self.observerBag.removeAll()
    }

    private func commonInit() {
//        self.observerBag.append(self.observe(\.state, changeHandler: self.styleHandler))

//        self.isEnabled = false

        self.renderer.setup(view: self)

        self.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        self.refresh()
    }

//    private func styleHandler(button: MLButton, observer: NSKeyValueObservedChange<UIControl.State>) {
//        print("test")
//    }

    // ViewDidLoad ?? (awakeFromNib)
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        self.commonAwakeFromNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonAwakeFromNib()
    }

    private func commonAwakeFromNib() {
        self.renderer.applyBackgroundColors(parentView: self)
    }

    private func refresh() {
        let centerView = self.centerViews[self.state.rawValue] ?? self.titleLabel

        // set views
        self.renderer.setViews(centerView: centerView, primaryView: UIView(), secondaryView: UIView())

        // set sizing

        // arrange views

        self.renderer.arrange(
            layout: self.layout,
            bias: self.bias,
            alignment: self.alignment,
            textAlign: self.textAlign,
            itemSpacing: self.itemSpacing,
            image: self.image,
            image2: self.image2,
            imageSize: self.imageSize
        )
    }

    enum BackgroundDescription {
        case gradient(colors: [UIColor])
        case image(image: UIImage)
        case solid(color: UIColor)
    }

    open func setBackgroundDescription(_ description: BackgroundDescription, for state: UIControl.State) {

    }
}


// MARK: Animations
extension MLButton {

    var scaleFactor: CGFloat { return -0.1 }
    var animationDuration: TimeInterval { return 0.25 }
    var dampingRatio: CGFloat { return 0.9 }

//    private func percent(for touch: UITouch?) -> CGFloat {
//        guard let touch = touch else { return 0 }
//        let force: CGFloat
//        if touch.force == 0 {
//            force = 1
//        } else {
//            force = touch.force
//        }
//
//        return log(1 + force)
//    }

//    private func transform(for touch: UITouch?) -> CGAffineTransform {
//        return self.scale(for: touch)
//    }
//
//    private func scale(for touch: UITouch?) -> CGAffineTransform {
//        guard let touch = touch else { return .identity }
//        let scale = 1 + (self.scaleFactor * self.percent(for: touch))
//        return CGAffineTransform(scaleX: scale, y: scale)
//    }

    private func interruptibleAnimations(for touch: UITouch?) {
        self.backgroundColor = self.state == UIControl.State.normal ? .yellow : .purple
    }

    private func nonInterruptibleAnimations() {
        self.titleLabel.textColor = self.state == UIControl.State.normal ? .green : .red
    }

    private func startNonInterruptibleAnimation() {
        UIView.transition(with: self.titleLabel, duration: self.animationDuration, options: .transitionCrossDissolve, animations: {
            self.nonInterruptibleAnimations()
        }, completion: nil)
    }

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)

        self.animator.addAnimations {
            self.interruptibleAnimations(for: touch)
        }
        self.animator.startAnimation()

        self.startNonInterruptibleAnimation()

        return result
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.continueTracking(touch, with: event)

        self.animator.addAnimations {
            self.interruptibleAnimations(for: touch)
        }

        if !self.animator.isRunning {
            self.animator.startAnimation()
        }

        return result
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)

        self.animator.addAnimations {
            self.interruptibleAnimations(for: touch)
        }

        if !self.animator.isRunning {
            self.animator.startAnimation()
        }

        self.startNonInterruptibleAnimation()
    }

    open override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)

        self.animator.addAnimations {
            self.interruptibleAnimations(for: nil)
        }

        if !self.animator.isRunning {
            self.animator.startAnimation()
        }

        self.startNonInterruptibleAnimation()
    }
}
