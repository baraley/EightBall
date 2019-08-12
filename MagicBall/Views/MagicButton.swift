//
//  MagicButton.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/7/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class MagicButton: UIButton {
	
	override var isHighlighted: Bool {
		didSet {
			transform = isHighlighted ? CGAffineTransform.init(scaleX: 0.95, y: 0.95) : .identity
		}
	}
}
