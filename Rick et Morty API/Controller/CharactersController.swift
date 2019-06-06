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
    @IBOutlet weak var detailView: DetailView!
    
    var pageSuivante = ""
    var personnages: [Personnage] = []
    
    var cellImageFrame = CGRect()
    var detailImageFrame = CGRect()
    var imageDeTransition = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getPerso(string: APIHelper().urlPersonnages)
        detailView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut), name: Notification.Name("close"), object: nil)
    }

    func animateIn(personnage: Personnage) {
        detailImageFrame = detailView.presoIV.convert(detailView.presoIV.bounds, to: view)
        detailView.setup(personnage)
        
        imageDeTransition = UIImageView(frame: cellImageFrame)
        imageDeTransition.download(personnage.image)
        imageDeTransition.layer.cornerRadius = 25
        imageDeTransition.contentMode = .scaleAspectFill
        imageDeTransition.clipsToBounds = true
        view.addSubview(imageDeTransition)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.imageDeTransition.frame = self.detailImageFrame
            self.imageDeTransition.layer.cornerRadius = self.detailImageFrame.height / 2
            self.collectionView.alpha = 0
        }) { (success) in
            self.detailView.alpha = 1
            
        }
    }
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageDeTransition.frame = self.cellImageFrame
            self.imageDeTransition.layer.cornerRadius = 25
            self.collectionView.alpha = 1
            self.detailView.alpha = 0
        }) { (success) in
            self.imageDeTransition.removeFromSuperview()
        }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let layout = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let frame = collectionView.convert(layout.frame, to: collectionView.superview)
        cellImageFrame = CGRect(x: frame.minX, y: frame.minY + 50, width: frame.width, height: frame.height - 50)
        
        let personnage = personnages[indexPath.item]
        animateIn(personnage: personnage)
    }
}
