//
//  ContentListViewModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

protocol ContentListViewModel: UITableViewDataSource {

	var listTitle: String { get }
	var nameOfItems: String { get }

	var didSelectItem: ((_ index: Int) -> Void)? { get }

	var isChangesProvider: Bool { get }
	var changesHandler: (([ContentListViewController.Change]) -> Void)? { get set }

	var isCreationAvailable: Bool { get }
	var isEditAvailable: Bool { get }
	var isDeleteAvailable: Bool { get }

	func numberOfItems() -> Int
	func item(at index: Int) -> String
	func updateItem(at index: Int, with text: String)
	func createNewItem(with text: String)
	func deleteItem(at index: Int)

}

extension ContentListViewModel {

	var isChangesProvider: Bool { return false }
	var changesHandler: (([ContentListViewController.Change]) -> Void)? { return nil }

	var isCreationAvailable: Bool { return false }
	var isEditAvailable: Bool { return false }
	var isDeleteAvailable: Bool { return false }

	func updateItem(at index: Int, with text: String) { }
	func createNewItem(with text: String) { }
	func deleteItem(at index: Int) { }

}
