//
//  MagicBallViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let initialMessage = L10n.initialMagicScreenMessage

final class MagicBallViewController: UIViewController {

	var magicBallViewModel: MagicBallViewModel {
		didSet {
			magicBallViewModelDidChange()
		}
	}

	private var generator: UINotificationFeedbackGenerator
	private lazy var magicBallView: MagicBallView = initializeMagicBallView()

	// MARK: - Initialization

	init(
		magicBallViewModel: MagicBallViewModel,
		generator: UINotificationFeedbackGenerator = .init()
	) {
		self.magicBallViewModel = magicBallViewModel
		self.generator = generator

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - UIResponder

	override var canBecomeFirstResponder: Bool {
		return true
	}

	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		guard magicBallView.answerAnimationState == .showingEnded else { return }

		generateHapticFeedbackIfNeeds()
		magicBallViewModel.shakeWasDetected()
	}

	// MARK: - Actions

	@objc
	private func magicButtonDidTap() {
		guard magicBallView.answerAnimationState == .showingEnded else { return }

		generateHapticFeedbackIfNeeds()
		magicBallViewModel.tapWasDetected()
	}

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		initialSetup()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		becomeFirstResponder()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		magicBallViewModel.endHandlingMessageShowing()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		resignFirstResponder()
	}

}

// MARK: - Private Methods

private extension MagicBallViewController {

	func initializeMagicBallView() -> MagicBallView {
		let initializedView = MagicBallView()

		view.addSubview(initializedView)

		initializedView.snp.makeConstraints { $0.edges.equalToSuperview() }
		initializedView.animationStateDidChangeHandler = { [unowned self] state in
			if state == .showingEnded, self.view.window != nil {
				self.magicBallViewModel.handleMessageShowingDidFinish()
				self.magicBallView.answersNumber = self.magicBallViewModel.obtainedAnswersNumber
			}
		}

		return initializedView
	}

	func initialSetup() {

		magicBallView.answerState =  magicBallViewModel.state
		magicBallView.answersNumber = magicBallViewModel.obtainedAnswersNumber
		magicBallView.magicButton.addTarget(self, action: #selector(magicButtonDidTap), for: .touchUpInside)

		magicBallViewModelDidChange()
	}

	func magicBallViewModelDidChange() {
		guard isViewLoaded else { return }

		magicBallView.isUserInteractionEnabled = magicBallViewModel.isTapAllowed

		magicBallViewModel.changesHandler = { [weak self] change in
			self?.handleMagicBallViewModelChange(change)
		}
	}

	func handleMagicBallViewModelChange(_ change: MagicBallViewModel.Change) {
		switch change {
		case .answerNumber(let number):
			if magicBallView.answerAnimationState == .showingEnded {
				magicBallView.answersNumber = number
			}
		case .messageState(let state):
			magicBallView.answerState =  state
		}
	}

	func generateHapticFeedbackIfNeeds() {
		if magicBallViewModel.hapticFeedbackIsOn {
			generator.notificationOccurred(.success)
		}
	}

}
