//
//  SingleComponentPickerViewConfigurator.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/12/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class SingleComponentPickerViewConfigurator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
	
	var optionsTitles: [String]
	private let optionDidPickedHandler: ((Int) -> Void)
	
	init(optionsTitles: [String] = [], optionDidPickedHandler: @escaping ((Int) -> Void)) {
		self.optionsTitles = optionsTitles
		self.optionDidPickedHandler = optionDidPickedHandler
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return optionsTitles.count
	}
	
	func pickerView(_ pickerView: UIPickerView,
					titleForRow row: Int,
					forComponent component: Int) -> String? {
		
		return optionsTitles[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		optionDidPickedHandler(row)
	}
}
