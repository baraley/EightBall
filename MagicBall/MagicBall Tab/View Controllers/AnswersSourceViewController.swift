//
//  AnswersSourceViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class AnswerSourceViewController: UIViewController {

	var answerSourceViewModel: AnswerSourceViewModel {
		didSet {
			answerSourceViewModelDidChange()
		}
	}

	private lazy var answerSourcePickerView: UIPickerView = initializeAnswerSourcePickerView()

	// MARK: - Initialization

	init(answerSourceViewModel: AnswerSourceViewModel) {
		self.answerSourceViewModel = answerSourceViewModel

		super.init(nibName: nil, bundle: nil)

		answerSourceViewModelDidChange()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		initialSetup()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		answerSourcePickerView.reloadAllComponents()

	}

}

// MARK: - Private Methods

private extension AnswerSourceViewController {

	func initialSetup() {
		view.addSubview(answerSourcePickerView)

		answerSourcePickerView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}

	func initializeAnswerSourcePickerView() -> UIPickerView {
		let pickerView = UIPickerView()
		pickerView.delegate = self
		pickerView.dataSource = self

		return pickerView
	}

	func answerSourceViewModelDidChange() {
		answerSourceViewModel.answerSourceOptionsDidChangeHandler = { [weak self] in
			self?.answerSourcePickerView.reloadAllComponents()
			self?.answerSourcePickerView.selectRow(0, inComponent: 0, animated: false)
			self?.answerSourceViewModel.didSelectOption(at: 0)
		}
	}

}

// MARK: - UIPickerViewDataSource

extension AnswerSourceViewController: UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return answerSourceViewModel.numberOfOptions
	}

}

// MARK: - UIPickerViewDelegate

extension AnswerSourceViewController: UIPickerViewDelegate {

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

		return answerSourceViewModel.optionTitle(at: row)
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		answerSourceViewModel.didSelectOption(at: row)
	}

}
