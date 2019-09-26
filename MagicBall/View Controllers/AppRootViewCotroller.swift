//
//  AppRootViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class AppRootViewController: UITabBarController {

	// MARK: - Private properties

	private lazy var settingsStore: SettingsStore = .init()
	private lazy var answerSetsStore: AnswerSetsStore = .init()

	private var magicBallViewController: MagicBallViewController?
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
		setupMagicBallViewController()
		setupSettingsViewController()

		answerSetsStore.answerSetsDidChangeHandler = { [weak self]  in
			guard let self = self else { return }

			self.setupMagicBallViewController()
		}
	}

	func parseViewControllers() {
		viewControllers?.forEach({

			if let magicBallViewController = $0 as? MagicBallViewController {

				self.magicBallViewController = magicBallViewController

				self.magicBallViewController?.tabBarItem.image = Asset.ballTabIcon.image

			} else if let navigationViewController = $0 as? UINavigationController,
				let settingsViewController = navigationViewController.viewControllers[0] as? SettingsViewController {

				self.settingsViewController = settingsViewController

				navigationViewController.tabBarItem.image = Asset.settingsTabIcon.image
			}
		})
	}

	func setupMagicBallViewController() {
		magicBallViewController?.settings = settingsStore.currentSettings
		magicBallViewController?.dataSource = MagicBallDataSource(
			answerSets: answerSetsStore.answerSets
		)
	}

	func setupSettingsViewController() {
		settingsViewController?.settings = settingsStore.currentSettings
		settingsViewController?.answerSetsStore = answerSetsStore

		settingsViewController?.settingsDidChangeAction = { [weak self] (settings) in
			guard let self = self else { return }

			self.settingsStore.save(settings)

			self.magicBallViewController?.settings = settings
		}
	}

}
