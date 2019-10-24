//
//  Change.swift
//  MagicBall
//
//  Created by Alexander Baraley on 21.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

enum Change<T> {

	case insert(T, Int)
	case delete(T, Int)
	case move(T, Int, Int)
	case update(T, Int)

}
