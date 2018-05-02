//
//
//  ThemeManager.swift
//  ProjectThemeTest
//
// Copyright (c) 2017 Abhilash
//
import UIKit
import Foundation
import SwiftTheme

/*
struct Theme {
    struct Light {
 
        static let borderColor = UIColor(named: "borderColor")!
        static let textColor = UIColor(named: "textColor")!
        static let primary = UIColor(named: "lightThemePrimary")!
        static let grey = UIColor(named: "grey")!
        static let lightgrey = UIColor(named: "lightGreyTransparent")!
        static let red = UIColor(named: "lightThemeRed")!
        static let orange = UIColor(named: "lightThemeOrange")!
        static let green = UIColor(named: "lightThemeGreen")!
 
    }
}
*/
enum Theme: String {

    case light, dark

    //Customizing the Navigation Bar
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .lightContent
        }
    }
    /*
    var navigationBackgroundImage: UIImage? {
        return self == .theme1 ? UIImage(named: "navBackground") : nil
    }*/
    /*
    var tabBarBackgroundImage: UIImage? {
        return self == .theme1 ? UIImage(named: "tabBarBackground") : nil
    }*/

    var backgroundColor: UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor(named: "darkThemeBackground")!
        }
    }

    var primaryColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "lightThemePrimary")!
        case .dark:
            return UIColor(named: "lightThemePrimary")!
        }
    }

    var disabledColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "lightGreyTransparent")!
        case .dark:
            return UIColor(named: "lightGreyTransparent")!
        }
    }

    var accentColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "lightThemeOrange")!
        case .dark:
            return UIColor(named: "lightThemeOrange")!
        }
    }

    var titleTextColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "textColor")!
        case .dark:
            return UIColor.white
        }
    }

    var textColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "textColor")!
        case .dark:
            return UIColor(named: "textColor")!
        }
    }

    var lightTextColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "grey")!
        case .dark:
            return UIColor(named: "grey")!
        }
    }

    var errorColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "lightThemeRed")!
        case .dark:
            return UIColor(named: "lightThemeRed")!
        }
    }

    var positiveGainColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "lightThemeGreen")!
        case .dark:
            return UIColor(named: "lightThemeGreen")!
        }
    }

    var negativeLossColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "lightThemeRed")!
        case .dark:
            return UIColor(named: "lightThemeRed")!
        }
    }

    var borderColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "borderColor")!
        case .dark:
            return UIColor(named: "darkThemeSecondaryBackground")!
        }
    }

    var cardColor: UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor(named: "darkThemeSecondaryBackground")!
        }
    }

    var seperatorColor: UIColor {
        switch self {
        case .light:
            return UITableView().separatorColor!
        case .dark:
            return UIColor(named: "darkThemeSecondaryBackground")!
        }
    }

    var textFieldBackgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return UIColor(named: "darkThemeSecondaryBackground")!
        }
    }

    var textFieldPlaceHolderColor: UIColor {
        switch self {
        case .light:
            return UIColor(hexString: "#C7C7CDFF")!
        case .dark:
            return UIColor.lightGray
        }
    }

    var textFieldTextColor: UIColor {
        switch self {
        case .light:
            return UIColor(named: "textColor")!
        case .dark:
            return UIColor.white
        }
    }
}

// This will let you use a theme in the app.
class O3Theme {
    static let cornerRadius: CGFloat = 6.0
    static let borderWidth: CGFloat = 1.0
    static let smallText = UIFont(name: "Avenir-Book", size: 12)!
    static let navBarTitle = UIFont(name: "Avenir-Heavy", size: 16)!
    static let barButtonItemFont = UIFont(name: "Avenir-Heavy", size: 16)!
    static let topTabbarItemFont = UIFont(name: "Avenir-Medium", size: 12)!
    static let largeTitleFont = UIFont(name: "Avenir-Heavy", size: 32)!

