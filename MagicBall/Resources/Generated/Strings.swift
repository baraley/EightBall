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
      /// Delete
      internal static let delete = L10n.tr("Localization", "action.title.delete")
      /// OK
      internal static let ok = L10n.tr("Localization", "action.title.ok")
      /// Save
      internal static let save = L10n.tr("Localization", "action.title.save")
    }
  }

  internal enum Alert {
    internal enum Message {
      /// Are you sure you want to delete set of answers that contains %d answers?
      internal static func deleteAnswerSet(_ p1: Int) -> String {
        return L10n.tr("Localization", "alert.message.deleteAnswerSet", p1)
      }
      /// There is no internet conection. Please try to use answers from answer sets.
      internal static let noInternet = L10n.tr("Localization", "alert.message.noInternet")
    }
    internal enum Title {
      /// Delete answer set?
      internal static let deleteAnswerSet = L10n.tr("Localization", "alert.title.deleteAnswerSet")
      /// Edit the answer
      internal static let editAnswer = L10n.tr("Localization", "alert.title.editAnswer")
      /// Edit the answer set name
      internal static let editAnswerSet = L10n.tr("Localization", "alert.title.editAnswerSet")
      /// New answer
      internal static let newAnswer = L10n.tr("Localization", "alert.title.newAnswer")
      /// New answer set
      internal static let newAnswerSet = L10n.tr("Localization", "alert.title.newAnswerSet")
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
