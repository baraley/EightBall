// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Shake your phone, please!!!
  internal static let initialMagicScreenMessage = L10n.tr("Localization", "initialMagicScreenMessage")
  /// Answers form network
  internal static let networkAnswerSourceTitle = L10n.tr("Localization", "networkAnswerSourceTitle")

  internal enum Action {
    internal enum Title {
      /// Add
      internal static let add = L10n.tr("Localization", "action.title.add")
      /// Cancel
      internal static let cancel = L10n.tr("Localization", "action.title.cancel")
      /// Create
      internal static let create = L10n.tr("Localization", "action.title.create")
      /// Delete
      internal static let delete = L10n.tr("Localization", "action.title.delete")
      /// OK
      internal static let ok = L10n.tr("Localization", "action.title.ok")
      /// Rename
      internal static let rename = L10n.tr("Localization", "action.title.rename")
      /// Reset
      internal static let reset = L10n.tr("Localization", "action.title.reset")
      /// Save
      internal static let save = L10n.tr("Localization", "action.title.save")
    }
  }

  internal enum Alert {
    internal enum Message {
      /// Are you sure you want to delete "%@"?
      internal static func delete(_ p1: String) -> String {
        return L10n.tr("Localization", "alert.message.delete", p1)
      }
      /// There is no internet connection. Please try to use answers from answer sets.
      internal static let noInternet = L10n.tr("Localization", "alert.message.noInternet")
      /// Are you sure you want to  reset answers number?
      internal static let resetAnswersNumber = L10n.tr("Localization", "alert.message.resetAnswersNumber")
    }
    internal enum Title {
      /// Create new %@
      internal static func createNew(_ p1: String) -> String {
        return L10n.tr("Localization", "alert.title.createNew", p1)
      }
      /// Delete %@
      internal static func delete(_ p1: String) -> String {
        return L10n.tr("Localization", "alert.title.delete", p1)
      }
      /// Edit %@
      internal static func edit(_ p1: String) -> String {
        return L10n.tr("Localization", "alert.title.edit", p1)
      }
      /// Reset Answers Number
      internal static let resetAnswersNumber = L10n.tr("Localization", "alert.title.resetAnswersNumber")
    }
  }

  internal enum EditableItems {
    internal enum Name {
      /// answer
      internal static let answers = L10n.tr("Localization", "editableItems.name.answers")
      /// answer set
      internal static let answerSets = L10n.tr("Localization", "editableItems.name.answerSets")
    }
  }

  internal enum NavigationBar {
    internal enum Title {
      /// Answer Sets
      internal static let answerSets = L10n.tr("Localization", "navigationBar.title.answerSets")
    }
  }

  internal enum SettingsViewController {
    /// Settings
    internal static let title = L10n.tr("Localization", "settingsViewController.title")
    internal enum CellText {
      /// Answer sets
      internal static let answerSets = L10n.tr("Localization", "settingsViewController.cellText.answerSets")
      /// Haptic feedback
      internal static let hapticFeedback = L10n.tr("Localization", "settingsViewController.cellText.hapticFeedback")
      /// Lazy mode
      internal static let lazyMode = L10n.tr("Localization", "settingsViewController.cellText.lazyMode")
      /// Read answer
      internal static let readAnswer = L10n.tr("Localization", "settingsViewController.cellText.readAnswer")
      /// Reset Answers Number
      internal static let resetAnswersNumber = L10n.tr("Localization", "settingsViewController.cellText.resetAnswersNumber")
    }
    internal enum SectionFooterText {
      /// When "Lazy mode" is on: tap the magic ball to request an answer
      internal static let lazyMode = L10n.tr("Localization", "settingsViewController.sectionFooterText.lazyMode")
    }
  }

  internal enum TabBar {
    internal enum Title {
      /// MagicBall
      internal static let magicBall = L10n.tr("Localization", "tabBar.title.magicBall")
      /// Settings
      internal static let settings = L10n.tr("Localization", "tabBar.title.settings")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
