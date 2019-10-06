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
	private lazy var magicBallView: MagicBallView = .init()

	// MARK: - Initialization

	init(
		magicBallViewModel: MagicBallViewModel,
		generator: UINotificationFeedbackGenerator = .init()
	) {
		self.magicBallViewModel = magicBallViewModel
		self.generator = generator

		super.init(nibName: nil, bundle: nil)

		magicBallViewModelDidChange()
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

	func initialSetup() {

		view.addSubview(magicBallView)

		magicBallView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}

		magicBallView.answerState =  magicBallViewModel.messageState

		magicBallView.animationStateDidChangeHandler = { [weak self] state in
			if state == .showingEnded, self?.view.window != nil {
				self?.magicBallViewModel.handleMessageShowingDidFinish()
			}
		}
		magicBallView.magicButton.addTarget(self, action: #selector(magicButtonDidTap), for: .touchUpInside)
	}

	func magicBallViewModelDidChange() {
		guard isViewLoaded else { return }

		magicBallView.isUserInteractionEnabled = magicBallViewModel.isTapAllowed

		magicBallViewModel.messageStateDidChangeHandler = { [weak self] messageState in
			self?.magicBallView.answerState =  messageState
		}
	}

	func generateHapticFeedbackIfNeeds() {
		if magicBallViewModel.hapticFeedbackIsOn {
			generator.notificationOccurred(.success)
		}
	}

}
