//
//  Colossus.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Colossus: Character {
    
    init(name: String) {
        super.init(name: name, type: .colossus, lifePoint: 110, maxHealt: 110, weapon: TreeTrunk())
    }
}
