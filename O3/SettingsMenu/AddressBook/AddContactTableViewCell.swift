//
//  AddContactTableViewCell
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class AddContactTableViewCell: UITableViewCell {
    weak var delegate: AddAddressCellDelegate?

    @IBAction func addAddressTapped(_ sender: Any) {
        delegate?.segueToAdd()
    }
}