    //standard text and backgrounds
    static let navBarColorPicker = ThemeColorPicker(colors: Theme.light.backgroundColor.hexString(false),
        Theme.dark.backgroundColor.hexString(false),
        "#2C68D2FF")
    static let backgroundColorPicker = ThemeColorPicker(colors: Theme.light.backgroundColor.hexString(false),
        Theme.dark.backgroundColor.hexString(false),
        Theme.light.backgroundColor.hexString(false))
    static let primaryColorPicker = ThemeColorPicker(colors: Theme.light.primaryColor.hexString(false),
        Theme.dark.primaryColor.hexString(false),
        Theme.dark.primaryColor.hexString(false))
    static let accentColorPicker = ThemeColorPicker(colors:
        Theme.light.accentColor.hexString(false),
        Theme.dark.accentColor.hexString(false),
        Theme.dark.accentColor.hexString(false))
    static let errorColorPicker = ThemeColorPicker(colors:
        Theme.light.errorColor.hexString(false),
        Theme.dark.errorColor.hexString(false),
        Theme.dark.errorColor.hexString(false))
    static let disabledColorPicker = ThemeColorPicker(colors:
        Theme.light.disabledColor.hexString(false),
        Theme.dark.disabledColor.hexString(false),
        Theme.dark.disabledColor.hexString(false))
    static let titleColorPicker = ThemeColorPicker(colors: Theme.light.titleTextColor.hexString(false),
        Theme.dark.titleTextColor.hexString(false),
        Theme.dark.titleTextColor.hexString(false))
    static let lightTextColorPicker = ThemeColorPicker(colors: Theme.light.lightTextColor.hexString(false), Theme.dark.lightTextColor.hexString(false),
        Theme.dark.lightTextColor.hexString(false))

    static let negativeLossColorPicker = ThemeColorPicker(colors:
        Theme.light.negativeLossColor.hexString(false),
        Theme.dark.negativeLossColor.hexString(false),
        Theme.dark.negativeLossColor.hexString(false))

    static let positiveGainColorPicker = ThemeColorPicker(colors:
        Theme.light.positiveGainColor.hexString(false),
        Theme.dark.positiveGainColor.hexString(false),
        Theme.dark.positiveGainColor.hexString(false))

    static let cardColorPicker = ThemeColorPicker(colors:
        Theme.light.cardColor.hexString(false),
        Theme.dark.cardColor.hexString(false),
        Theme.dark.cardColor.hexString(false))

    //title attributes
    static let largeTitleAttributesPicker = ThemeDictionaryPicker(arrayLiteral:
        [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black,
        NSAttributedStringKey.font.rawValue: O3Theme.largeTitleFont],
        [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: O3Theme.largeTitleFont],
        [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
         NSAttributedStringKey.font.rawValue: O3Theme.largeTitleFont])

    static let regularTitleAttributesPicker = ThemeDictionaryPicker(arrayLiteral: [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black,
        NSAttributedStringKey.font.rawValue: O3Theme.navBarTitle],
        [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: O3Theme.navBarTitle],
        [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
         NSAttributedStringKey.font.rawValue: O3Theme.navBarTitle])

    //text fields
    static let clearTextFieldBackgroundColorPicker = ThemeColorPicker(colors: Theme.light.backgroundColor.hexString(false), Theme.dark.backgroundColor.hexString(false))
    static let textFieldBackgroundColorPicker = ThemeColorPicker(colors: Theme.light.textFieldBackgroundColor.hexString(false), Theme.dark.textFieldBackgroundColor.hexString(false))
    static let textFieldTextColorPicker = ThemeColorPicker(colors: Theme.light.textFieldTextColor.hexString(false), Theme.dark.textFieldTextColor.hexString(false))
    static let keyboardPicker = ThemeKeyboardAppearancePicker(styles: .default, .dark)

    //tableSeparator
    static let tableSeparatorColorPicker = ThemeColorPicker(colors: Theme.light.seperatorColor.hexString(false), Theme.dark.seperatorColor.hexString(false))

    //activity indicator
    static let activityIndicatorColorPicker = ThemeActivityIndicatorViewStylePicker(styles: .gray, .white)

    static let statusBarStylePicker = ThemeStatusBarStylePicker(styles: .default, .lightContent, .lightContent)
    static let tabBarStylePicker = ThemeBarStylePicker(styles: .default, .black)

}
