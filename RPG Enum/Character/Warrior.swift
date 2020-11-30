//
//  Warrior.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Warrior: Character {
    init(name: String) {
        super.init(name: name, type: .warrior, lifePoint: 90, maxHealt: 90, weapon: TwoHendedSword())
    }
}
