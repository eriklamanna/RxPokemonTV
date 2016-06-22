//
//  ViewController.swift
//  RxPokeTV
//
//  Created by Erik LaManna on 6/22/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    let pokeAPI = PokeAPI()
    let disposeBat = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        pokeAPI.pokemon.asObservable().bindTo(tableView.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) {
                (row, element, cell) in
                cell.textLabel?.text = "\(element.name)"
            }.addDisposableTo(disposeBat)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pokeAPI.getAllPokemans()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

