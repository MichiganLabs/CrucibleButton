import UIKit

/**
 This class will keep track of the code associated with rendering the button.
 That will add a clear separation between the control and its internals.
 */
class MLButtonRenderer {
    /// Holds all of the contents of the button
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple

        view.layoutMargins = .zero

        return view
    }()

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.accessibilityIdentifier = "Main Stack View"

        return stackView
    }()

    /// A view that contains the title
    lazy var titleWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .blue

        view.addSubview(self.titleLabel)

        return view
    }()

    /// The main title of the button
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Button"
        label.textAlignment = .center

        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)

        label.backgroundColor = .red

        return label
    }()

    /// The main icon of the button
    let iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue

        let image = UIImage(named: "favorite_active")
        view.image = image

        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)

        return view
    }()

    let iconView2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue

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
        self.constrainTitleLabel(alignment: alignment, layout: layout)

        self.constraintMainStackView(
            alignment: alignment,
            bias: bias,
            layout: layout,
            itemSpacing: itemSpacing
        )
    }

    private func constrainTitleLabel(alignment: MLButton.Alignment, layout: MLButton.Layout) {
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
            child: self.titleLabel,
            .equalTo,
            to: strongConstraintLayout,
            edgesOfView: self.titleWrapper
        )

        let `operator`: ConstraintHelper.Operator = alignment == .stretch ? .equalTo : .greaterThanOrEqualTo

        ConstraintHelper.constrain(
            child: self.titleLabel,
            `operator`,
            to: weakConstraintLayout,
            edgesOfView: self.titleWrapper
        )

        if `operator` == .greaterThanOrEqualTo {
            ConstraintHelper.constrain(
                child: self.titleLabel,
                to: weakConstraintLayout,
                edgesOfView: self.titleWrapper,
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

            if layout == .horizontal {
                self.titleLabel.centerXAnchor
                    .constraint(equalTo: self.containerView.centerXAnchor)
                    .priority(.defaultHigh)
                    .isActive = true
            } else if layout == .vertical {
                self.titleLabel.centerYAnchor
                    .constraint(equalTo: self.containerView.centerYAnchor)
                    .priority(.defaultHigh)
                    .isActive = true
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

            if layout == .horizontal {
                self.titleLabel.centerXAnchor
                    .constraint(equalTo: self.containerView.centerXAnchor)
                    .priority(.defaultHigh)
                    .isActive = true
            } else {
                self.titleLabel.centerYAnchor
                    .constraint(equalTo: self.containerView.centerYAnchor)
                    .priority(.defaultHigh)
                    .isActive = true
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

            self.mainStackView.addArrangedSubview(self.titleWrapper)

            if secondaryImage != nil {
                self.mainStackView.addArrangedSubview(self.iconView2)
            }
        case .trailing:
            if secondaryImage != nil {
                self.mainStackView.addArrangedSubview(self.iconView2)
            }

            self.mainStackView.addArrangedSubview(self.titleWrapper)

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

        // Remove all of the constraints between the title and the container
        ConstraintHelper.removeConstraintsFromView(self.containerView, to: self.titleLabel)

        // Remove all of the constraints between the title and it's wrapper
        ConstraintHelper.removeConstraintsFromView(self.titleWrapper, to: self.titleLabel)
    }
}

