//
//  ViewController.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-02.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import UIKit

class CharactersController: UIViewController {
    var pageSuivant = ""
    var personnages: [Personnage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPerso()
    }

    func getPerso() {
        APIHelper().getPersos(APIHelper().urlPersonnages) { (pageSuivante, listrePersos, erreurString) in
            if pageSuivante != nil {
                print(pageSuivante!)
                self.pageSuivant = pageSuivante!
            }
            if erreurString != nil {
                print(erreurString!)
            }
            if listrePersos != nil {
                self.personnages.append(contentsOf: listrePersos!)
                print(self.personnages.count)
            }
        }
    }
}

