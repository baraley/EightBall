//
//  MagicBallView.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private enum Constants {

	enum AnswerLabel {
		static let numberOfLines = 4
		static let minimumScaleFactor: CGFloat = 0.5
		static let leadingInset: CGFloat = 20
		static let trailingInset: CGFloat = -20
	}

	enum MagicButton {
		static let widthSizeMultiplier: CGFloat = 0.3
		static let yPositionMultiplier: CGFloat = 1.5
	}

	static let animationDuration: TimeInterval = 0.7

}

final class MagicBallView: UIView {

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public properties

	var answerState: AnswerState = .hidden {
		didSet {
			stateDidChange()
		}
	}

	private(set) lazy var magicButton: MagicButton = initializeMagicButton()
	private(set) var answerAnimationState: AnswerAnimationState = .showingEnded {
		didSet {
			magicButton.isUserInteractionEnabled = answerAnimationState == .showingEnded
			animationStateDidChangeHandler?(answerAnimationState)
		}
	}

	var animationStateDidChangeHandler: ((AnswerAnimationState) -> Void)?

	// MARK: - Private properties

	private var answerLabelLayoutWrapper: UIView = .init()
	private lazy var answerLabel: UILabel = initializeAnswerLabel()

	private var currentAnimation: UIViewPropertyAnimator? {
		didSet {
			currentAnimation?.addCompletion({ (_) in
				self.currentAnimation = nil
			})
		}
	}

}

// MARK: - Types

extension MagicBallView {

	enum AnswerState {
		case hidden, shown(PresentableAnswer)
	}

	enum AnswerAnimationState {
		case hidingBegun, hidingEnded, showingBegun, showingEnded
	}

}

// MARK: - Property Animators

private extension MagicBallView {

	var hidingAnimation: UIViewPropertyAnimator {
		let animation = UIViewPropertyAnimator(duration: Constants.animationDuration, curve: .easeInOut) {
			self.answerLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

			self.magicButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
			self.magicButton.transform = CGAffineTransform.identity

			self.answerAnimationState = .hidingBegun
		}
		animation.addCompletion({ (_) in
			self.answerAnimationState = .hidingEnded
		})

		return animation
	}

	var showingAnimation: UIViewPropertyAnimator {
		let animation = UIViewPropertyAnimator(duration: Constants.animationDuration, curve: .easeInOut) {
			self.answerLabel.transform = .identity
			self.answerAnimationState = .showingBegun
		}

		animation.addCompletion({ (_) in
			self.answerAnimationState = .showingEnded
		})

		return animation
	}

}

// MARK: - Private Methods

private extension MagicBallView {

	func setupLayout() {

		answerLabelLayoutWrapper.addSubview(answerLabel)
		addSubview(answerLabelLayoutWrapper)
		addSubview(magicButton)

		answerLabelLayoutWrapper.snp.makeConstraints { (make) in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalTo(magicButton.snp.top)
		}

		answerLabel.snp.makeConstraints { (make) in
			make.leading.greaterThanOrEqualTo(Constants.AnswerLabel.leadingInset)
			make.trailing.lessThanOrEqualTo(Constants.AnswerLabel.trailingInset)
			make.center.equalToSuperview()
		}

		magicButton.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(Constants.MagicButton.widthSizeMultiplier)
			make.height.equalTo(self.magicButton.snp.width)
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().multipliedBy(Constants.MagicButton.yPositionMultiplier)
		}
	}

	func initializeAnswerLabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = Constants.AnswerLabel.numberOfLines
		label.textAlignment = .center
		label.adjustsFontForContentSizeCategory = true
		label.adjustsFontSizeToFitWidth = true
		label.minimumScaleFactor = Constants.AnswerLabel.minimumScaleFactor
		label.font = UIFont.preferredFont(forTextStyle: .title1)

		return label
	}

	func initializeMagicButton() -> MagicButton {
		let button = MagicButton(type: .custom)
		button.setImage(Asset.ballImage.image, for: .normal)

		return button
	}

	func stateDidChange() {
		switch answerState {
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

}
