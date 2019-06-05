//
//  ViewController.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-02.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import UIKit

class CharactersController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageSuivante = ""
    var personnages: [Personnage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getPerso(string: APIHelper().urlPersonnages)
    }

    func getPerso(string: String) {
        APIHelper().getPersos(string) { (pageSuivante, listrePersos, erreurString) in
            if pageSuivante != nil {
                print(pageSuivante!)
                self.pageSuivante = pageSuivante!
            }
            if erreurString != nil {
                print(erreurString!)
            }
            if listrePersos != nil {
                self.personnages.append(contentsOf: listrePersos!)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension CharactersController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personnages.count
    }
    
    //Optionnnelle surtout si 1 section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let personnage = personnages[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersoCell", for: indexPath) as? PersoCell {
            cell.setupCell(personnage)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let taille = collectionView.frame.width / 2 - 20
        return CGSize(width: taille, height: taille)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item  == personnages.count - 1 {
            if pageSuivante != "" {
                getPerso(string: pageSuivante)
            }
        }
    }
}
