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
    var characters = [Character]()
    let maxPicks = 3
    
    init(name: String) {
        self.name = name
    }
    
    /// To choose the unique name of a single character. The name of the chosen character is "A", the name of another character cannot be "A". Must be different.
    private func chooseCharacterName(_ picks: CharacterType) {
        print("Choose \(picks) name:")
        if let name = readLine() {
            if isCharacterNameAlreadyChosen(name: name) {
                print("This name is already choosen!")
            } else if name.isEmpty {
                print("😡 You need to choose a name for your character! 😡")
            } else if name != name.trimmingCharacters(in: .whitespacesAndNewlines) {
                print(" Your character needs a name without spaces. 🙄")
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
            }
        }
    }
    
    private func isCharacterNameAlreadyChosen(name: String) -> Bool {
        for character in characters {
            if character.name == name {
                return true
            }
        }
        return false
    }
    
    private func characterPick() -> Character? {
        if let choose = readLine() {
            guard !choose.isEmpty else {
                print("You need to choose a character.")
                return characterPick()
            }
            
            guard let numberChoose = Int(choose) else {
                print("Impossible choice!")
                return characterPick()
            }
            
            guard numberChoose <= maxPicks, numberChoose > 0 else {
                print("You only have \(maxPicks) characters")
                return characterPick()
            }
            
            guard isAlive(characters[numberChoose - 1]) else {
                print("You need to choose a character")
                return characterPick()
            }
            return characters[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return characterPick()
    }
    
    /// To select the characters
    func selectCharacter() {
        print(" ⚠️ The same character cannot be selected more than once. Select your character by entering 1, 2, 3 or 4 and choose a name for him. Maximum of three characters per team. ⚠️")
        while characters.count < maxPicks {
            print("""
                \(name), you must choose \(3 - characters.count) character:
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
                    if alreadyChosen(.warrior) {
                        print("The \(CharacterType.warrior) is already chosen! Please, make another choice.")
                        selectCharacter()
                    } else {
                        chooseCharacterName(.warrior)
                    }
                case "2":
                    if alreadyChosen(.colossus) {
                        print("The \(CharacterType.colossus) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(.colossus)
                    }
                case "3":
                    if alreadyChosen(.magus) {
                        print("The \(CharacterType.magus) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(.magus)
                    }
                case "4":
                    if alreadyChosen(.priest) {
                        print("The \(CharacterType.priest) is already chosen! Please, make another choice.")
                    } else {
                        chooseCharacterName(.priest)
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
    private func alreadyChosen(_ characterType: CharacterType) -> Bool {
        for character in characters {
            if character.characterType == characterType {
                return true
            }
        }
        return false
    }
    
    /// For choose the character to inflige damage at the ennemy or heal an ally
    func selectCharacterForHealingOrFighting() -> Character {
        print("\(name), choose a character to fight or heal:")
        
        characterDescription()
        
        if let selectCharacter = characterPick() {
            return selectCharacter
        }
        
        if let choose = readLine() {
            guard !choose.isEmpty else {
                print("You need to choose a character.")
                return selectCharacterForHealingOrFighting()
            }
            
            guard let numberChoose = Int(choose) else {
                print("Impossible choice!")
                return selectCharacterForHealingOrFighting()
            }
            
            guard numberChoose <= maxPicks, numberChoose > 0 else {
                print("You only have \(maxPicks) characters")
                return selectCharacterForHealingOrFighting()
            }
            
            guard isAlive(characters[numberChoose - 1]) else {
                print("You need to choose a character")
                return selectCharacterForHealingOrFighting()
            }
            return characters[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return selectCharacterForHealingOrFighting()
    }
    
    ///
    private func characterDescription() {
        for (index, character) in characters.enumerated() {
            print("\(index + 1) \(character.showStatus())")
        }
    }
    
    /// Choice of the target to attack between the three characters enemy.
    func selectAllyToHealOrEnemyToAttack(character: Character) -> Character {
        if character is Priest {
            print("🎯 \(name), which ally needs heal? 🎯")
        } else {
            print("🎯 Who is the target? Chosen from the team of \(name). 🎯")
        }
        characterDescription()
        
        if let targetTheAllyCharacter = characterPick() {
            return targetTheAllyCharacter
        }
        return selectAllyToHealOrEnemyToAttack(character: character)
    }
    
    /// To check if character is dead.
    private func isAlive(_ character: Character) -> Bool {
        if character.isDead() {
            print("This character is dead. 💀")
            return false
        }
        return true
    }
    
    /// To check if all of the characters of team are dead. The player lost, else, the game continues.
    func isDefeat() -> Bool {
        let charactersAreDead = characters.filter { $0.isDead() }
        if charactersAreDead.count == maxPicks {
            return true
        }
        return false
    }
}
