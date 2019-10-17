//
//  ViewController.swift
//  URLMockDemo
//
//  Created by Valsamis Elmaliotis on 11/10/19.
//  Copyright © 2019 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let url = URL(string: "https://itunes.apple.com/search?term=prodigy&limit=1")!
        let networkClient = NetworkClient()

        networkClient.searchItunes(url: url) { trackStore, errorMessage  in

            print(trackStore ?? "")
            print(trackStore?.results.first ?? "")
            print(errorMessage ?? "")
        }
    }
}
