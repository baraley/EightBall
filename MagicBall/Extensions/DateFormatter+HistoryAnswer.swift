//
//  DateFormatter+HistoryAnswer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

extension DateFormatter {

	static var presentableHistoryAnswerFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		formatter.locale = Locale(identifier: "en_US")

		return formatter
	}

}
