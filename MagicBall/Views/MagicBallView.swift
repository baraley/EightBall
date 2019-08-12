//
//  MagicBallView.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let animationDuration: TimeInterval = 0.7

class MagicBallView: UIView {
	
	// MARK: - Types
	
	enum MagicBallState {
		case initialMessage(String)
		case answerHidden
		case answerShown(String)
	}
	
	// MARK: - Outlets
	
	@IBOutlet private var answerLabel: UILabel!
	@IBOutlet private var magicButton: MagicButton!
	
	// MARK: - Public properties
	
	var state: MagicBallState = .initialMessage("") {
		didSet {
			stateDidChange()
		}
	}
	
	private(set) var isAnimationFinished: Bool = true {
		didSet {
			magicButton.isUserInteractionEnabled = isAnimationFinished
		}
	}
	
	var animationFinishedCompletionHandler: (() -> Void)?
	
	// MARK: - Private properties
	
	private var currentAnimation: UIViewPropertyAnimator? {
		didSet {
			if currentAnimation != nil {
				isAnimationFinished = false
			}
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
		case .initialMessage(let message):
			answerLabel.text = message
		case .answerHidden:
			currentAnimation = disappearingAnimation
			currentAnimation?.startAnimation()
			
		case .answerShown(let answerText):
			if let currentAnimation = currentAnimation {
				currentAnimation.addCompletion { (_) in
					self.showAnswer(answerText)
				}
			} else {
				showAnswer(answerText)
			}
		}
	}
	
	func showAnswer(_ answer: String) {
		answerLabel.text = answer
		currentAnimation = appearingAnimation
		currentAnimation?.startAnimation()
	}
	
	// MARK: - Property Animators
	
	var disappearingAnimation: UIViewPropertyAnimator {
		return UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut) {
			self.answerLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
			
			self.magicButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
			self.magicButton.transform = CGAffineTransform.identity
		}
	}
	
	var appearingAnimation: UIViewPropertyAnimator {
		let animation = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut) {
			self.answerLabel.transform = .identity
		}
		animation.addCompletion({ (_) in
			self.isAnimationFinished = true
			self.animationFinishedCompletionHandler?()
		})
		return animation
	}
}
