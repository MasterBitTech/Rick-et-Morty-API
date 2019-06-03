//
//  APIHelper.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-02.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import Foundation

typealias ApiCompletion = (_ next: String?, _ personnage: [Personnage]?, _ errorString: String?) -> Void

class APIHelper  {
    
    private let _baseUrl = "https://rickandmortyapi.com/api/"
    
    var urlPersonnages: String {
        return _baseUrl + "character/"
    }
    
    func getPersos(_ string: String, completion: ApiCompletion?) {
        if let url = URL(string: string) {
            // Continuer
            URLSession.shared.dataTask(with: url)  { (data, response, error) in
                if error != nil {
                    completion?(nil, nil, error!.localizedDescription)
                }
                
                if data != nil {
                    //Convertir notre JSON
                    do {
                        let reponseJSON = try JSONDecoder().decode(APIResult.self, from: data!)
                        completion?(reponseJSON.info.next, reponseJSON.results, nil)
                     } catch {
                        completion?(nil, nil, error.localizedDescription)
                    }
                } else {
                    completion?(nil, nil, "Aucune Data dispo")
                }
            }.resume()
        } else {
            //Arrête
            completion?(nil, nil, "Url Invalide")
        }
    }
    
}
