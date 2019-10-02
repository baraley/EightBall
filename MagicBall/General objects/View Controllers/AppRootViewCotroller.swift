//
//  AppRootViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class AppRootViewController: UITabBarController {

	var magicBallModel: MagicBallModel
	var answerSourcesModel: AnswerSourcesModel
	var answerSettingsModel: AnswerSettingsModel
	var answerSetsModel: AnswerSetsModel

	init(
		magicBallModel: MagicBallModel,
		answerSourcesModel: AnswerSourcesModel,
		answerSettingsModel: AnswerSettingsModel,
		answerSetsModel: AnswerSetsModel
	) {
		self.magicBallModel = magicBallModel
		self.answerSourcesModel = answerSourcesModel
		self.answerSettingsModel = answerSettingsModel
		self.answerSetsModel = answerSetsModel

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private properties

	private lazy var magicBallContainerViewController = initializeMagicBallContainerViewController()
	private lazy var settingsNavigationController = initializeSettingsNavigationController()

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

		viewControllers = [magicBallContainerViewController, settingsNavigationController]
	}

	func initializeMagicBallContainerViewController() -> MagicBallContainerViewController {
		let viewController = StoryboardScene.Main.magicBallContainerViewController.instantiate()

		viewController.tabBarItem.title = L10n.TabBar.Title.magicBall
		viewController.tabBarItem.image = Asset.ballTabIcon.image

		viewController.magicBallModel = magicBallModel
		viewController.answerSourceModel = answerSourcesModel
		viewController.answerSettingsModel = answerSettingsModel

		return viewController
	}

	func initializeSettingsNavigationController() -> UINavigationController {
		let viewController = StoryboardScene.Main.settingsNavigationController.instantiate()

		viewController.tabBarItem.title = L10n.TabBar.Title.settings
		viewController.tabBarItem.image = Asset.settingsTabIcon.image

		if let settingsViewController = viewController.viewControllers[0] as? SettingsViewController {
			setup(settingsViewController)
		}

		return viewController
	}

	func setup(_ viewController: SettingsViewController) {
		viewController.settingsViewModel = SettingsViewModel(
			answerSettingsModel: answerSettingsModel,
			answerSetsModel: answerSetsModel,
			didSelectAnswerSetsCellHandler: { [weak self] in
				self?.presentAnswerSetsEditableListViewController()
		})
	}

	func presentAnswerSetsEditableListViewController() {
		let viewModel = AnswerSetsEditableListViewModel(answerSetsModel: answerSetsModel)
		viewModel.didSelectItem = { [weak self] index in
			self?.presentAnswersEditableListViewControllerForAnswerSet(at: index)
		}

		let answerSetsEditableListViewController = StoryboardScene.Main.editableListViewController.instantiate()
		answerSetsEditableListViewController.editableListViewModel = viewModel

		settingsNavigationController.pushViewController(answerSetsEditableListViewController, animated: true)
	}

	func presentAnswersEditableListViewControllerForAnswerSet(at index: Int) {
		let answerSet = answerSetsModel.answerSet(at: index).toPresentableAnswerSet()
		let answersEditableListViewController = StoryboardScene.Main.editableListViewController.instantiate()

		let viewModel = AnswersEditableListViewModel(answerSet: answerSet, answerSetsModel: answerSetsModel)

		viewModel.didSelectItem = { [unowned answerSetsModel, unowned answersEditableListViewController] selectedIndex in
			let message = answerSetsModel.answerSet(at: index).answers[selectedIndex].toPresentableAnswer().text
			let alertPresenter = MessageAlertPresenter(message: message, actionTitle: L10n.Action.Title.ok)

			alertPresenter.present(in: answersEditableListViewController)
		}

		answersEditableListViewController.editableListViewModel = viewModel
		settingsNavigationController.pushViewController(answersEditableListViewController, animated: true)
	}

}
