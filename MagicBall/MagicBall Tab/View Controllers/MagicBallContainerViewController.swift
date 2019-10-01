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
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch StoryboardSegue.Main(segue) {
		case .magicBallViewController:

			magicBallViewController = segue.destination as? MagicBallViewController
			magicBallViewController?.generator = UINotificationFeedbackGenerator()
			magicBallViewController?.magicBallViewModel = MagicBallViewModel(
				magicBallModel: magicBallModel,
				answerSettingsModel: answerSettingsModel
			)

		case .answerSourceViewController:
			answerSourceViewController = segue.destination as? AnswerSourceViewController
			answerSourceViewController?.answerSourceViewModel = AnswerSourceViewModel(
				answerSourceModel: answerSourceModel
			)

		default:
			fatalError("Unhandled segue was performed: \(segue)")
		}
	}

	func showAlert(with message: String) {

		let alert = UIAlertController(
			title: nil, message: message, preferredStyle: .alert
		)

		alert.addAction(UIAlertAction(title: L10n.Action.Title.ok, style: .default))

		self.present(alert, animated: true, completion: nil)
	}
}
