//
//  NetworkAnswer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

struct NetworkAnswer: Decodable, Equatable {

	struct Magic: Equatable {
		let question, answer, type: String
	}

	let magic: Magic

	enum CodingKeys: String, CodingKey {
		case magic
	}

}

extension NetworkAnswer.Magic: Decodable {

	enum CodingKeys: String, CodingKey {
		case question, answer, type
	}

}
