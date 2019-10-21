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
	private let historyAnswersModel: HistoryAnswersModel
	private let answerSettingsModel: AnswerSettingsModel
	private let answerSetsModel: AnswerSetsModel
	private let answersCountingModel: AnswersCountingModel

	// MARK: - Initialization

	init(
		magicBallModel: MagicBallModel,
		answerSourcesModel: AnswerSourcesModel,
		historyAnswersModel: HistoryAnswersModel,
		answerSettingsModel: AnswerSettingsModel,
		answerSetsModel: AnswerSetsModel,
		answersCountingModel: AnswersCountingModel
	) {
		self.magicBallModel = magicBallModel
		self.answerSourcesModel = answerSourcesModel
		self.historyAnswersModel = historyAnswersModel
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
	private lazy var historyViewController = initializeHistoryTabViewController()
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

		viewControllers = [magicBallContainerViewController, historyViewController, settingsNavigationController]
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

	func initializeHistoryTabViewController() -> UINavigationController {
		let viewModel = HistoryAnswerContentListViewModel(historyAnswersModel: historyAnswersModel)
		let viewController = ContentListViewController(contentListViewModel: viewModel)
		viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)

		viewModel.didSelectItem = { selectedIndex in
			viewController.showAlert(with: viewModel.item(at: selectedIndex))
		}

		let navigationViewController = UINavigationController(rootViewController: viewController)
		navigationViewController.navigationBar.prefersLargeTitles = true

		return navigationViewController
	}

	func initializeSettingsViewController() -> SettingsViewController {
		let settingsViewModel = SettingsViewModel(
			answerSettingsModel: answerSettingsModel,
			answerSetsModel: answerSetsModel,
			answersCountingModel: answersCountingModel,
			didSelectAnswerSetsCellHandler: { [weak self] in
				self?.presentAnswerSetsContentListViewController()
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

	func presentAnswerSetsContentListViewController() {
		let viewModel = AnswerSetsContentListViewModel(answerSetsModel: answerSetsModel)
		viewModel.didSelectItem = { [unowned self] index in
			self.presentAnswersContentListViewControllerForAnswerSet(at: index)
		}

		let answerSetsContentListViewController = ContentListViewController(contentListViewModel: viewModel)

		settingsNavigationController.pushViewController(answerSetsContentListViewController, animated: true)
	}

	func presentAnswersContentListViewControllerForAnswerSet(at index: Int) {
		let answerSet = answerSetsModel.answerSet(at: index)
		let viewModel = AnswersContentListViewModel(answerSet: answerSet, answerSetsModel: answerSetsModel)
		let answersContentListViewController = ContentListViewController(contentListViewModel: viewModel)

		viewModel.didSelectItem = { [unowned answerSetsModel, unowned answersContentListViewController] selectedIndex in
			let answer = answerSetsModel.answerSet(at: index).answers[selectedIndex]
			let message = PresentableAnswer(answer).text

			answersContentListViewController.showAlert(with: message)
		}

		settingsNavigationController.pushViewController(answersContentListViewController, animated: true)
	}

}
