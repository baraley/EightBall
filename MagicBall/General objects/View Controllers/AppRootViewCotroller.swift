//
//  AppRootViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit
import SnapKit

final class AppRootViewController: UITabBarController {

	var magicBallModel: MagicBallModel
	var answerSourcesModel: AnswerSourcesModel
	var answerSettingsModel: AnswerSettingsModel
	var answerSetsModel: AnswerSetsModel

	// MARK: - Initialization

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

	// MARK: - Child View Controllers

	private lazy var magicBallContainerViewController = initializeMagicBallContainerViewController()
	private lazy var settingsNavigationController = initializeSettingsNavigationController()

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		initialSetup()
	}

}

// MARK: - Private

private extension AppRootViewController {

	// MARK: - Setup

	func initialSetup() {
		view.backgroundColor = .white

		viewControllers = [magicBallContainerViewController, settingsNavigationController]
	}

	func setup(_ viewController: SettingsViewController) {
		viewController.settingsViewModel = SettingsViewModel(
			answerSettingsModel: answerSettingsModel,
			answerSetsModel: answerSetsModel,
			didSelectAnswerSetsCellHandler: { [weak self] in
				self?.presentAnswerSetsEditableListViewController()
		})
	}

	// MARK: - Properties Initialization

	func initializeMagicBallContainerViewController() -> MagicBallContainerViewController {
		let viewController = MagicBallContainerViewController(
			magicBallModel: magicBallModel,
			answerSourceModel: answerSourcesModel,
			answerSettingsModel: answerSettingsModel
		)

		viewController.tabBarItem.title = L10n.TabBar.Title.magicBall
		viewController.tabBarItem.image = Asset.ballTabIcon.image

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

	// MARK: - Answer Sets Editing Flow

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

			answersEditableListViewController.showAlert(with: message)
		}

		answersEditableListViewController.editableListViewModel = viewModel
		settingsNavigationController.pushViewController(answersEditableListViewController, animated: true)
	}

}
