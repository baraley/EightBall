// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let answerSourceViewController = SceneType<MagicBall.AnswerSourceViewController>(storyboard: Main.self, identifier: "AnswerSourceViewController")

    internal static let editableListViewController = SceneType<MagicBall.EditableListViewController>(storyboard: Main.self, identifier: "EditableListViewController")

    internal static let magicBallContainerViewController = SceneType<MagicBall.MagicBallContainerViewController>(storyboard: Main.self, identifier: "MagicBallContainerViewController")

    internal static let magicBallViewController = SceneType<MagicBall.MagicBallViewController>(storyboard: Main.self, identifier: "MagicBallViewController")

    internal static let settingsNavigationController = SceneType<UIKit.UINavigationController>(storyboard: Main.self, identifier: "SettingsNavigationController")

    internal static let settingsViewController = SceneType<MagicBall.SettingsViewController>(storyboard: Main.self, identifier: "SettingsViewController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
