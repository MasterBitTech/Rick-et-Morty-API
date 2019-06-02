//
//  APIHelper.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-02.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import Foundation

class APIHelper  {
    
    private let _baseUrl = "https://rickandmortyapi.com/api/"
    
    var urlPersonnages: String {
        return _baseUrl + "character/"
    }
    
    func getPersos(_ string: String) {
        if let url = URL(string: string) {
            // Continuer
            URLSession.shared.dataTask(with: url)  { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                if data != nil {
                    //Convertir notre JSON
                    do {
                        let reponseJSON = try JSONDecoder().decode(APIResult.self, from: data!)
                        for perso in reponseJSON.results {
                            print(perso.name)
                            print(perso.gender)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("Aucune Data dispo")
                }
            }.resume()
        } else {
            //Arrête
            print("URL Invalide")
        }
    }
    
}
