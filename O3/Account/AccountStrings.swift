//
//  AccountStrings.swift
//  O3
//
//  Created by Andrei Terentiev on 4/27/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

struct AccountStrings {
    //Top Tab Bar
    static let assets = NSLocalizedString("WALLET_Assets", comment: "Title of assets tab in wallet screen")
    static let transactions = NSLocalizedString("WALLET_Transactions", comment: "Title of Transactions tab in wallet screen")
    static let contacts = NSLocalizedString("WALLET_Contacts", comment: "Title of Contacts tab in wallet screen")

    //Wallet
    static let unclaimedGas = NSLocalizedString("WALLET_Unclaimed_Gas_Title", comment: "A title for Unclaimed Gas in the wallet")
    static let claimAction = NSLocalizedString("WALLET_Claim_Action", comment: "A Title for the claim Action")
    static let successfulClaimPrompt = NSLocalizedString("WALLET_Claim_Succeeded_Prompt", comment: "A Message to display in the alert after the user hs successfully claimed their gas")
    static let claimingInProgressTitle = NSLocalizedString("WALLET_Claim_In_Progress_Title", comment: "A title to display while claiming is in progress")
    static let claimingInProgressSubtitle = NSLocalizedString("WALLET_Claim_In_Progress_Subtitle", comment: "A subtitle to display while claiming is in progress")
    static let accountTitle = NSLocalizedString("WALLET_Account", comment: "A title for the account screen")
    static let addNEP5Token = NSLocalizedString("WALLET_Add_NEP5_Token", comment: "A title for the button which allows you to add a NEP-5 Token to your wallet")
    static let done = NSLocalizedString("WALLET_NEP_5_DONE", comment: "Done bar button item")
    static let availableTokensTitle = NSLocalizedString("WALLET_NEP5_Tokens", comment: "Title for NEP-5 Tokens Selection View")

    //Transaction History
    static let fromPrefix = NSLocalizedString("WALLET_From_Prefix", comment: "Prefix used in the transaction history to indicate where the transaction came from")
    static let toPrefix = NSLocalizedString("WALLET_To_Prefix", comment: "Prefix used in the transaction history to indicate where the transaction went to")
    static let blockPrefix = NSLocalizedString("WALLET_Block_Prefix", comment: "Prefix used to indicate the block number in the transaction history")
    static let claimTransaction = NSLocalizedString("WALLET_Claim_Transaction", comment: "Indicated that the transation in history originated from claim")
    static let o3Wallet = NSLocalizedString("WALLET_O3_Wallet", comment: "String in transaction history indicating O3 Wallet")

    //My QR
    static let saveQRAction = NSLocalizedString("WALLET_Save_Qr_Action", comment: "An Action Title for saving your QR code")
    static let copyAddressAction = NSLocalizedString("WALLET_Copy_Address", comment: "An action title for copying our address")
    static let shareAction = NSLocalizedString("WALLET_Share", comment: "An action title for sharing O3")
    static let saved = NSLocalizedString("WALLET_Saved_Title", comment: "A title to display when you've successfully saved your wallet address qr code")
    static let savedMessage = NSLocalizedString("WALLET_Saved_Description", comment: "A description to give more information about saving the address")
    static let myAddressInfo = NSLocalizedString("WALLET_My_Address_Explanation", comment: "Informative text explaining you can store neo, gas, and nep-5 tokens using this address")
    static let myAddressTitle =
        NSLocalizedString("WALLET_My_Address_Title", comment: "Title of the My Address Page")

    //Contacts
    static let addContact = NSLocalizedString("CONTACTS_Add_Contact_Button_Title", comment: "Title for button when you add a contact to address book")
    static let addContactDescription = NSLocalizedString("CONTACTS_Add_Contact_Description", comment: "An informative description about what happens when you add a contact")
    static let areYouSureDelete = NSLocalizedString("CONTACTS_Are_You_Sure_To_Delete", comment: "A prompt asking if you are sure that you want to delete this contact")
    static let editName = NSLocalizedString("CONTACTS_Edit_Name", comment: "Title for editing name of a contact")
    static let sendToAddress = NSLocalizedString("CONTACTS_Send_To", comment: "Title for sending to contact")
    static let copyAddress = NSLocalizedString("CONTACTS_Copy_Address", comment: "Title to copy address")
   static let delete = NSLocalizedString("CONTACTS_Delete", comment: "Title to delete Contact")
    static let save = NSLocalizedString("CONTACTS_Save", comment: "Save Action for Contacts")
}
