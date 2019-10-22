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
		static let insetValue: CGFloat = 20
	}

	enum MagicButton {
		static let widthSizeMultiplier: CGFloat = 0.6
		static let yPositionMultiplier: CGFloat = 1.6
	}

	static let animationDuration: TimeInterval = 0.7

}

final class MagicBallView: UIView {

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupSubviews()
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
	var answersNumber: Int = 0 {
		didSet {
			numberLabel.text = String(answersNumber)
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

	private lazy var answerLabelLayoutWrapper = UIView()
	private lazy var answerLabel: UILabel = initializeAnswerLabel()
	private lazy var numberLabel: UILabel = initializeObtainedAnswersLabel()

	private var currentAnimation: UIViewPropertyAnimator? {
		didSet {
			currentAnimation?.addCompletion({ (_) in
				self.currentAnimation = nil
			})
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		magicButton.updateShadow()
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

// MARK: - State Changes

private extension MagicBallView {

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

// MARK: - Setup

private extension MagicBallView {

	func setupSubviews() {
		answerLabelLayoutWrapper.addSubview(numberLabel)
		answerLabelLayoutWrapper.addSubview(answerLabel)
		addSubview(answerLabelLayoutWrapper)
		addSubview(magicButton)
	}

	func setupLayout() {

		answerLabelLayoutWrapper.snp.makeConstraints { (make) in
			make.leading.top.trailing.equalToSuperview()
			make.bottom.equalTo(magicButton.snp.top)
		}

		numberLabel.snp.makeConstraints { (make) in
			make.top.equalTo(answerLabelLayoutWrapper.snp_topMargin)
			make.trailing.equalTo(answerLabelLayoutWrapper.snp_trailingMargin)
		}

		answerLabel.snp.makeConstraints { (make) in
			make.leading.greaterThanOrEqualTo(Constants.AnswerLabel.insetValue)
			make.trailing.lessThanOrEqualTo(-Constants.AnswerLabel.insetValue)
			make.center.equalToSuperview()
		}

		magicButton.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(Constants.MagicButton.widthSizeMultiplier)
			make.height.equalTo(self.magicButton.snp.width)
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().multipliedBy(Constants.MagicButton.yPositionMultiplier)
		}
	}

	func initializeObtainedAnswersLabel() -> UILabel {
		let label = UILabel()
		label.textAlignment = .center
		label.adjustsFontForContentSizeCategory = true
		label.font = UIFont.preferredFont(forTextStyle: .body)

		return label
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
		let button = MagicButton(frame: .zero)
		button.setImage(Asset.ballImage.image, for: .normal)

		return button
	}

}
