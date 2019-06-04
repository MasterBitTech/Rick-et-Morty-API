//
//  PersoCell.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-03.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import UIKit

class PersoCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var persoIV: UIImageView!
    
    var perso: Personnage!
    
    func setupCell(_ perso: Personnage)  {
       self.perso = perso
       self.nameLbl.text = self.perso.name
       self.persoIV.download(self.perso.image)
    }
}
