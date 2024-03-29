//
//  ViewController.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-02.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import UIKit

enum TypeQuery {
    case all
    case query
}

class CharactersController: UIViewController {
    
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailView: DetailView!
    
    var pageSuivante = ""
    var personnages: [Personnage] = []
    
    var pageSuivanteQuery = ""
    var personnagesQuery: [Personnage] = []
    var enQuery = false
    
    var cellImageFrame = CGRect()
    var detailImageFrame = CGRect()
    var imageDeTransition = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getPerso(string: APIHelper().urlPersonnages, type: .all)
        detailView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut), name: Notification.Name("close"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("willAppear")
        print(APIHelper().urlAvecParam())
        super.viewWillAppear(animated)
        if enQuery {
            pageSuivanteQuery = ""
            personnagesQuery = []
            getPerso(string: APIHelper().urlAvecParam(), type: .query)
       // } else {
       //    getPerso(string: APIHelper().urlPersonnages, type: .all)
        }
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
    
    func getPerso(string: String, type: TypeQuery) {
        APIHelper().getPersos(string) { (pageSuivante, listrePersos, erreurString) in
            if pageSuivante != nil {
                switch type {
                case .all: self.pageSuivante = pageSuivante!
                case .query: self.pageSuivanteQuery = pageSuivante!
                }
            }
            if erreurString != nil {
                 //print("ici")
                print(erreurString!)
            }
            if listrePersos != nil {
                switch type {
                case .all: self.personnages.append(contentsOf: listrePersos!)
                case .query: self.personnagesQuery.append(contentsOf: listrePersos!)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        //print("un chagement")
        enQuery = !enQuery
        collectionView.reloadData()
    }
    
    
}

extension CharactersController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmented.selectedSegmentIndex == 0 {
            return personnages.count
        }
        return personnagesQuery.count
    }
    
    //Optionnnelle surtout si 1 section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let personnage = segmented.selectedSegmentIndex == 0 ? personnages[indexPath.item] : personnagesQuery[indexPath.item]
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
        let count = segmented.selectedSegmentIndex == 0 ? personnages.count : personnagesQuery.count
        if indexPath.item  == count - 1 {
            if segmented.selectedSegmentIndex == 0 && pageSuivante != "" {
                getPerso(string: pageSuivante, type: .all)
            }
            if segmented.selectedSegmentIndex == 1 && pageSuivanteQuery != "" {
                getPerso(string: pageSuivanteQuery, type: .query)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let layout = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let frame = collectionView.convert(layout.frame, to: collectionView.superview)
        cellImageFrame = CGRect(x: frame.minX, y: frame.minY + 50, width: frame.width, height: frame.height - 50)
        let count = segmented.selectedSegmentIndex == 0 ? personnages.count : personnagesQuery.count
        if count > 0 {
           switch segmented.selectedSegmentIndex {
           case 0: animateIn(personnage: personnages[indexPath.item])
           case 1: animateIn(personnage: personnagesQuery[indexPath.item])
           default: break
           }
        }
    }
}
