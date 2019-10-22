//
//  MagicButton.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/7/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class MagicButton: UIButton {

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupShadow()
		setupMotionEffect()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override var isHighlighted: Bool {
		didSet {
			transform = isHighlighted ? CGAffineTransform.init(scaleX: 0.95, y: 0.95) : .identity
		}
	}

	func updateShadow() {
		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2).cgPath
	}

	// MARK: - Private

	private func setupShadow() {
		layer.shadowColor = UIColor.systemPurple.cgColor
		layer.shadowOpacity = 0.7
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowRadius = 10.0
	}

	private func setupMotionEffect() {
		let effectGroup = UIMotionEffectGroup()
		effectGroup.motionEffects = positionEffectsWith(offset: 30.0) + shadowEffectsWith(offset: 50.0)

		addMotionEffect(effectGroup)
	}

	private func positionEffectsWith(offset: CGFloat) -> [UIInterpolatingMotionEffect] {
		let positionHorizontalEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
		let positionVerticalEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)

		positionHorizontalEffect.minimumRelativeValue = offset
		positionHorizontalEffect.maximumRelativeValue = -offset

		positionVerticalEffect.minimumRelativeValue = offset
		positionVerticalEffect.maximumRelativeValue = -offset

		return [positionVerticalEffect, positionHorizontalEffect]
	}

	private func shadowEffectsWith(offset: CGFloat) -> [UIInterpolatingMotionEffect] {
		let hKeyPath = "layer.shadowOffset.width"
		let vKeyPath = "layer.shadowOffset.height"

		let shadowHorizontalEffect = UIInterpolatingMotionEffect(keyPath: hKeyPath, type: .tiltAlongHorizontalAxis)
		let shadowVerticalEffect = UIInterpolatingMotionEffect(keyPath: vKeyPath, type: .tiltAlongVerticalAxis)

		shadowHorizontalEffect.minimumRelativeValue = offset
		shadowHorizontalEffect.maximumRelativeValue = -offset

		shadowVerticalEffect.minimumRelativeValue = offset
		shadowVerticalEffect.maximumRelativeValue = -offset

		return [shadowVerticalEffect, shadowHorizontalEffect]
	}

}
