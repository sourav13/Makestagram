

import UIKit
import Kingfisher

class HomeViewController:UIViewController{

    @IBOutlet weak var tableView: UITableView!
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        return dateFormatter
    }()
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    func configureTableView(){
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
}
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.userNameLabel.text = User.current.username

            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postimageView.kf.setImage(with: imageURL)

            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
            return cell

        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
}
extension HomeViewController: UITableViewDelegate{
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height

        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight

        case 2:
            return PostActionCell.height

        default:
            fatalError()
        }
    }
}
