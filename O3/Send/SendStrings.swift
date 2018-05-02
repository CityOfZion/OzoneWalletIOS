//
//  SendStrings.swift
//  O3
//
//  Created by Andrei Terentiev on 4/27/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

struct SendStrings {
    static let notEnoughBalanceError = NSLocalizedString("SEND_Not_Enough_Balance_Error",
                                                  comment: "Error To display when the user is trying to send without enough balance")
    static let notEnoughGasForInvokeError = NSLocalizedString("SEND_Not_Enough_Gas_Token_Transfer",
                                                       comment: "Error to display when the user is trying to send a token but does not have enough gas to make the invoke occur. It requires 0.00000001 GAS in the wallet in order to send a token" )
    static let roundingGasError = NSLocalizedString("SEND_Rounding_Gas_Error", comment: "Error to display when the user is trying to send gas, but the amount they are sending is the max amount. The user can round down the gas amount a small amount to precent this error")
    static let invalidAddressError = NSLocalizedString("SEND_Invalid_Address_Error", comment: "Error to display when the user tries to send to an invalid NEO address")
    static let invalidAmountError = NSLocalizedString("SEND_Invalid_Amount_Error", comment: "Error to display when the user tries to send an invalid amount")

    static let sendConfirmationPrompt = NSLocalizedString("SEND_Confirmation_Prompt", comment: "A confirmation dialog that asks the user to confirm the asset, amount, and recipient of their transaction")

    static let authenticateToSendPrompt = NSLocalizedString("SEND_Authenticate_To_Send",
                                                     comment: "A prompt asking for user authentication before performing the send action")
    static let toLabel = NSLocalizedString("SEND_To_Label", comment: "Label title for the send to field on the send screen")
     static let assetLabel = NSLocalizedString("SEND_Asset_Label", comment: "Label title for the asset field on the send screen")
    static let amountLabel = NSLocalizedString("SEND_Amount_Label", comment: "Label title for the amount on the send screen")
    static let paste = NSLocalizedString("SEND_Paste_Button_Title", comment: "A title for the paste button in the send screen")
    static let scan = NSLocalizedString("SCAN_Button_Title", comment: "A title for the scan button in the send screen")
    static let addressBook = NSLocalizedString("SEND_Address_Button_Title", comment: "A Title for the address book button in the send screen")
    static let selectedAssetLabel = NSLocalizedString("SEND_Selected_Asset_Title", comment: "A title for the the selected asset label, before the user has selected any asset.")
    static let send = NSLocalizedString("SEND_Send_Title", comment: "A title indicating a send action")
    static let toAddressPlaceholder = NSLocalizedString("SEND_To_Address_Placeholder", comment: "A place holder text, indicating that the NEO Wallet Address should go in this text field")

    static let close = NSLocalizedString("SEND_Close", comment: "Title for button to close send screen after transaction completed")
    static let transactionSucceededTitle = NSLocalizedString("SEND_Created_Transaction_Successfully_Title", comment: "Title to display when the transaction has successfuly been submitted to the NEO blockchain")
    static let transactionSucceededSubtitle = NSLocalizedString("SEND_Created_Transaction_Successfully_Description", comment: "Description to display when the transaction has successfuly been submitted to the NEO blockchain")
    static let transactionFailedTitle = NSLocalizedString("SEND_Created_Transaction_Failed_Title", comment: "Title to display when the transaction has failed to be submitted to the NEO blockchain")
    static let transactionFailedSubtitle = NSLocalizedString("SEND_Created_Transaction_Failed_Description", comment: "Description to display when the transaction has failed to be submitted to the NEO blockchain")

    static let assetSelectorTitle = NSLocalizedString("SEND_Select_Asset_Title", comment: "A title for the Select Asset pull up menu")
}
