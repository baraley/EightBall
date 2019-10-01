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
	private var settingsViewController: SettingsViewController?

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
	}

	func parseViewControllers() {
		viewControllers?.forEach({

			if let magicBallContainerViewController = $0 as? MagicBallContainerViewController {

				self.magicBallContainerViewController = magicBallContainerViewController

			} else if let navigationViewController = $0 as? UINavigationController,
				let settingsViewController = navigationViewController.viewControllers[0] as? SettingsViewController {

				self.settingsViewController = settingsViewController

				navigationViewController.tabBarItem.image = Asset.settingsTabIcon.image
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

	func setupSettingsViewController() {

	}

}
