

import UIKit
class HomeViewController:UIViewController{

    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath)
        cell.backgroundColor = .red

        return cell
    }
}
extension HomeViewController: UITableViewDelegate{

}
