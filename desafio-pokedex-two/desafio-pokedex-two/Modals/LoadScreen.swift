//
//  LoadScreen.swift
//  desafio-pokedex-two
//
//  Created by Émerson M Luz on 27/11/22.
//

import UIKit

class LoadScreen {
    
    static func start (tableView: UITableView, activityIndicator: UIActivityIndicatorView) {
        activityIndicator.alpha = 1
        tableView.alpha = 0.5
        tableView.isUserInteractionEnabled = false
    }
    
    static func stop (tableView: UITableView, activityIndicator: UIActivityIndicatorView) {
        activityIndicator.alpha = 0
        tableView.alpha = 1
        tableView.isUserInteractionEnabled = true
    }
}
