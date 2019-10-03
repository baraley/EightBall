//
//  MagicBallView.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let animationDuration: TimeInterval = 0.7

final class MagicBallView: UIView {

	enum State {
		case hidden
		case shown(PresentableAnswer)
	}

	enum AnimationState {
		case hidingBegun, hidingEnded, showingBegun, showingEnded
	}

	var state: State = .hidden {
		didSet {
			stateDidChange()
		}
	}

	private(set) var animationState: AnimationState = .showingEnded {
		didSet {
			magicButton.isUserInteractionEnabled = animationState == .showingEnded
			animationStateDidChangeHandler?(animationState)
		}
	}

	var animationStateDidChangeHandler: ((AnimationState) -> Void)?

	// MARK: - Private properties -

	@IBOutlet private weak var answerLabel: UILabel!
	@IBOutlet private weak var magicButton: MagicButton!

	private var currentAnimation: UIViewPropertyAnimator? {
		didSet {
			currentAnimation?.addCompletion({ (_) in
				self.currentAnimation = nil
			})
		}
	}

}

// MARK: - Private

private extension MagicBallView {

	func stateDidChange() {
		switch state {
		case .hidden:
			currentAnimation = hidingAnimation
			currentAnimation?.startAnimation()

		case .shown(let answer):
			if let currentAnimation = currentAnimation {
				currentAnimation.addCompletion { (_) in
					self.showAnswer(answer.text)
				}
			} else {
				showAnswer(answer.text)
			}
		}
	}

	func showAnswer(_ answer: String) {
		answerLabel.text = answer
		currentAnimation = showingAnimation
		currentAnimation?.startAnimation()
	}

	// MARK: - Property Animators

	var hidingAnimation: UIViewPropertyAnimator {
		let animation = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut) {
			self.answerLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

			self.magicButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
			self.magicButton.transform = CGAffineTransform.identity

			self.animationState = .hidingBegun
		}
		animation.addCompletion({ (_) in
			self.animationState = .hidingEnded
		})

		return animation
	}

	var showingAnimation: UIViewPropertyAnimator {
		let animation = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut) {
			self.answerLabel.transform = .identity
			self.animationState = .showingBegun
		}

		animation.addCompletion({ (_) in
			self.animationState = .showingEnded
		})

		return animation
	}

}
