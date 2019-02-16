import UIKit
import FirebaseStorage
import FirebaseDatabase
import AlamofireImage
import MobileCoreServices

struct Person {
    var age: Int!
    var blood: String!
    var height: Int!
    var name: String!
    var weight: Int!
}

struct MedItem {
    var name: String!
    var img: String!
}

class ViewController: UIViewController {
    var gallery:UICollectionView!
    var uploadImg:UIImageView!
    var activityIndicatorView: UIActivityIndicatorView!
    var imagesPath:[String] {
        if let sources = UserDefaults.standard.value(forKey: "localImageSources") as? [String] {
            return sources
        } else {
            return []
        }
    }
    var alertController:UIAlertController?
    var items:[MedItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMedItems()
        createCollectionView()
        createUploadBtn()
        createIndicatorView()
        
        
        
    
//        var myButton = UIButton(type: .system)
//        myButton.setTitle("Alert", for: .normal)
//        myButton.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
//        self.view.addSubview(myButton)
//        myButton.translatesAutoresizingMaskIntoConstraints = false
//        myButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        myButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        myButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        myButton.addTarget(
//            nil,
//            action: #selector(ViewController.simpleAlert),
//            for: .touchUpInside)
        //post()
        
    }
    
    @objc func simpleAlert(_ url:String) {
        
        let alertController = UIAlertController(
            title: "提示",
            message: "一個簡單提示，請按確認繼續",
            preferredStyle: .alert)
        
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "帳號"
        }
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "確認",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                let acc =
                    (alertController.textFields?.first)!
                        as UITextField
                //print("按下確認後 \(acc.text)")
                
                let fileName:String = acc.text ?? "unknown"
                
                let dbRef: DatabaseReference! = Database.database().reference()
                dbRef.child("pictures").childByAutoId().setValue([
                    "name": fileName,
                    "img": url
                    ])
                self.items.append(MedItem(name: fileName, img: url))
                self.gallery.reloadData()
                
                print("itemsNumber: \(self.items.count)")
                
                
        })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
        
    }
    
    func getMedItems() {
        let dbRef: DatabaseReference! = Database.database().reference()
        dbRef.child("pictures").observe(.value) { snapshot in
            for item in snapshot.children {
                //print("user: \(user)")
                //users.append(user as! Person)
                let itemSnap = item as! DataSnapshot
                //print("Name: \(itemSnap.childSnapshot(forPath: "name").value)")

                // print("------Access------")
                var mItem:MedItem = MedItem(
                    name: itemSnap.childSnapshot(forPath: "name").value as! String,
                    img: itemSnap.childSnapshot(forPath: "img").value as! String
                )
                
                self.items.append(mItem)
                
                // MedItem
                // items.
                //for detail in userSnap.children {
                    //let dict = detail as! [String: String]

                    //print("NAME: \(detail)")
                //}
            }
            
            self.gallery.reloadData()
        }
        
    }
    
    @objc func refreshLoading() {

        self.gallery.reloadData()
        // picker.dismiss(animated: true, completion: nil)
        self.activityIndicatorView.stopAnimating()
        UIView.animate(withDuration: 2) {
            self.gallery.layer.opacity = 1
        }
        
    }
    
    func createIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        //activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = UIColor.white
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 44)
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 44)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func createUploadBtn() {
        uploadImg = UIImageView(image: UIImage(named: "oven"))
        view.addSubview(uploadImg)
        uploadImg.translatesAutoresizingMaskIntoConstraints = false
        uploadImg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        uploadImg.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        uploadImg.widthAnchor.constraint(equalToConstant: 32).isActive = true
        uploadImg.heightAnchor.constraint(equalToConstant: 32).isActive = true
        uploadImg.contentMode = .scaleAspectFit
        let guesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addImage(sender:)))
        uploadImg.addGestureRecognizer(guesture);
        uploadImg.isUserInteractionEnabled = true
    }
    
    @objc func addImage(sender: UITapGestureRecognizer) {
        activityIndicatorView.startAnimating()
        UIView.animate(withDuration: 2) {
            self.gallery.layer.opacity = 0
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }
    
    @objc func getDetail(sender: UITapGestureRecognizer) {
        
        if let pickView = sender.view {
            
            let selectView = pickView as! CollectionViewCell
            
            let destinationViewController: UIViewController!
            destinationViewController = DetailViewController()
            
            
            // destinationViewController.demoPhotoImageView.af_setImage(selectView.demoPhotoImageView.image)
            
            let objNavi = UINavigationController(rootViewController: destinationViewController)
            objNavi.navigationBar.prefersLargeTitles = true
            present(objNavi, animated: true, completion: {})
        }
        
    }
    
    func createCollectionView() {
        print("itemsNumber: ")
        let layout = UICollectionViewFlowLayout()
        let gap:CGFloat = 1
        let num: CGFloat = 6
        let singleSize:CGFloat = (self.view.frame.size.width - gap * (num + 1)) / num
        layout.sectionInset = UIEdgeInsets(top: 0, left: gap, bottom: 0, right: gap)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = gap
        layout.minimumInteritemSpacing = gap
        layout.itemSize = CGSize(width: singleSize, height: singleSize)
        gallery = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(gallery)
        gallery.delegate = self
        gallery.dataSource = self
        gallery.translatesAutoresizingMaskIntoConstraints = false
        gallery.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gallery.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gallery.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gallery.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gallery.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        refreshLoading()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        if mediaType == kUTTypeImage {
            if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let fileURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL?
                let storage = Storage.storage()
                let storageRef = storage.reference()
                
                let pictureRef = storageRef.child("pictures/\(fileURL?.lastPathComponent ?? "empty.jpeg")")
                let selectedImageData = img.jpegData(compressionQuality: 0.9)
                let uploadTask = pictureRef.putData(selectedImageData!, metadata: nil) {
                    (metadata, error) in guard let metadata = metadata else {
                        return
                    }
                    
                    pictureRef.downloadURL(completion: { (url, error) in
                        if let url = url {
                            // self.gallery.reloadData()
                            picker.dismiss(animated: true, completion: nil)
                            self.activityIndicatorView.stopAnimating()
                            UIView.animate(withDuration: 2) {
                                self.gallery.layer.opacity = 1
                            }
                            self.simpleAlert(url.absoluteString)
                        }
                    })
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = gallery.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        //let dataSource = imagesPath[indexPath.row]
        if let dataSource = items[indexPath.row].img {
            cell.demoPhotoImageView.af_setImage(withURL: URL(string: dataSource)!)
        }
        cell.layer.cornerRadius = 3
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.getDetail(sender:)))
        
        cell.addGestureRecognizer(gesture)
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    
}
