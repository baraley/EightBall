//
//  PredefinedAnswersTableViewController.swift
//  EightBall
//
//  Created by Alexander Baraley on 8/11/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

class PredefinedAnswersTableViewController: UITableViewController {
	
	var predefinedAnswersModelController: PredefinedAnswersModelController! {
		didSet {
			tableView.dataSource = predefinedAnswersModelController
		}
	}
	
	
}
