//
//  Character.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Character {
    var name: String
    let characterType: CharacterType
    let maxHealth: Int
    var weapon: Weapon
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
    
    init(name: String, characterType: CharacterType, lifePoint: Int, maxHealt: Int, weapon: Weapon) {
        self.name = name
        self.characterType = characterType
        self.lifePoint = lifePoint
        self.maxHealth = maxHealt
        self.weapon = weapon
    }
    
    func showStatus() -> String {
        if isDead() {
            return "\(characterType) \(name) is dead in the fight"
        } else {
            return "\(characterType) \(name) -- \(lifePoint)/\(maxHealth)HP -- \(weapon.damage)Damages"
        }
    }
    
    func attackOrHeal(_ target: Character) {
        target.lifePoint -= weapon.damage
    }
    
    func isDead() -> Bool {
        if lifePoint <= 0 {
            return true
        }
        return false
    }
    
    func addBonusToWeapon() { /// addBonusToWeapon()
        if let warrior = self as? Warrior  {
            warrior.weapon = DoubleSwords()
            print("Good, your \(CharacterType.warrior)(\(name)) has unlocked a weapon: \(weapon.name), + 10 damage. Check out your new stats 😊.")
        } else if let colossus = self as? Colossus {
            colossus.weapon = GiantFronde()
            print("Good, your \(CharacterType.colossus)(\(name)) has unlocked a weapon: \(weapon.name), + 10 damage. Check out your new stats 😊.")
        } else if let magus = self as? Magus {
            magus.weapon = VoidStaff()
            print("Good, your \(CharacterType.magus)(\(name)) has unlocked a weapon: \(weapon.name), + 10 damage. Check out your new stats 😊.")
            
        } else if let priest = self as? Priest {
            priest.weapon = TibetanBowl()
            print("Good, your \(CharacterType.priest)(\(name)) has unlocked a weapon: \(weapon.name), + 10 damage. Check out your new stats 😊.")
        }
    }
}

