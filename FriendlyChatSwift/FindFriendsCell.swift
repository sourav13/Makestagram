//
//  FindFriendsCell.swift
//  FriendlyChatSwift
//
//  Created by sourav sachdeva on 12/11/19.
//  Copyright © 2019 Google Inc. All rights reserved.
//

import UIKit
protocol FindFriendsCellDelegate: class {
    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell)
}
class FindFriendsCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var followButton: UIButton!
        weak var delegate: FindFriendsCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        followButton.layer.borderColor = UIColor.lightGray.cgColor
           followButton.layer.borderWidth = 1
           followButton.layer.cornerRadius = 6
           followButton.clipsToBounds = true

           followButton.setTitle("Follow", for: .normal)
           followButton.setTitle("Following", for: .selected)
        // Initialization code
    }

    @IBAction func followButtonTapped(_ sender: UIButton) {
         delegate?.didTapFollowButton(sender, on: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
