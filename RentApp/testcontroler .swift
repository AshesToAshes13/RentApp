//
//  testcontroler .swift
//  RentApp
//
//  Created by Егор Бамбуров on 15/01/2019.
//  Copyright © 2019 Егор Бамбуров. All rights reserved.
//

import UIKit

class testcontroler : UITableViewController {
    let cellId = "test"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.red
        tableView.register(FeaturedAdsCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
}
