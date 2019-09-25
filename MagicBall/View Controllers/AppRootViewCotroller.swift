//
//  AppRootViewCotroller.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class AppRootViewCotroller: UITabBarController {

	// MARK: - Private properties

	private lazy var settingsStore: SettingsStore = .init()
	private lazy var answerSetsStore: AnswerSetsStore = .init()

	private var magicBallViewController: MagicBallViewCotroller?
	private var settingsViewController: SettingsViewCotroller?

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}

}

// MARK: - Private

private extension AppRootViewCotroller {

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

			if let magicBallViewController = $0 as? MagicBallViewCotroller {

				self.magicBallViewController = magicBallViewController

				self.magicBallViewController?.tabBarItem.image = Asset.ballTabIcon.image

			} else if let navigationViewCotroller = $0 as? UINavigationController,
				let settingsViewCotroller = navigationViewCotroller.viewControllers[0] as? SettingsViewCotroller {

				self.settingsViewController = settingsViewCotroller

				navigationViewCotroller.tabBarItem.image = Asset.settingsTabIcon.image
			}
		})
	}

	func setupMagicBallViewController() {
		magicBallViewController?.settings = settingsStore.currentSettins
		magicBallViewController?.dataSource = MagicBallDataSource(
			answerSets: answerSetsStore.answerSets
		)
	}

	func setupSettingsViewController() {
		settingsViewController?.settings = settingsStore.currentSettins
		settingsViewController?.answerSetsStore = answerSetsStore

		settingsViewController?.settingsDidChangeAction = { [weak self] (settings) in
			guard let self = self else { return }

			self.settingsStore.save(settings)

			self.magicBallViewController?.settings = settings
		}
	}

}
