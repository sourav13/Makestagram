////
////  Copyright (c) 2015 Google Inc.
////
////  Licensed under the Apache License, Version 2.0 (the "License");
////  you may not use this file except in compliance with the License.
////  You may obtain a copy of the License at
////
////  http://www.apache.org/licenses/LICENSE-2.0
////
////  Unless required by applicable law or agreed to in writing, software
////  distributed under the License is distributed on an "AS IS" BASIS,
////  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
////  See the License for the specific language governing permissions and
////  limitations under the License.
////
//
//import UIKit
//import Firebase
//import FirebaseAuthUI
//import FirebaseGoogleAuthUI
//// MARK: - FCViewController
//
//class FCViewController: UIViewController, UINavigationControllerDelegate {
//
//    // MARK: Properties
//
//    var ref: DatabaseReference!
//    var messages: [DataSnapshot]! = []
//    var msglength: NSNumber = 1000
//    var storageRef: StorageReference!
//    var remoteConfig: RemoteConfig!
//    let imageCache = NSCache<NSString, UIImage>()
//    var keyboardOnScreen = false
//    var placeholderImage = UIImage(named: "ic_account_circle")
//    fileprivate var _refHandle: DatabaseHandle!
//    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
//    var user: User?
//    var displayName = "Anonymous"
//
//    // MARK: Outlets
//
//    @IBOutlet weak var messageTextField: UITextField!
//    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var signInButton: UIButton!
//    @IBOutlet weak var imageMessage: UIButton!
//    @IBOutlet weak var signOutButton: UIButton!
//    @IBOutlet weak var messagesTable: UITableView!
//    @IBOutlet weak var backgroundBlur: UIVisualEffectView!
//    @IBOutlet weak var imageDisplay: UIImageView!
//    @IBOutlet var dismissImageRecognizer: UITapGestureRecognizer!
//    @IBOutlet var dismissKeyboardRecognizer: UITapGestureRecognizer!
//
//    // MARK: Life Cycle
//
//    override func viewDidLoad() {
//       // self.signedInStatus(isSignedIn: true)
//        configureAuth()
//        // TODO: Handle what users see when view loads
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        unsubscribeFromAllNotifications()
//    }
//
//    // MARK: Config
//
//    func configureAuth() {
//        let provider : [FUIAuthProvider] = [FUIGoogleAuth()]
////        FUIAuth.defaultAuthUI()?.providers = provider
//     //   _authHandle = Auth.auth().addStateDidChangeListener{(auth:Auth,user:User?) in
//            self.messages.removeAll(keepingCapacity: false)
//            self.messagesTable.reloadData()
//            if let activeUser = user{
//                if self.user != activeUser{
//                    self.user = activeUser
//                    self.signedInStatus(isSignedIn: true)
//                    let name = user!.email!.components(separatedBy: "@")[0]
//                    self.displayName = name
//                }
//            } else{
//                self.signedInStatus(isSignedIn: false)
//                self.loginSession()
//            }
//        }
//        // TODO: configure firebase authentication
//    }
//
//    func configureDatabase() {
//        ref = Database.database().reference()
//        _refHandle = ref.child("messages").observe(.childAdded){(snapshot:DataSnapshot) in
//            self.messages.append(snapshot)
//            self.messagesTable.insertRows(at: [IndexPath(row: self.messages.count-2, section: 0)], with: .automatic)
//            self.scrollToBottomMessage()
//        }
//        // TODO: configure database to sync messages
//    }
//
//    func configureStorage() {
//
//        storageRef = Storage.storage().reference()
//        // TODO: configure storage using your firebase storage
//    }
//
//    deinit {
//        ref.child("messages").removeObserver(withHandle: _refHandle)
//        Auth.auth().removeStateDidChangeListener(_authHandle)
//        // TODO: set up what needs to be deinitialized when view is no longer being used
//    }
//
//    // MARK: Remote Config
//
//    func configureRemoteConfig() {
//        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
//        remoteConfig = RemoteConfig.remoteConfig()
//      remoteConfig.configSettings = remoteConfigSettings
//        // TODO: configure remote configuration settings
//    }
//
//    func fetchConfig() {
//        var expirationDuration: Double = 3600
//        if remoteConfig.configSettings.isDeveloperModeEnabled{
//            expirationDuration = 0
//        }
//        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
//            if status == .success{
//                print("config fetched")
//                self.remoteConfig.activateFetched()
//                let friendlyMsgLength = self.remoteConfig["friendly_msg_length"]
//                if friendlyMsgLength.source != .static{
//                    self.msglength = friendlyMsgLength.numberValue!
//                    print("friend msg length config: \(self.msglength)")
//                }
//            }else{
//                print("config not fetched")
//                print(error)
//            }
//        }
//        // TODO: update to the current coniguratation
//    }
//
//    // MARK: Sign In and Out
//
//    func signedInStatus(isSignedIn: Bool) {
//        signInButton.isHidden = isSignedIn
//        signOutButton.isHidden = !isSignedIn
//        messagesTable.isHidden = !isSignedIn
//        messageTextField.isHidden = !isSignedIn
//        sendButton.isHidden = !isSignedIn
//        imageMessage.isHidden = !isSignedIn
//
//        if (isSignedIn) {
//
//            // remove background blur (will use when showing image messages)
//            messagesTable.rowHeight = UITableViewAutomaticDimension
//            messagesTable.estimatedRowHeight = 122.0
//            backgroundBlur.effect = nil
//            messageTextField.delegate = self
//            configureDatabase()
//            configureStorage()
//            configureRemoteConfig()
//            fetchConfig()
//            // TODO: Set up app to send and receive messages when signed in
//        }
//    }
//
//    func loginSession() {
//        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
//        self.present(authViewController, animated: true, completion: nil)
//    }
//
//    // MARK: Send Message
//
//    func sendMessage(data: [String:String]) {
//        var mdata = data
//        mdata[Constants.MessageFields.name] = displayName
//        ref.child("messages").childByAutoId().setValue(mdata)
//        // TODO: create method that pushes message to the firebase database
//    }
//
//    func sendPhotoMessage(photoData: Data) {
//        let imagePath = "chat_photos/" + (Auth.auth().currentUser?.uid)! + "/\(Double(Date.timeIntervalSinceReferenceDate*1000)).jpg"
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        storageRef.child(imagePath).putData(photoData, metadata: metadata){(metadata,error) in
//            if let error = error{
//                print("error uploading\(error)")
//                return
//            }
//            self.sendMessage(data: [Constants.MessageFields.imageUrl:self.storageRef.child((metadata?.path)!).description])
//        }
//        // TODO: create method that pushes message w/ photo to the firebase database
//    }
//
//    // MARK: Alert
//
//    func showAlert(title: String, message: String) {
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
//            alert.addAction(dismissAction)
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    // MARK: Scroll Messages
//
//    func scrollToBottomMessage() {
//        if messages.count == 0 { return }
//        let bottomMessageIndex = IndexPath(row: messagesTable.numberOfRows(inSection: 0) - 1, section: 0)
//        messagesTable.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
//    }
//
//    // MARK: Actions
//
//    @IBAction func showLoginView(_ sender: AnyObject) {
//        loginSession()
//    }
//
//    @IBAction func didTapAddPhoto(_ sender: AnyObject) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .photoLibrary
//        present(picker, animated: true, completion: nil)
//    }
//
//    @IBAction func signOut(_ sender: UIButton) {
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("unable to sign out: \(error)")
//        }
//    }
//
//    @IBAction func didSendMessage(_ sender: UIButton) {
//        let _ = textFieldShouldReturn(messageTextField)
//        messageTextField.text = ""
//    }
//
//    @IBAction func dismissImageDisplay(_ sender: AnyObject) {
//        // if touch detected when image is displayed
//        if imageDisplay.alpha == 1.0 {
//            UIView.animate(withDuration: 0.25) {
//                self.backgroundBlur.effect = nil
//                self.imageDisplay.alpha = 0.0
//            }
//            dismissImageRecognizer.isEnabled = false
//            messageTextField.isEnabled = true
//        }
//    }
//
//    @IBAction func tappedView(_ sender: AnyObject) {
//        resignTextfield()
//    }
//}
//
//// MARK: - FCViewController: UITableViewDelegate, UITableViewDataSource
//
//extension FCViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // dequeue cell
//        let cell: UITableViewCell! = messagesTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
//        let messageSnapShot : DataSnapshot! = messages[indexPath.row]
//        let message =  messageSnapShot.value as! [String:String]
//        let name = message[Constants.MessageFields.name] ?? "[username]"
//        if let imageUrl = message[Constants.MessageFields.imageUrl]{
//            cell.textLabel!.text = "sent by \(name)"
//            Storage.storage().reference(forURL: imageUrl).getData(maxSize: INT64_MAX) { (data, error) in
//                guard error == nil else{
//                    print("error downloading\(error)")
//                    return
//                }
//                let messageImage = UIImage.init(data:data!,scale:50)
//                if cell == tableView.cellForRow(at: indexPath){
//                    DispatchQueue.main.async {
//                        cell.imageView?.image = messageImage
//                        cell.setNeedsLayout()
//                    }
//                }
//            }
//        }else{
//            let text = message[Constants.MessageFields.text] ?? "[message]"
//            cell.textLabel?.text = name + ":" + text
//            cell.imageView?.image = placeholderImage
//        }
//        return cell
//
//
//        // TODO: update cell to display message data
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // skip if keyboard is shown
//        guard !messageTextField.isFirstResponder else { return }
//        // unpack message from firebase data snapshot
//        let messageSnapshot: DataSnapshot! = messages[(indexPath as NSIndexPath).row]
//        let message = messageSnapshot.value as! [String: String]
//        // if tapped row with image message, then display image
//        if let imageUrl = message[Constants.MessageFields.imageUrl] {
//            if let cachedImage = imageCache.object(forKey: imageUrl as NSString) {
//                showImageDisplay(cachedImage)
//            } else {
//                Storage.storage().reference(forURL: imageUrl).getData(maxSize: INT64_MAX){ (data, error) in
//                    guard error == nil else {
//                        print("Error downloading: \(error!)")
//                        return
//                    }
//                    self.showImageDisplay(UIImage.init(data: data!)!)
//                }
//            }
//        }
//    }
//
//    // MARK: Show Image Display
//
//    func showImageDisplay(_ image: UIImage) {
//        dismissImageRecognizer.isEnabled = true
//        dismissKeyboardRecognizer.isEnabled = false
//        messageTextField.isEnabled = false
//        UIView.animate(withDuration: 0.25) {
//            self.backgroundBlur.effect = UIBlurEffect(style: .light)
//            self.imageDisplay.alpha = 1.0
//            self.imageDisplay.image = image
//        }
//    }
//}
//
//    // MARK: Show Image Display
//
//
//
//// MARK: - FCViewController: UIImagePickerControllerDelegate
//
//extension FCViewController: UIImagePickerControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
//        // constant to hold the information about the photo
//        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage, let photoData = UIImageJPEGRepresentation(photo, 0.8) {
//            // call function to upload photo message
//            sendPhotoMessage(photoData: photoData)
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
//
//// MARK: - FCViewController: UITextFieldDelegate
//
//extension FCViewController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // set the maximum length of the message
//        guard let text = textField.text else { return true }
//        let newLength = text.utf16.count + string.utf16.count - range.length
//        return newLength <= msglength.intValue
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if !textField.text!.isEmpty {
//            let data = [Constants.MessageFields.text: textField.text! as String]
//            sendMessage(data: data)
//            textField.resignFirstResponder()
//        }
//        return true
//    }
//
//    // MARK: Show/Hide Keyboard
//
//    func keyboardWillShow(_ notification: Notification) {
//        if !keyboardOnScreen {
//            self.view.frame.origin.y -= self.keyboardHeight(notification)
//        }
//    }
//
//    func keyboardWillHide(_ notification: Notification) {
//        if keyboardOnScreen {
//            self.view.frame.origin.y += self.keyboardHeight(notification)
//        }
//    }
//
//    func keyboardDidShow(_ notification: Notification) {
//        keyboardOnScreen = true
//        dismissKeyboardRecognizer.isEnabled = true
//        scrollToBottomMessage()
//    }
//
//    func keyboardDidHide(_ notification: Notification) {
//        dismissKeyboardRecognizer.isEnabled = false
//        keyboardOnScreen = false
//    }
//
//    func keyboardHeight(_ notification: Notification) -> CGFloat {
//        return ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
//    }
//
//    func resignTextfield() {
//        if messageTextField.isFirstResponder {
//            messageTextField.resignFirstResponder()
//        }
//    }
//}
//
//// MARK: - FCViewController (Notifications)
//
//extension FCViewController {
//
//    func subscribeToKeyboardNotifications() {
//        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
//        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
//        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
//        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
//    }
//
//    func subscribeToNotification(_ name: NSNotification.Name, selector: Selector) {
//        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
//    }
//
//    func unsubscribeFromAllNotifications() {
//        NotificationCenter.default.removeObserver(self)
//    }
//}