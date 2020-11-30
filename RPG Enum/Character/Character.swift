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
    var weapon: Weapon
    var isDead = false
    var lifePoint: Int {
        willSet {
            if newValue > lifePoint {
                print("\(name) is about to get heal")
            } else {
                print("\(name) is about to get attack")
            }
        }
        
        didSet {
            if oldValue > lifePoint {
                print("\(name) lose \(oldValue - lifePoint)HP")
            } else {
                print("\(name) has been healed.. +\(lifePoint - oldValue)")
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
        target.lifePoint -= weapon.damage
        
        if target.lifePoint <= 0 {
            target.isDead = true
        }
    }
    
    func bonusWeapon() {
        if let warrior = self as? Warrior  {
            warrior.weapon = DoubleSwords()
            print("Good, your \(CharacterType.warrior)(\(name)) has unlocked a weapon: \(weapon.nameWeapon), + 10 damage. Check out your new stats 😊.")
        } else if let colossus = self as? Colossus {
            colossus.weapon = GiantFronde()
            print("Good, your \(CharacterType.colossus)(\(name)) has unlocked a weapon: \(weapon.nameWeapon), + 10 damage. Check out your new stats 😊.")
        } else if let magus = self as? Magus {
            magus.weapon = VoidStaff()
            print("Good, your \(CharacterType.magus)(\(name)) has unlocked a weapon: \(weapon.nameWeapon), + 10 damage. Check out your new stats 😊.")
            
        } else if let priest = self as? Priest {
            priest.weapon = TibetanBowl()
            print("Good, your \(CharacterType.priest)(\(name)) has unlocked a weapon: \(weapon.nameWeapon), + 10 damage. Check out your new stats 😊.")
        }
    }
}

