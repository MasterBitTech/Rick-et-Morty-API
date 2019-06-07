//
//  UserDefaultsHelper.swift
//  Rick et Morty API
//
//  Created by Benoit Cauchy on 2019-06-06.
//  Copyright © 2019 Benoit Cauchy. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    
    private var _defaults = UserDefaults.standard
    private var _statusKey = "status"
    private var _nameKey = "name"
    
    func setName(string: String?) {
        guard let str = string else { return }
        _defaults.set(str, forKey: _nameKey)
        _defaults.synchronize()
    }
    
    func getName() -> String {
        return _defaults.string(forKey: _nameKey) ?? ""
    }
    
    func setStatus(bool: Bool) {
        _defaults.set(bool, forKey: _statusKey)
        _defaults.synchronize()
    }
    
    func getStatus() -> Bool {
        return _defaults.bool(forKey: _statusKey)
    }
    
    func getStatusString() -> String {
        let status = _defaults.bool(forKey: _statusKey)
        if status {
            return "Vivant"
        } else {
            return "Mort"
        }
    }
}
