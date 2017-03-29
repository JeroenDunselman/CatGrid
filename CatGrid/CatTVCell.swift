//
//  CatTVCell.swift
//  XMLParsingDemo
//
//  Created by Jeroen Dunselman on 29/03/2017.
//  Copyright © 2017 TheAppGuruz-New-6. All rights reserved.
//

import UIKit

class CatTVCell: UITableViewCell {
  
  @IBOutlet weak public var catView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
