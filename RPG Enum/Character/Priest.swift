//
//  Priest.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Priest: Character {
    init(name: String) {
        super.init(name: name, type: .priest, lifePoint: 90, maxHealt: 90, weapon: HandsNude())
    }
    
    override func die() -> String {
        if isDead {
            return super.die()
        } else {
            return "\(type) \(name) -- \(lifePoint)/\(maxHealt)HP -- \(weapon.damage)heal "
        }
    }
    
    func healing(_ target: Character) {
        if target.lifePoint >= target.maxHealt {
            print("Sorry, you are already full life!")
            return
        }
        target.lifePoint += weapon.damage
        
        if target.lifePoint > target.maxHealt {
            target.lifePoint = target.maxHealt
        }
    }
}
