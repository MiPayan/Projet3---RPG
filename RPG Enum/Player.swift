//
//  Team.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Player {
    
    // MARK: -   
    
    let name: String
    /// player name
    var characterTeam: [Character] = []
    /// player team
    let maxPicks = 3
    var characterName: [String] = []
    var chooseCharacter: Character?
    var targetChoice: Character?
    var defeat = false
    
    
    init(name: String) {
        self.name = name
    }
    
    // the function allows you  to choose characters
    // player --> player who chose the character
    // picks -->  the choice of the type of characters between warrior, colossus, magus and priest
    func chooseCharacterName(picks: CharacterType) {
        while true {
            // a loop for asking the name
            print("Choose \(picks) name:")
            if let name = readLine(), characterName.contains(name) {
                print("This name is already choosen!")
            } else if name.isEmpty {
                print("")
            } else {
                switch picks {
                case .warrior:
                    characterTeam.append(Warrior(name: name))
                case .colossus:
                    characterTeam.append(Colossus(name: name))
                case .magus:
                    characterTeam.append(Magus(name: name))
                case .priest:
                    characterTeam.append(Priest(name: name))
                }
                print("Your \(picks) \(name) has been added to your team.")
                characterName.append(name)
                return
            }
        }
    }
    
    func characterPick(_ player: Player) -> Character? {
        if let choose = readLine() {
            guard !choose.isEmpty else {
                print("You need to choose a character.")
                return nil
            }
            
            guard let numberChoose = Int(choose) else {
                print("Impossible choice!")
                return nil
            }
            
            guard numberChoose <= maxPicks, numberChoose > 0 else {
                print("You only have \(maxPicks) characters")
                return nil
            }
            
            guard isAlive(player.characterTeam[numberChoose - 1]) else {
                print("You need to choose a character")
                return nil
            }
            return player.characterTeam[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return nil
    }
    
    func chooseCharacterTeam() -> Character? {
        // For choose the character to inflige damage at the ennemy or heal an ally
        while true {
            if chooseCharacter == nil {
                print("\(name), choose a character to fight:")
            } else {
                print("\(name), choose an ally to heal:")
            }
            
            characterDescription(self)
            
            if let selectCharacter = characterPick(self) {
                return selectCharacter
                
            }
        }
    }
    
    func characterDescription(_ player: Player) {
        var numberChoice = 1 
        for character in player.characterTeam {
            print("\(numberChoice) \(character.die())")
            numberChoice += 1
        }
    }
    
    func characterAttaking(_ player: Player) -> Character? {
        while true {
            print("Who is the target? Chosen from the team of \(player.name) ")
            
            characterDescription(player)
            
            if let targetCharacter = characterPick(player) {
                return targetCharacter
            }
        }
    }
    
    func isAlive(_ character: Character) -> Bool {
        if character.isDead {
            print("This character is dead.")
            return false
        }
        return true
    }
    
    func ifThePlayerLost() {
        let charactersAreDead = characterTeam.filter
        { $0.isDead }
        if charactersAreDead.count == maxPicks {
            defeat = true
        }
    }
    
    func selectCharacter() {
        while characterTeam.count < maxPicks {
            print("""
                \(name) choose \(characterTeam.count) characters:
                1. Warrior --
                Damage: 20  ||  Lifepoint: 90
                2. Colossus --
                Damage: 10  ||  Lifepoint: 110
                3. Magus --
                Damage: 25  ||  Lifepoint: 70
                4. Priest --
                Healing: 10  ||  Lifepoint: 90
                """)
            
            if let picks = readLine(), !picks.isEmpty {
                    switch picks {
                    case "1":
                        chooseCharacterName(picks: CharacterType.warrior )
                    case "2":
                        chooseCharacterName(picks: CharacterType.colossus)
                    case "3":
                        chooseCharacterName(picks: CharacterType.magus)
                    case "4":
                        chooseCharacterName(picks: CharacterType.priest)
                    default:
                        print("Please, make your choice")
                    // if the choice is different of 1,2,3 or 4.
                    }
                    
                } else {
                    print("You need to choose a character, between 1,2,3 and 4")
                    // if the choice is empty.
                
            }
        }
    }
}
