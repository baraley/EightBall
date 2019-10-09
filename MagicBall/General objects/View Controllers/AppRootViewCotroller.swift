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

	private let magicBallModel: MagicBallModel
	private let answerSourcesModel: AnswerSourcesModel
	private let answerSettingsModel: AnswerSettingsModel
	private let answerSetsModel: AnswerSetsModel
	private let answersCountingModel: AnswersCountingModel

	// MARK: - Initialization

	init(
		magicBallModel: MagicBallModel,
		answerSourcesModel: AnswerSourcesModel,
		answerSettingsModel: AnswerSettingsModel,
		answerSetsModel: AnswerSetsModel,
		answersCountingModel: AnswersCountingModel
	) {
		self.magicBallModel = magicBallModel
		self.answerSourcesModel = answerSourcesModel
		self.answerSettingsModel = answerSettingsModel
		self.answerSetsModel = answerSetsModel
		self.answersCountingModel = answersCountingModel

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

	func initializeSettingsViewController() -> SettingsViewController {
		let settingsViewModel = SettingsViewModel(
			answerSettingsModel: answerSettingsModel,
			answerSetsModel: answerSetsModel,
			answersCountingModel: answersCountingModel,
			didSelectAnswerSetsCellHandler: { [weak self] in
				self?.presentAnswerSetsEditableListViewController()
		})

		let viewController = SettingsViewController(settingsViewModel: settingsViewModel)
		viewController.title = L10n.SettingsViewController.title

		return viewController
	}

	func initializeSettingsNavigationController() -> UINavigationController {
		let settingsViewController = initializeSettingsViewController()
		let viewController = UINavigationController(rootViewController: settingsViewController)

		viewController.tabBarItem.title = L10n.TabBar.Title.settings
		viewController.tabBarItem.image = Asset.settingsTabIcon.image
		viewController.navigationBar.prefersLargeTitles = true

		return viewController
	}

	// MARK: - Answer Sets Editing Flow

	func presentAnswerSetsEditableListViewController() {
		let viewModel = AnswerSetsEditableListViewModel(answerSetsModel: answerSetsModel)
		viewModel.didSelectItem = { [unowned self] index in
			self.presentAnswersEditableListViewControllerForAnswerSet(at: index)
		}

		let answerSetsEditableListViewController = EditableListViewController(editableListViewModel: viewModel)

		settingsNavigationController.pushViewController(answerSetsEditableListViewController, animated: true)
	}

	func presentAnswersEditableListViewControllerForAnswerSet(at index: Int) {
		let answerSet = answerSetsModel.answerSet(at: index).toPresentableAnswerSet()
		let viewModel = AnswersEditableListViewModel(answerSet: answerSet, answerSetsModel: answerSetsModel)
		let answersEditableListViewController = EditableListViewController(editableListViewModel: viewModel)

		viewModel.didSelectItem = { [unowned answerSetsModel, unowned answersEditableListViewController] selectedIndex in
			let message = answerSetsModel.answerSet(at: index).answers[selectedIndex].toPresentableAnswer().text

			answersEditableListViewController.showAlert(with: message)
		}

		settingsNavigationController.pushViewController(answersEditableListViewController, animated: true)
	}

}
