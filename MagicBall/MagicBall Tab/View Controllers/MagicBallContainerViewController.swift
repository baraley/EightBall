//
//  MagicBallContainerViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 01.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class MagicBallContainerViewController: UIViewController {

	var magicBallModel: MagicBallModel!
	var answerSourceModel: AnswerSourcesModel!
	var answerSettingsModel: AnswerSettingsModel!

	private var magicBallViewController: MagicBallViewController?
	private var answerSourceViewController: AnswerSourceViewController?

	override func viewDidLoad() {
		super.viewDidLoad()

		answerSourceModel.answerLoadingErrorHandler = { [weak self] errorMessage in
			self?.showAlert(with: errorMessage)
		}

		answerSettingsModel.addObserver(self)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch StoryboardSegue.Main(segue) {
		case .magicBallViewController:

			magicBallViewController = segue.destination as? MagicBallViewController
			magicBallViewController?.generator = UINotificationFeedbackGenerator()
			magicBallViewController?.magicBallViewModel = magicBallViewModel()

		case .answerSourceViewController:
			answerSourceViewController = segue.destination as? AnswerSourceViewController
			answerSourceViewController?.answerSourceViewModel = AnswerSourceViewModel(
				answerSourceModel: answerSourceModel
			)

		default:
			fatalError("Unhandled segue was performed: \(segue)")
		}
	}

	private func showAlert(with message: String) {
		let alertPresenter = MessageAlertPresenter(message: message, actionTitle: L10n.Action.Title.ok)

		alertPresenter.present(in: self)
	}

	private func magicBallViewModel() -> MagicBallViewModel {
		let settings = answerSettingsModel.settings.toPresentableSettings()
		return MagicBallViewModel(magicBallModel: magicBallModel, settings: settings)
	}
}

extension MagicBallContainerViewController: AnswerSettingsObserver {

	func answerSettingsModelSettingsDidChange(_ model: AnswerSettingsModel) {
		magicBallViewController?.magicBallViewModel = magicBallViewModel()
	}
}
