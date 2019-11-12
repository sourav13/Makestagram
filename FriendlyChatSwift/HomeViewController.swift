

import UIKit
import Kingfisher

class HomeViewController:UIViewController{

    @IBOutlet weak var tableView: UITableView!
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as? PostImageCell
        let imageURL = URL(string:post.imageURL)
        cell?.postimageView.kf.setImage(with:imageURL)

        return cell!
    }
}
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          let post = posts[indexPath.row]

          return post.imageHeight
      }
}
