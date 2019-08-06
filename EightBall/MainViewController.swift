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
	
	let answerLoader = AnswerLoader()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		answerLoader.loadAnswer { [weak self] (answer) in
			DispatchQueue.main.async {
				self?.answerLabel.text = answer
			}
		}
	}
}

