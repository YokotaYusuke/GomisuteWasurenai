//
//  DustsTableViewCell.swift
//  GomisuteWasurenai
//
//  Created by yusukeyokota on 2023/12/08.
//

import UIKit

class DustsTableViewCell: UITableViewCell {
   
    @IBOutlet weak var DustNameLabel: UILabel!
    @IBOutlet weak var DustTypeLabel: UILabel!
    @IBOutlet weak var DustImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
