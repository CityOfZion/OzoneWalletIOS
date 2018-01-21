//
//
//  ThemeManager.swift
//  ProjectThemeTest
//
// Copyright (c) 2017 Abhilash
//
import UIKit
import Foundation
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
            return UIColor.black
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
            return UIColor.lightGray
        case .dark:
            return UIColor.lightGray
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
            return self.backgroundColor
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
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
}

// This will let you use a theme in the app.
class ThemeManager {
    static let cornerRadius: CGFloat = 6.0
    static let borderWidth: CGFloat = 1.0
    static let smallText = UIFont(name: "Avenir-Book", size: 12)!
    static let barButtonItemFont = UIFont(name: "Avenir-Heavy", size: 16)!
    static let topTabbarItemFont = UIFont(name: "Avenir-Medium", size: 12)!
    static let largeTitleFont = UIFont(name: "Avenir-Heavy", size: 32)!

    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaultsManager.theme = theme
        UserDefaults.standard.synchronize()

        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = UserDefaultsManager.theme.primaryColor
    }
}
