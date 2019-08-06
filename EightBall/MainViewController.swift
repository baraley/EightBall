//
//  MainViewController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit
import CoreFoundation

class MainViewController: UIViewController {
	
	@IBOutlet var answerLabel: UILabel!
	
	let answerLoader = AnswerLoader()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		answerLoader.loadAnswer { [weak self] (answer) in
			DispatchQueue.main.async {
				self?.answerLabel.text = answer
			}
		}
	}
	
	var start: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
	var end: CFAbsoluteTime = CFAbsoluteTimeGetCurrent() {
		didSet {
			let difference = end - start
			print(difference)
		}
	}
	
	override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		print("motionBegan")
		start = CFAbsoluteTimeGetCurrent()
	}
	
	override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		print("motionEnded")
		end = CFAbsoluteTimeGetCurrent()
	}
	
	override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
		print("motionCancelled")
		end = CFAbsoluteTimeGetCurrent()
	}
}
