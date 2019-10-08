//
//  MagicBallContainerViewController.swift
//  MagicBall
//
//  Created by Alexander Baraley on 01.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

final class MagicBallContainerViewController: UIViewController {

	private let magicBallModel: MagicBallModel
	private let answerSourceModel: AnswerSourcesModel
	private let answerSettingsModel: AnswerSettingsModel

	// MARK: - Initialization

	init(
		magicBallModel: MagicBallModel,
		answerSourceModel: AnswerSourcesModel,
		answerSettingsModel: AnswerSettingsModel
	) {

		self.magicBallModel = magicBallModel
		self.answerSourceModel = answerSourceModel
		self.answerSettingsModel = answerSettingsModel

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Child View Controllers

	private lazy var magicBallViewController: MagicBallViewController = .init(
		magicBallViewModel: initializeMagicBallViewModel()
	)
	private lazy var answerSourceViewController: AnswerSourceViewController = .init(
		answerSourceViewModel: AnswerSourceViewModel(answerSourceModel: answerSourceModel)
	)

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		initialSetup()
	}

}

// MARK: - Private Methods

private extension MagicBallContainerViewController {

	// MARK: - Setup

	func initialSetup() {
		setupModels()
		setupUI()
	}

	func setupModels() {
		answerSettingsModel.addObserver(self)

		answerSourceModel.answerLoadingErrorHandler = { [weak self] errorMessage in
			self?.showAlert(with: errorMessage)
		}
	}

	func setupUI() {
		add(magicBallViewController)
		add(answerSourceViewController)

		let stackView = initializeContainerStackView()
		view.addSubview(stackView)

		stackView.snp.makeConstraints { (make) in
			make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
		}
	}

	// MARK: - Properties Initialization

	func initializeContainerStackView() -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: [magicBallViewController.view, answerSourceViewController.view])
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fill

		return stackView
	}

	func initializeMagicBallViewModel() -> MagicBallViewModel {
		let settings = answerSettingsModel.settings.toPresentableSettings()
		return MagicBallViewModel(magicBallModel: magicBallModel, settings: settings)
	}

}

// MARK: - AnswerSettingsObserver

extension MagicBallContainerViewController: AnswerSettingsObserver {

	func answerSettingsModelSettingsDidChange(_ model: AnswerSettingsModel) {
		magicBallViewController.magicBallViewModel = initializeMagicBallViewModel()
	}
}
