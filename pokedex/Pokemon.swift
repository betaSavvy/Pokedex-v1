//
//  pokemon.swift
//  pokedex
//
//  Created by Delonn on 9/10/15.
//  Copyright © 2015 delonnkoh. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    
    private var _nextEvoText: String!
    private var _nextEvoID: String!
    private var _nextEvoLevel: String!
    
    private var _pokemonUrl: String!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var nextEvoID: String {
        if _nextEvoID == nil {
            _nextEvoID = ""
        }
        return _nextEvoID
    }
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    var nextEvoLevel: String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }



init(name:String, pokedexId: Int) {
    
    self._name = name
    self._pokedexId = pokedexId
    
    _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
}

func downloadPokemonDetails(completed: DownloadComplete) {
    
    let url = NSURL(string: _pokemonUrl)!
    
    Alamofire.request(.GET, url).responseJSON { (response) -> Void in
        
        //            print(response.request)     // original URL request
        //            print(response.response)    // URL Response
        //            print(response.data)        // server data
        //            print(response.result)      // result of response serialization
        
        //            if let JSON = response.result.value {
        //                print("JSON: \(JSON)")
        //            }
        
        if let dict = response.result.value as? Dictionary<String, AnyObject> {
            
            if let weight = dict["weight"] as? String {
                self._weight = weight
            }
            
            if let height = dict["height"] as? String {
                self._height = height
            }
            
            if let attack = dict["attack"] as? Int {
                self._attack = String(attack)
            }
            if let defense = dict["defense"] as? Int {
                self._defense = String(defense)
            }
            
            if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                if let name = types[0]["name"] {
                    self._type = name.capitalizedString
                }
                if types.count > 1 {
                    
                    for var x = 1; x < types.count; x++ {
                        if let name = types[x]["name"] {
                            self._type! += " / \(name.capitalizedString)"
                        }
                    }
                }
            } else {
                self._type = "No Type"
            }
            
            //                print(self._weight)
            //                print(self._height)
            //                print(self._attack)
            //                print(self._defense)
            //                print(self._type)
            
            if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                
                if let url = descArr[0]["resource_uri"] {
                    
                    let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                    
                    Alamofire.request(.GET, nsurl).responseJSON{ (response) -> Void in
                        
                        if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                            
                            if let description = descDict["description"] as? String {
                                
                                self._description = description
                                //print(self._description)
                            }
                        }
                        
                        completed()
                    }
                }
                
            } else {
                self._description = "No Description"
            }
            
            if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                
                if let to = evolutions[0]["to"] as? String {
                    
                    //Can't support mega pokemon but api still has mega data
                    if to.rangeOfString("mega") == nil {
                        
                        if let uri = evolutions[0]["resource_uri"] as? String {
                            
                            let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                            let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                            
                            self._nextEvoID = num
                            self._nextEvoText = to
                            
                            if let lvl = evolutions[0]["level"] as? Int {
                                self._nextEvoLevel = String(lvl)
                            }
                            
                            //print(self._nextEvoID)
                            //print(self._nextEvoText)
                            //print(self._nextEvoLevel)
                        }
                    }
                }
            }
        }
    }//Alamofire.request
    
}

}//END






















