//
//  MagicBallViewController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class MagicBallViewController: UIViewController {
	
	// MARK: - Public properties
	
	var settingsModel: SettingsModel!
	
	// MARK: - Outlets
	
	@IBOutlet private var magicBallView: MagicBallView!
	
	// MARK: - Private properties
	
	private let answerLoader: AnswerLoader = .init()
	
	// MARK: - UIResponder
	
	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		requestNewAnswer()
	}
	
	// MARK: - Actions
	
	@IBAction private func requestNewAnswer() {
		guard magicBallView.isAnimationFinished == true else { return }
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		magicBallView.state = .loadingAnswer
		
		answerLoader.loadAnswer { [weak self] (answer) in
			guard let self = self else {
				return
			}
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				
				self.magicBallView.state = .showingAnswer(answer ?? "Hell yeah!!!")
			}
		}
	}
}
