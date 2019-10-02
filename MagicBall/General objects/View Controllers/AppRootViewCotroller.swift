//
//  AppRootViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class AppRootViewController: UITabBarController {

	var magicBallModel: MagicBallModel!
	var answerSourcesModel: AnswerSourcesModel!
	var answerSettingsModel: AnswerSettingsModel!
	var answerSetsModel: AnswerSetsModel!

	// MARK: - Private properties

	private let tabBarViewController: UITabBarController = .init()
	private var magicBallContainerViewController: MagicBallContainerViewController?
	private var settingsNavigationController: UINavigationController?

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}

}

// MARK: - Private

private extension AppRootViewController {

	func setup() {
		view.backgroundColor = .white

		parseViewControllers()
		setupMagicBallContainerViewController()
		setupSettingsNavigationController()
	}

	func parseViewControllers() {
		viewControllers?.forEach({

			if let magicBallContainerViewController = $0 as? MagicBallContainerViewController {

				self.magicBallContainerViewController = magicBallContainerViewController

			} else if let navigationViewController = $0 as? UINavigationController {

				self.settingsNavigationController = navigationViewController
			}
		})
	}

	func setupMagicBallContainerViewController() {
		magicBallContainerViewController?.tabBarItem.title = L10n.TabBar.Title.magicBall
		magicBallContainerViewController?.tabBarItem.image = Asset.ballTabIcon.image

		magicBallContainerViewController?.magicBallModel = magicBallModel
		magicBallContainerViewController?.answerSourceModel = answerSourcesModel
		magicBallContainerViewController?.answerSettingsModel = answerSettingsModel
	}

	func setupSettingsNavigationController() {
		settingsNavigationController?.tabBarItem.title = L10n.TabBar.Title.settings
		settingsNavigationController?.tabBarItem.image = Asset.settingsTabIcon.image

		if let settingsViewController = settingsNavigationController?.viewControllers[0] as? SettingsViewController {
			settingsViewController.settingsViewModel = SettingsViewModel(
				answerSettingsModel: answerSettingsModel,
				answerSetsModel: answerSetsModel,
				didSelectAnswerSetsCellHandler: { [weak self] in
					self?.presentAnswerSetsEditableListViewController()
			})
		}
	}

	func presentAnswerSetsEditableListViewController() {
		let viewModel = AnswerSetsEditableListViewModel(answerSetsModel: answerSetsModel)
		viewModel.didSelectItem = { [weak self] index in
			self?.presentAnswersEditableListViewControllerForAnswerSet(at: index)
		}

		let answerSetsEditableListViewController = StoryboardScene.Main.editableListViewController.instantiate()
		answerSetsEditableListViewController.editableListViewModel = viewModel

		settingsNavigationController?.pushViewController(answerSetsEditableListViewController, animated: true)
	}

	func presentAnswersEditableListViewControllerForAnswerSet(at index: Int) {
		let answerSet = answerSetsModel.answerSet(at: index)
		let answersEditableListViewController = StoryboardScene.Main.editableListViewController.instantiate()

		let viewModel = AnswersEditableListViewModel(
			answerSet: answerSet,
			answersDidChangeHandler: { [weak self] answers in
				let updatedAnswerSet = AnswerSet(id: answerSet.id, name: answerSet.name, answers: answers)
				self?.answerSetsModel.save(updatedAnswerSet)
		})
		viewModel.didSelectItem = { [unowned answersEditableListViewController] index in

			let presenter = MessageAlertPresenter(message: answerSet.answers[index], actionTitle: L10n.Action.Title.ok)
			presenter.present(in: answersEditableListViewController)
		}

		answersEditableListViewController.editableListViewModel = viewModel
		settingsNavigationController?.pushViewController(answersEditableListViewController, animated: true)
	}

}
