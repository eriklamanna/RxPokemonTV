//
//  PokeAPI.swift
//  RxPokeTV
//
//  Created by Erik LaManna on 6/22/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

//http://pokeapi.co/api/v2/pokemon

struct PokemonInfo {
    let name: String
    let url: String
}

class PokeAPI {
    static let url = NSURL(string: "http://pokeapi.co/api/v2/pokemon")!

    let pokemon: Variable<[PokemonInfo]> = Variable<[PokemonInfo]>([])

    func getAllPokemans() {
//        let urlRequest = NSURLRequest(URL: PokeAPI.url)

        let pokeObservable = NSURLSession.sharedSession().rx_JSON(PokeAPI.url)

        let request = pokeObservable.subscribeNext { json in

            guard let results = json["results"] as? Array<AnyObject> else {

                return
            }


            let pokeInfos: [PokemonInfo] = results.flatMap { dictionary in
                guard let dictionary = dictionary as? [String: String] else {
                    return nil
                }

                let pokemonInfo = PokemonInfo(name: dictionary["name"]!, url: dictionary["url"]!)
                return pokemonInfo

            }
            print(pokeInfos)

            dispatch_async(dispatch_get_main_queue()) {
                self.pokemon.value = pokeInfos
            }
        }
    }
}