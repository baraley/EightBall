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

	var generator: UINotificationFeedbackGenerator!
	var magicBallViewModel: MagicBallViewModel! {
		didSet {
			magicBallViewModelDidChange()
		}
	}

	@IBOutlet private weak var magicBallView: MagicBallView!

	// MARK: - UIResponder

	override var canBecomeFirstResponder: Bool {
		return true
	}

	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		guard magicBallView.animationState == .showingEnded else { return }

		generateHapticFeedbackIfNeeds()
		magicBallViewModel.shakeWasDetected()
	}

	// MARK: - Actions

	@IBAction private func magicButtonDidTap() {
		guard magicBallView.animationState == .showingEnded else { return }

		generateHapticFeedbackIfNeeds()
		magicBallViewModel.tapWasDetected()
	}

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		becomeFirstResponder()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		magicBallViewModel.viewDidDisappear()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		resignFirstResponder()
	}

}

// MARK: - Private

private extension MagicBallViewController {

	func setup() {

		magicBallView.state =  magicBallViewModel.messageState
		magicBallViewModelDidChange()

		magicBallView.animationStateDidChangeHandler = { [weak self] state in
			if state == .showingEnded, self?.view.window != nil {
				self?.magicBallViewModel?.didFinishMessageShowing()
			}
		}
	}

	func magicBallViewModelDidChange() {
		guard isViewLoaded else { return }

		magicBallView.isUserInteractionEnabled = magicBallViewModel.isTapAllowed

		magicBallViewModel.messageStateDidChangeHandler = { [weak self] messageState in
			self?.magicBallView.state =  messageState
		}
	}

	func generateHapticFeedbackIfNeeds() {
		if magicBallViewModel.hapticFeedbackIsOn {
			generator.notificationOccurred(.success)
		}
	}

}
