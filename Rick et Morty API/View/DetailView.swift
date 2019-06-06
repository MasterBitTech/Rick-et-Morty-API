//
//  DetailView.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-04.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import UIKit

class DetailView: UIView {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var presoIV: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var specieLbl: UILabel!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    
    
    
    
    var view: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        backgroundColor = .clear
        let bundle = Bundle(for: type(of: self))
        if let xib = type(of: self).description().components(separatedBy: ".").last {
            let nib = UINib(nibName: xib, bundle: bundle)
            if let v = nib.instantiate(withOwner: self, options: nil).first as? UIView {
                view = v
                view?.frame = bounds
                if view != nil {
                    addSubview(view!)
                    view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view?.backgroundColor = .white
                    view?.layer.cornerRadius = 25
                }
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("close"), object: nil)
    }
    
    func setup(_ personnage: Personnage) {
        presoIV.download(personnage.image)
        presoIV.layer.cornerRadius = presoIV.frame.height / 2
        presoIV.clipsToBounds = true
        nameLbl.text = personnage.name
        locationLbl.text = "Lieu: " + personnage.location.name
        originLbl.text = "Origine: " + personnage.origin.name
        specieLbl.text = "Espèce: " + personnage.species
        genderLbl.text = "Sexe: " + convertirDonneeEnEmoji(string: personnage.gender)
        statusLbl.text = "Status: " + convertirDonneeEnEmoji(string: personnage.status)
    }
    
    func convertirDonneeEnEmoji(string: String) -> String {
        switch string {
        case "Dead": return "☠️"
        case "Alive": return "😀"
        case "Male": return "🚹"
        case "Female": return "🚺"
        default: return "🤷‍♂️"
        }
    }
    
}
