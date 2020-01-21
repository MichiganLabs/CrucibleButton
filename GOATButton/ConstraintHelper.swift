import UIKit

extension NSLayoutConstraint {
    func priority(_ value: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = value
        return self
    }
}

class ConstraintHelper {
    enum Edge {
        case left, right, top, bottom
    }

    enum Operator {
        case equalTo, greaterThanOrEqualTo
    }

    static func constrain(
        child: UIView,
        _ `operator`: Operator,
        toEdges edge: Edge,
        ofParentLayoutGuide parent: UILayoutGuide
    ) -> NSLayoutConstraint {
        switch edge {
        case .left:
            switch `operator` {
            case .equalTo:
                return child.leftAnchor.constraint(equalTo: parent.leftAnchor)
            case .greaterThanOrEqualTo:
                return child.leftAnchor.constraint(greaterThanOrEqualTo: parent.leftAnchor)
            }
        case .right:
            switch `operator` {
            case .equalTo:
                return parent.rightAnchor.constraint(equalTo: child.rightAnchor)
            case .greaterThanOrEqualTo:
                return parent.rightAnchor.constraint(greaterThanOrEqualTo: child.rightAnchor)
            }
        case .top:
            switch `operator` {
            case .equalTo:
                return child.topAnchor.constraint(equalTo: parent.topAnchor)
            case .greaterThanOrEqualTo:
                return child.topAnchor.constraint(greaterThanOrEqualTo: parent.topAnchor)
            }
        case .bottom:
            switch `operator` {
            case .equalTo:
                return parent.bottomAnchor.constraint(equalTo: child.bottomAnchor)
            case .greaterThanOrEqualTo:
                return parent.bottomAnchor.constraint(greaterThanOrEqualTo: child.bottomAnchor)
            }
        }
    }


    static func constrain(child: UIView, _ operator: Operator, toEdgesOfView parent: UIView) {
        self.constrain(child: child, `operator`, to: .horizontal, edgesOfView: parent)
        self.constrain(child: child, `operator`, to: .vertical, edgesOfView: parent)
    }

    static func constrain(
        child: UIView,
        _ `operator`: Operator, // pin to edges if true, else be inside edges
        to layout: NSLayoutConstraint.Axis,
        edgesOfView parent: UIView
    ) {
        switch layout {
        case .horizontal:
            switch `operator` {
            case .equalTo:
                child.leftAnchor
                    .constraint(equalTo: parent.layoutMarginsGuide.leftAnchor)
                    .isActive = true

                parent.layoutMarginsGuide.rightAnchor
                    .constraint(equalTo: child.rightAnchor)
                    .isActive = true
            case .greaterThanOrEqualTo:
                child.leftAnchor
                    .constraint(greaterThanOrEqualTo: parent.layoutMarginsGuide.leftAnchor)
                    .isActive = true

                parent.layoutMarginsGuide.rightAnchor
                    .constraint(greaterThanOrEqualTo: child.rightAnchor)
                    .isActive = true
            }
        case .vertical:
            switch `operator` {
            case .equalTo:
                child.topAnchor
                    .constraint(equalTo: parent.layoutMarginsGuide.topAnchor)
                    .isActive = true

                parent.layoutMarginsGuide.bottomAnchor
                    .constraint(equalTo: child.bottomAnchor)
                    .isActive = true

            case .greaterThanOrEqualTo:
                child.topAnchor
                    .constraint(greaterThanOrEqualTo: parent.layoutMarginsGuide.topAnchor)
                    .isActive = true

                parent.layoutMarginsGuide.bottomAnchor
                    .constraint(greaterThanOrEqualTo: child.bottomAnchor)
                    .isActive = true
            }
        }
    }

    static func constrain(child: UIView, to layout: NSLayoutConstraint.Axis, edgesOfView parent: UIView, withPriority priority: UILayoutPriority) {
        switch layout {
        case .horizontal:
            child.leftAnchor
                .constraint(equalTo: parent.layoutMarginsGuide.leftAnchor)
                .priority(priority)
                .isActive = true

            parent.layoutMarginsGuide.rightAnchor
                .constraint(equalTo: child.rightAnchor)
                .priority(priority)
                .isActive = true
        case .vertical:
            child.topAnchor
                .constraint(equalTo: parent.layoutMarginsGuide.topAnchor)
                .priority(priority)
                .isActive = true

            parent.layoutMarginsGuide.bottomAnchor
                .constraint(equalTo: child.bottomAnchor)
                .priority(priority)
                .isActive = true
        }
    }

    static func removeConstraintsFromView(_ parent: UIView, to child: UIView) {
        parent.removeConstraints(parent.constraints.filter({ constraint -> Bool in
            constraint.firstItem === child || constraint.secondItem === child
        }))
    }
}
