//
//  AppRootVC.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/9/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class AppRootVC: UITabBarController {
	
	// MARK: - Private properties
		
	private lazy var settingsStore: SettingsStore = .init()
	
	private lazy var answerSetsStore: AnswerSetsStore = .init()
	
	private var magicBallViewController: MagicBallVC?
	
	private var settingsViewController: SettingsVC?
	
	// MARK: - Life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
}

// MARK: - Private
private extension AppRootVC {
	
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
			
			if let magicBallVC = $0 as? MagicBallVC {
				
				magicBallViewController = magicBallVC
				
			} else if let navVC = $0 as? UINavigationController,
				let settingsVC = navVC.viewControllers[0] as? SettingsVC {
				
				settingsViewController = settingsVC
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
