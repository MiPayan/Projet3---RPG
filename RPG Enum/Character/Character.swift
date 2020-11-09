//
//  Characters.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Character {
    var name: String
    let type: CharacterType
    let maxHealt: Int
    let weapon: Weapon
    var isDead = false
    var lifePoint: Int {
        willSet {
            if newValue > lifePoint {
                print("\(self.name) is about to get heal")
            } else {
                print("\(self.name) is about to get attack")
            }
        }
        
        didSet {
            if oldValue > lifePoint {
                print("\(self.name) lose \(oldValue - lifePoint)HP")
            } else {
                print("\(self.name) has been healed.. +\(lifePoint - oldValue)")
            }
        }
    }
    
    init(name: String, type: CharacterType, lifePoint: Int, maxHealt: Int, weapon: Weapon) {
        self.name = name
        self.type = type
        self.lifePoint = lifePoint
        self.maxHealt = maxHealt
        self.weapon = weapon
    }
    
    
    
    func die() -> String {
        if isDead {
            return "\(type) \(name) is dead in the fight"
        } else {
            return "\(type) \(name) -- \(lifePoint)/\(maxHealt)HP -- \(weapon.damage)DMG "
        }
        
    }
    
    func actionOn(_ target: Character) {
        target.lifePoint -= self.weapon.damage
        
        if target.lifePoint <= 0 {
            target.isDead = true
        }
    }
}
