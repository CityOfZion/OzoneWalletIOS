//
//  SettingsStrings.swift
//  O3
//
//  Created by Andrei Terentiev on 4/27/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

struct SettingsStrings {
    //Network
    static let networkSwitchWarning = NSLocalizedString("SETTINGS_Network_Switch_Warning", comment: "Warning to display when the user decied to manually switch the network node that they are connected to")

    //Watch Addresses
    static let deleteConfirmationPrompt = NSLocalizedString("WATCH_ADDRESS_Delete_Confirmation", comment: "A prompt asking for user confirmation to delete the watch address")
    static let editNameString = NSLocalizedString("WATCH_ADDRESS_Edit_Name", comment: "Title for editing name of a watch address")
    static let copyAddressString = NSLocalizedString("WATCH_ADDRESS_Copy_Address", comment: "Title to copy watch address")
    static let deleteString = NSLocalizedString("WATCH_ADDRESS_Delete", comment: "Title to delete Watch Address")
    static let saveString = NSLocalizedString("WATCH_ADDRESS_Save", comment: "Save Action for Watch Addresses")
    static let watchAddressTitle = NSLocalizedString("SETTINGS_Watch_Only_Address_Title", comment: "A title for the Watch Only Address Title Screen")
    static let addWatchAddressDescription = NSLocalizedString("SETTINGS_Add_Watch_Description", comment: "Description under add address button that describes what a watch address is and how it will work in the app")
    static let addWatchAddressButton = NSLocalizedString("SETTINGS_Add_Watch_Address", comment: "Title for add watch address button")
    static let invalidAddressError = NSLocalizedString("SETTINGS_Invalid_Address", comment: "Error To display when user tries to add an invalid address")
    static let addressLabel = NSLocalizedString("SETTINGS_Address_Label", comment: "Label to describe an address input field")
    static let nicknameLabel = NSLocalizedString("SETTINGS_Nickname_LAbel", comment: "Lavel to describe a nickname input field")
    static let close = NSLocalizedString("SETTINGS_Close_Title", comment: "String to describe a close action")

    //Main Settings Menu
    static let settingsTitle = NSLocalizedString("SETTINGS_Settings_Title", comment: "Title for Settings Menu")
    static let privateKeyTitle = NSLocalizedString("SETTINGS_My_Private_Key", comment: "Settings Menu Title for Private Key")
    static let watchOnlyTitle = NSLocalizedString("SETTINGS_Watch_Only_Address", comment: "Settings Menu Title For Watch Only Address")
    static let currencyTitle = NSLocalizedString("SETTINGS_Currency_Title", comment: "Title for Currency Menu in Settings")
    static let networkTitle = NSLocalizedString("SETTINGS_Network_Title", comment: "Title for Network Screen In Settings")
    static let themeTitle = NSLocalizedString("SETTINGS_Theme", comment: "Settings Menu Title for Theme")
    static let contactTitle = NSLocalizedString("SETTINGS_Contact", comment: "Settings Menu Title For Contact")
    static let supportTitle = NSLocalizedString("SETTINGS_Support", comment: "Settings Mneu Title For Support")

    static let logoutWarning = NSLocalizedString("SETTINGS_Logout_Warning", comment: "Warning that appears when attempting to logout from settings")
    static let logout = NSLocalizedString("SETTINGS_Logout", comment: "Settings Menu Title for Logout")
    static let authenticate = NSLocalizedString("SETTINGS_Authenticate_To_View", comment: "Prompt requesting user to authenticate before viewing sensitive information like private key")
    static let classicTheme = NSLocalizedString("SETTINGS_Theme_Classic", comment: "Label For Classic Theme")
    static let darkTheme = NSLocalizedString("SETTINGS_Theme_Dark", comment: "Label For Dark Theme")
    static let versionLabel = NSLocalizedString("SETTINGS_Version", comment: "Settings Menu Title For Version")
}
