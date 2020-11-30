//
//  Team.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Player {
    
    // MARK: -   
    
    /// player name
    let name: String
    var characters = [Character]()
    var characterNames = [String]()
    let maxPicks = 3
    var chooseCharacter: Character?
    var targetChosen: Character?
    var defeat = false
    
    init(name: String) {
        self.name = name
    }
    
    /// To choose the unique name of a single character. The name of the chosen character is "A", the name of another character cannot be "A". Must be different.
    func chooseCharacterName(picks: CharacterType) {
        while true {
            print("Choose \(picks) name:")
            if let name = readLine() {
                if characterNames.contains(name) {
                    print("This name is already choosen!")
                } else if name.isEmpty {
                    print("")
                } else {
                    switch picks {
                    case .warrior:
                        characters.append(Warrior(name: name))
                    case .colossus:
                        characters.append(Colossus(name: name))
                    case .magus:
                        characters.append(Magus(name: name))
                    case .priest:
                        characters.append(Priest(name: name))
                    }
                    print("Your \(picks) \(name) has been added to your team.")
                    characterNames.append(name)
                    return
                }
            }
        }
    }
    
    private func characterPick(_ player: Player) -> Character? {
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
            
            guard isAlive(player.characters[numberChoose - 1]) else {
                print("You need to choose a character")
                return nil
            }
            return player.characters[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return nil
    }
    
    /// To select the characters
    func selectCharacter() {
        while characters.count < maxPicks {
            print("""
                \(name) choose \(characters.count) characters:
                1 - ⚔️ Warrior ⚔️ - Simple, basic but efficient.
                Damage: 20  ||  Lifepoint: 90
                2 - 💪🏼 Colossus 💪🏼 - Thick smelly creature, can't even see his feet.
                Damage: 10  ||  Lifepoint: 110
                3 - 🧙🏼‍♂️ Magus 🧙🏼‍♂️ - Devastating power, but enough sensitive.
                Damage: 25  ||  Lifepoint: 70
                4 - 🙏🏼 Priest 🙏🏼 - Robust ally, incapable of causing harm.
                Healing: 10  ||  Lifepoint: 90
                """)
            
            if let picks = readLine(), !picks.isEmpty {
                switch picks {
                case "1":
                    if alreadyChosen(characterType: .warrior) {
                        print("The \(CharacterType.warrior) is already chosen! Please, make another choice.")
                        selectCharacter()
                    } else {
                        chooseCharacterName(picks: CharacterType.warrior)
                    }
                case "2":
                    if alreadyChosen(characterType: .colossus) {
                        print("The \(CharacterType.colossus) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(picks: CharacterType.colossus)
                    }
                case "3":
                    if alreadyChosen(characterType: .magus) {
                        print("The \(CharacterType.magus) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(picks: CharacterType.magus)
                    }
                case "4":
                    if alreadyChosen(characterType: .priest) {
                        print("The \(CharacterType.priest) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(picks: CharacterType.priest)
                    }
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
    
    /// The player can only choose a character type once. For example, if the choice is warrior, he cannot choose that type a second time.
    private func alreadyChosen(characterType: CharacterType) -> Bool {
        for character in characters {
            if character.type == characterType {
                return true
            }
        }
        return false
    }
    
    /// For choose the character to inflige damage at the ennemy or heal an ally
    func chooseCharacterTeam() -> Character? {
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
    
    ///
    private func characterDescription(_ player: Player) {
        var numberChoice = 1
        for character in player.characters {
            print("\(numberChoice) \(character.die())")
            numberChoice += 1
        }
    }
    
    /// Choice of the target to attack between the three characters enemy.
    func targetTheEnemyCharacter(_ player: Player) -> Character? {
        while true {
            print("🎯 Who is the target? Chosen from the team of \(name). 🎯")
            
            characterDescription(player)
            
            if let targetCharacter = characterPick(player) {
                return targetCharacter
            }
        }
    }
    
    /// To check if character is dead.
    private func isAlive(_ character: Character) -> Bool {
        if character.isDead {
            print("This character is dead. 💀")
            return false
        }
        return true
    }
    
    /// To check if all of the characters of team are dead. The player lost, else, the game continues.
    func ifThePlayerLost() {
        let charactersAreDead = characters.filter
        { $0.isDead }
        if charactersAreDead.count == maxPicks {
            defeat = true
        }
    }
}
