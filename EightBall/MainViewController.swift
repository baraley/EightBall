//
//  MainViewController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	@IBOutlet var answerLabel: UILabel!
	
	private let answerLoader: AnswerLoader = .init()
	
	// MARK: - Shake time maesuring
	
	private var start: TimeInterval = 0
	
	private var end: TimeInterval = 0 {
		didSet {
			let difference = end - start
			print(difference)
		}
	}
	
	// MARK: - UIResponder
	
	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		print("motionBegan")
		start = Date().timeIntervalSince1970
	}
	
	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		print("motionEnded")
		end = Date().timeIntervalSince1970
		requestNewAnswer()
	}
	
	override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		print("motionCancelled")
		end = Date().timeIntervalSince1970
	}
	
	// MARK: - Private
	
	private func requestNewAnswer() {
		guard answerLoader.isLoading == false else { return }
		
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		answerLoader.loadAnswer { [weak self] (answer) in
			DispatchQueue.main.async {
				UIApplication.shared.isNetworkActivityIndicatorVisible = false
				self?.answerLabel.text = answer
			}
		}
	}
}
