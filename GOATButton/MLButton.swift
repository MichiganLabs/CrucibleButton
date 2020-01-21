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

    private var renderer = MLButtonRenderer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.renderer.setup(view: self)

        self.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        self.refresh()
    }

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
        self.backgroundColor = .green
    }

    private func refresh() {
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

    open func setTitle(_ title: String?, for state: UIControl.State) {

    }

    enum BackgroundDescription {
        case gradient(colors: [UIColor])
        case image(image: UIImage)
        case solid(color: UIColor)
    }

    open func setBackgroundDescription(_ description: BackgroundDescription, for state: UIControl.State) {
    }
}
