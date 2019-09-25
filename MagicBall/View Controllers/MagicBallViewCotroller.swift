//
//  MagicBallViewCotroller.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

private let initialMessage = L10n.initialMagicScreenMessage

final class MagicBallViewCotroller: UIViewController {

	// MARK: - Public properties

	var settings: Settings! {
		didSet {
			settingsDidChange()
		}
	}
	var dataSource: MagicBallDataSource! {
		didSet {
			dataSourceDidChange()
		}
	}

	// MARK: - Outlets

	@IBOutlet private weak var magicBallView: MagicBallView!
	@IBOutlet private weak var answerSourcePickerView: UIPickerView!

	// MARK: - Private properties

	private let textPronoucer: TextPronouncer = .init()
	private lazy var generator: UINotificationFeedbackGenerator = .init()

	// MARK: - UIResponder

	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		requestNewAnswer()
	}

	// MARK: - Actions

	@IBAction private func requestNewAnswer() {
		guard magicBallView.isAnimationFinished == true else { return }

		if settings.hapticFeedbackIsOn {
			generator.notificationOccurred(.success)
		}

		magicBallView.state = .answerHidden
		textPronoucer.stopPronouncing()

		dataSource.findNewAnswer()
	}

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		settingsDidChange()
		dataSourceDidChange()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		textPronoucer.stopPronouncing()
	}

}

// MARK: - Private

private extension MagicBallViewCotroller {

	func settingsDidChange() {
		guard isViewLoaded else { return }

		magicBallView.isUserInteractionEnabled = settings.lazyModeIsOn
	}

	func dataSourceDidChange() {
		guard isViewLoaded else { return }

		magicBallView.state = .initialMessage(initialMessage)

		answerSourcePickerView.dataSource = dataSource
		answerSourcePickerView.delegate = dataSource
		answerSourcePickerView.reloadAllComponents()
		answerSourcePickerView.selectRow(0, inComponent: 0, animated: false)

		dataSource.answerDidFindHandler = { [weak self] result in
			switch result {
			case .success(let answer):	self?.showAnswer(answer)
			case .failure(let error):	self?.showAlert(for: error)
			}
		}
	}

	func showAnswer(_ answer: String) {
		if settings.readAnswerIsOn {
			magicBallView.appearingAnimationDidFinishHandler = { [weak self] in
				self?.textPronoucer.pronounce(answer)
			}
		}
		magicBallView.state = .answerShown(answer)
	}

	func showAlert(for error: NetworkError) {

		let alert = UIAlertController(
			title: nil, message: error.errorDescription, preferredStyle: .alert
		)

		alert.addAction(UIAlertAction(title: L10n.Action.Title.ok, style: .default) { _ in
			self.magicBallView.state = .initialMessage(initialMessage)
		})

		self.present(alert, animated: true, completion: nil)
	}

}
