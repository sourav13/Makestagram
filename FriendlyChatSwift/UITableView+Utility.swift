//
//  UITableView+Utility.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 13/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import Foundation
import UIKit

protocol CellIdentifiable {
    static var CellIdentifier: String {get}
}
extension UITableViewCell:CellIdentifiable{}
extension CellIdentifiable where Self : UITableViewCell{
    static var CellIdentifier:String{
        return String(describing: self)
    }
}
extension UITableView{
    func dequeueReusableCell<T: UITableViewCell>() -> T   {
    
        guard let cell = dequeueReusableCell(withIdentifier: T.CellIdentifier) as? T else {
    
            fatalError("Error dequeuing cell for identifier \(T.CellIdentifier)")
        }

        return cell
    }
}
