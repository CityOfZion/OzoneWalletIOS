//
//  TokenSaleStrings.swift
//  O3
//
//  Created by Andrei Terentiev on 4/27/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation

struct TokenSaleStrings {
    // TOKEN SALES LIST
    static let notWhitelisted = NSLocalizedString("TOKENSALE_Not_WhiteListed", comment: "A string showing the user is not whitelisted for this tokensale")
    static let participate = NSLocalizedString("TOKENSALE_Participate", comment: "Text for the participate action")
    static let checkingStatus = NSLocalizedString("TOKENSALE_Checking_Status", comment: "Displayed when xhecking the whitelist status of a participant")
    static let tokenSalesTitle =  NSLocalizedString("TOKENSALE_Token_Sales_Title", comment: "A title for the token sales screen")
    static let getNotifiedTitle =  NSLocalizedString("TOKENSALE_Get_Notified_Title", comment: "A title showing users can get notified about the latest token sales")
    static let getNotifiedDescription =  NSLocalizedString("TOKENSALE_Get_Notified_Description", comment: "A detailed description about what will happen if the user signs up for the email list to get notified about token sales")
    static let subscribe = NSLocalizedString("TOKENSALE_Subscribe", comment: "Button title for allowing users to subscribe to token sale news")
    static let liveStatus = NSLocalizedString("TOKENSALE_Live_Status", comment: "A string showing that the displayed token sale is currently active")
    static let ended = NSLocalizedString("TOKENSALE_Ended", comment: "String showing that the token sale has already ended")
    static let endsIn = NSLocalizedString("TOKENSALE_Ends_In", comment: "A string displaying how muc time is left in the token sale")

    //TOKEN SALE INFO
    static let priority = NSLocalizedString("TOKENSALE_Priority_Label", comment: "Label showing priority. Also displays the gas cost for priority. This is fixed at 0.0011GAS")
    static let review = NSLocalizedString("TOKENSALE_Review_Button_Title", comment: "A title for reviewing token sale participation buttton")
    static let invalidAmountError = NSLocalizedString("TOKENSALE_Invalid_Amount_Error", comment: "An error indicating the user has entered an invalid contribution amount")
    static let notEnoughBalanceError = NSLocalizedString("TOKENSALE_Not_Enough_Balance_Error", comment: "An error indicating that the user does not have enough balance for the amount entered")
    static let roundingError = NSLocalizedString("TOKENSALE_Rounding_Error", comment: "An error occurs when the user tries to send the max amount of gas. This is due to a potential rounding error, ro prevent this, send slightly les than the max amount")
    static let maxContributionError = NSLocalizedString("TOKENSALE_Max_Contribution_Error", comment: "An error that shows when the user tries to contribute more than the max contribution amount")
    static let minContributionError = NSLocalizedString("TOKENSALE_Min_Contribution_Error", comment: "An error that show when the user tries to contribute less than the min contribution amount")
    static let priorityExplanationDialog = NSLocalizedString("TOKENSALE_Priority_Explanation", comment: "A Dialog that shows explaining when, what is priority is tapped. Explains that priority allows your transactions to process faster on the blockchain")
    static let tokenSaleHasEndedError = NSLocalizedString("TOKENSALE_Has_Ended_Error", comment: "Error that shows when the user tries to partcipate in a tokensale that has already ended")
    static let youWillReceiveTitle = NSLocalizedString("TOKENSALE_You_Will_receive_Title", comment: "A title indicating how much the user will receive with a given contribution amount")

    //Review Controller
    static let notWhiteListedError = NSLocalizedString("TOKENSALE_Not_Whitelisted_Error", comment: "An error to display when the user is not whitelisted for the tokensale")
    static let pleaseAgreeError = NSLocalizedString("TOKENSALE_Not_Agreed_To_Disclaimers Error", comment: "An error when the user has not yet agreed to the tokensale disclaimers")
    static let sendTitle = NSLocalizedString("TOKENSALE_You_Are_Sending_Title", comment: "Title Describing the send amount in the tokensale review screen")
    static let priorityReview = NSLocalizedString("TOKENSALE_Has_Priority_Label", comment: "String on the review screen describing that this transaction will have priority")
    static let readSaleAgreement = NSLocalizedString("TOKENSALE_Issuer_Agreement", comment: "Disclaimer text asking the user to aggree that they have read the agreement provided by the tokensale issuer")
    static let o3Agreement = NSLocalizedString("TOKENSALE_O3_Agreement", comment: "Disclaimer text asking the user to agree to the terms of the O3 Application. States that the user is interacting directly with the smart contract")
    static let tokenSaleWebsite = NSLocalizedString("TOKENSALE_Website_Button_Title", comment: "A title for a button that directs the user to the tokensale website button")

    //Success, Error, Pending
    static let dateReceiptLabel = NSLocalizedString("TOKENSALE_Receipt_Date_Label", comment: "Label for the date in the token sale receipt in transaction success screen")
    static let tokenSaleNameReceiptLabel = NSLocalizedString("TOKENSALE_Receipt_Tokensale_Name_Label", comment: "Label for token sale name in the token sale receipt in transaction success screen")
    static let txidReceiptLabel = NSLocalizedString("TOKENSALE_Receipt_txid_Label", comment: "Label for the transaction id in the token sale receipt in transaction success screen")
    static let sendingReceiptLabel = NSLocalizedString("TOKENSALE_Receipt_Sending_Label", comment: "Label for the sending asset and amount in the token sale receipt in transaction success screen")
    static let receivingReceiptLabel = NSLocalizedString("TOKENSALE_Receipt_Receiving_Label", comment: "Label for the receiving asset and amount in the token sale receipt in transaction success screen")
    static let priorityReceiptLabel = NSLocalizedString("TOKENSALE_Receipt_Priority_Label", comment: "Label for the priority in the token sale receipt in transaction success screen")
    static let emailReceipt = NSLocalizedString("TOKENSALE_Receipt_Email_Full_Text", comment: "Email Text For the receipt that the user can send to themselves")
    static let successfulTransaction = NSLocalizedString("TOKENSALE_Successful_Transaction_Title", comment: "Title text showing your tokensale transaction has been successfully submitted to the blockchain")
    static let transactionTitle = NSLocalizedString("TOKENSALE_Transaction", comment: "A Title for the transction receipt in the tokensale success")
    static let saveTitle = NSLocalizedString("TOKENSALE_save_button_title", comment: "Button title to save your receipt")
    static let closeTitle = NSLocalizedString("TOKENSALE_Close", comment: "Text for close button to close the tokensale screen")
    static let transactionErrorDescriptionTitle = NSLocalizedString("TOKENSALE_Transaction_Error_Description", comment: "Description that shows when there is an error")
    static let contact = NSLocalizedString("TOKENSALE_Contact_Title", comment: "Title for button to allow for contacting after ato kensale transaction fails")
    static let sendingInProgress = NSLocalizedString("TOKENSALE_Sending_In_Progress", comment: "Description showing that the transaction is currently being submitted to the NEO blockchain")
}
