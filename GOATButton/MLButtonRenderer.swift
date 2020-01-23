import UIKit

/**
 This class will keep track of the code associated with rendering the button.
 That will add a clear separation between the control and its internals.
 */
class MLButtonRenderer {
    let isDebug = true

    /// Holds all of the contents of the button
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .purple

        view.layoutMargins = .zero

        return view
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.accessibilityIdentifier = "Main Stack View"

        return stackView
    }()

    /// A view that contains the title
    private lazy var centerViewWrapper: UIView = {
        let view = UIView()
//        view.backgroundColor = .blue

        return view
    }()



    /// The main icon of the button
    let iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .blue

        let image = UIImage(named: "favorite_active")
        view.image = image

        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)

        return view
    }()

    let iconView2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .blue

        let image = UIImage(named: "favorite_active")
        view.image = image

        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)

        return view
    }()

    func setup(view: UIView) {
        // Add the container view to the parent view
        view.addSubview(self.containerView)
        ConstraintHelper.constrain(child: self.containerView, .equalTo, toEdgesOfView: view)

        // Add the stack view to the container view
        self.containerView.addSubview(self.mainStackView)
    }

    var centerView: UIView? {
        willSet {
            if newValue != self.centerView {
                self.centerView?.removeFromSuperview()


                if let view = newValue {
                    view.translatesAutoresizingMaskIntoConstraints = false

                    // Out of all the elements in the button, the center view (although should condense if it can) should have
                    // the least amount of compression in comparision to the other elements
                    view.setContentHuggingPriority(UILayoutPriority(rawValue: 950), for: .horizontal)
                    view.setContentHuggingPriority(UILayoutPriority(rawValue: 950), for: .vertical)

                    self.centerViewWrapper.addSubview(view)
                }
            }
        }
    }

    var primaryView = UIView()
    var secondaryView = UIView()

    func setViews(centerView: UIView, primaryView: UIView, secondaryView: UIView) {
        self.centerView = centerView
        self.primaryView = primaryView
        self.secondaryView = secondaryView
    }

    func arrange(
        layout: MLButton.Layout,
        bias: MLButton.Bias,
        alignment: MLButton.Alignment,
        textAlign: MLButton.TextAlign,
        itemSpacing: CGFloat,
        image: UIImage?,
        image2: UIImage?,
        imageSize: CGSize
    ) {
        // Remove constraints
        self.resetViews()

        self.iconView.image = image
        self.iconView2.image = image2

        self.arrangeItems(bias: bias, primaryImage: image, secondaryImage: image2)

        // Constrain the title label
        self.constrainCenterView(alignment: alignment, layout: layout)

        self.constraintMainStackView(
            alignment: alignment,
            bias: bias,
            layout: layout,
            itemSpacing: itemSpacing
        )
    }

    func applyBackgroundColors(parentView: UIView) {
        parentView.backgroundColor = self.isDebug ? .green : .clear
        self.containerView.backgroundColor = self.isDebug ? .purple : .clear
        self.centerViewWrapper.backgroundColor = self.isDebug ? .blue : .clear
    }

    private func constrainCenterView(alignment: MLButton.Alignment, layout: MLButton.Layout) {
        guard let centerView = self.centerView else { return }

        let strongConstraintLayout: NSLayoutConstraint.Axis
        let weakConstraintLayout: NSLayoutConstraint.Axis

        if layout == .horizontal {
            strongConstraintLayout = .vertical
            weakConstraintLayout = .horizontal
        } else {
            strongConstraintLayout = .horizontal
            weakConstraintLayout = .vertical
        }

        ConstraintHelper.constrain(
            child: centerView,
            .equalTo,
            to: strongConstraintLayout,
            edgesOfView: self.centerViewWrapper
        )

        let `operator`: ConstraintHelper.Operator = alignment == .stretch ? .equalTo : .greaterThanOrEqualTo

        ConstraintHelper.constrain(
            child: centerView,
            `operator`,
            to: weakConstraintLayout,
            edgesOfView: self.centerViewWrapper
        )

        if `operator` == .greaterThanOrEqualTo {
            ConstraintHelper.constrain(
                child: centerView,
                to: weakConstraintLayout,
                edgesOfView: self.centerViewWrapper,
                withPriority: .defaultLow
            )
        }
    }

    private func constraintMainStackView(
        alignment: MLButton.Alignment,
        bias: MLButton.Bias,
        layout: MLButton.Layout,
        itemSpacing: CGFloat
    ) {
        self.mainStackView.spacing = itemSpacing

        // Default values
        self.mainStackView.alignment = .center
        self.mainStackView.distribution = .fill

        if layout == .vertical {
            self.mainStackView.axis = .vertical
        } else if layout == .horizontal {
            self.mainStackView.axis = .horizontal
        }

        switch alignment {
        case .start:
            let start: ConstraintHelper.Edge
            let end: ConstraintHelper.Edge
            let constraintLayout: NSLayoutConstraint.Axis

            if layout == .horizontal {
                start = .left
                end = .right
                constraintLayout = .vertical
            } else {
                start = .top
                end = .bottom
                constraintLayout = .horizontal
            }

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .equalTo,
                to: constraintLayout,
                edgesOfView: self.containerView
            )

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .equalTo,
                toEdges: start,
                ofParentLayoutGuide: self.containerView.layoutMarginsGuide
            ).isActive = true

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .greaterThanOrEqualTo,
                toEdges: end,
                ofParentLayoutGuide: self.containerView.layoutMarginsGuide
            ).isActive = true

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .greaterThanOrEqualTo,
                toEdges: end,
                ofParentLayoutGuide: self.containerView.layoutMarginsGuide
            ).priority(UILayoutPriority(rawValue: 1))
            .isActive = true

        case .end:
            let start: ConstraintHelper.Edge
            let end: ConstraintHelper.Edge
            let constraintLayout: NSLayoutConstraint.Axis

            if layout == .horizontal {
                start = .left
                end = .right
                constraintLayout = .vertical
            } else {
                start = .top
                end = .bottom
                constraintLayout = .horizontal
            }

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .equalTo,
                to: constraintLayout,
                edgesOfView: self.containerView
            )

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .greaterThanOrEqualTo,
                toEdges: start,
                ofParentLayoutGuide: self.containerView.layoutMarginsGuide
            ).isActive = true

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .equalTo,
                toEdges: start,
                ofParentLayoutGuide: self.containerView.layoutMarginsGuide
            ).priority(UILayoutPriority(rawValue: 1))
            .isActive = true

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .equalTo,
                toEdges: end,
                ofParentLayoutGuide: self.containerView.layoutMarginsGuide
            ).isActive = true

        case .stretch:
            ConstraintHelper.constrain(child: self.mainStackView, .equalTo, toEdgesOfView: self.containerView)

        case .spaceAround:
            ConstraintHelper.constrain(child: self.mainStackView, .equalTo, toEdgesOfView: self.containerView)

            if let centerView = self.centerView {
                if layout == .horizontal {
                    centerView.centerXAnchor
                        .constraint(equalTo: self.containerView.centerXAnchor)
                        .priority(.defaultHigh)
                        .isActive = true
                } else if layout == .vertical {
                    centerView.centerYAnchor
                        .constraint(equalTo: self.containerView.centerYAnchor)
                        .priority(.defaultHigh)
                        .isActive = true
                }
            }

        case .spaceBetween:
            ConstraintHelper.constrain(child: self.mainStackView, .equalTo, toEdgesOfView: self.containerView)

            self.mainStackView.distribution = .equalSpacing

        case .center:

            let weakConstraintLayout: NSLayoutConstraint.Axis
            let strongConstraintLayout: NSLayoutConstraint.Axis

            if layout == .horizontal {
                weakConstraintLayout = .horizontal
                strongConstraintLayout = .vertical
            } else {
                weakConstraintLayout = .vertical
                strongConstraintLayout = .horizontal
            }

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .greaterThanOrEqualTo,
                to: weakConstraintLayout,
                edgesOfView: self.containerView
            )

            ConstraintHelper.constrain(
                child: self.mainStackView,
                to: weakConstraintLayout,
                edgesOfView: self.containerView,
                withPriority: UILayoutPriority(rawValue: 1)
            )

            ConstraintHelper.constrain(
                child: self.mainStackView,
                .equalTo,
                to: strongConstraintLayout,
                edgesOfView: self.containerView
            )

            if let centerView = self.centerView {
                if layout == .horizontal {
                    centerView.centerXAnchor
                        .constraint(equalTo: self.containerView.centerXAnchor)
                        .priority(.defaultHigh)
                        .isActive = true
                } else {
                    centerView.centerYAnchor
                        .constraint(equalTo: self.containerView.centerYAnchor)
                        .priority(.defaultHigh)
                        .isActive = true
                }
            }
        }
    }

    private func arrangeItems(bias: MLButton.Bias, primaryImage: UIImage?, secondaryImage: UIImage?) {
        // Add constraints to position the icon and title
        switch bias {
        case .leading:
            if primaryImage != nil {
                self.mainStackView.addArrangedSubview(self.iconView)
            }

            self.mainStackView.addArrangedSubview(self.centerViewWrapper)

            if secondaryImage != nil {
                self.mainStackView.addArrangedSubview(self.iconView2)
            }
        case .trailing:
            if secondaryImage != nil {
                self.mainStackView.addArrangedSubview(self.iconView2)
            }

            self.mainStackView.addArrangedSubview(self.centerViewWrapper)

            if primaryImage != nil {
                self.mainStackView.addArrangedSubview(self.iconView)
            }
        }
    }

    private func resetViews() {
        // Remove all of the constraints connecting the stack view to the container view
        ConstraintHelper.removeConstraintsFromView(self.containerView, to: self.mainStackView)

        // Remove all items in the stack view. Don't worry, we'll add them back :)
        self.mainStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }

        if let centerView = self.centerView {
            // Remove all of the constraints between the title and the container
            ConstraintHelper.removeConstraintsFromView(self.containerView, to: centerView)

            // Remove all of the constraints between the title and it's wrapper
            ConstraintHelper.removeConstraintsFromView(self.centerViewWrapper, to: centerView)
        }
    }
}
