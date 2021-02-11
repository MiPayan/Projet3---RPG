//
//  Priest.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Priest: Character {
    init(name: String) {
        super.init(name: name, characterType: .priest, lifePoint: 90, maxHealt: 90, weapon: HandsNude())
    }
    
    override func showStatus() -> String {
        if isDead() {
            return super.showStatus()
        } else {
            return "\(characterType) \(name) -- \(lifePoint)/\(maxHealth)HP -- \(weapon.damage)heal"
        }
    }
    
    override func attackOrHeal(_ target: Character) {
        if target.lifePoint >= target.maxHealth {
            print("Sorry, you are already full life.")
        } else if target.lifePoint + weapon.damage > target.maxHealth {
            target.lifePoint = target.maxHealth
        } else {
            target.lifePoint += weapon.damage
        }
    }
}
