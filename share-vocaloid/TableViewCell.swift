//
//  TableViewCell.swift
//  share-vocaloid
//
//  Created by 木村奏斗 on 2023/01/10.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var osusumeLabel: UILabel!
    
    @IBOutlet var sakkyokuLabel: UILabel!
    
    @IBOutlet var vocalLabel: UILabel!
    
    @IBOutlet var URLLabel: UILabel!
    
    @IBOutlet var kyokumeiLavel: UILabel!
    
    @IBOutlet var userNameLavel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        URLLabel.layer.borderWidth = 1
        osusumeLabel.layer.borderWidth = 1
        sakkyokuLabel.layer.borderWidth = 1
        vocalLabel.layer.borderWidth = 1
        kyokumeiLavel.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
