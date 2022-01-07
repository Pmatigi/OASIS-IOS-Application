//
//  ProfileViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 25/01/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import SDWebImage
import  MBProgressHUD

class ProfileViewController: UIViewController {
    @IBOutlet weak var tblProfile: UITableView!
    var arrOptions = ["","My Booking","Call Support"]
    var arrOptions1 = ["Setting","About Us"]
    var arrOptions2 = ["Logout","Login"]
    
    var imagePicker : UIImagePickerController?
    var profileImage: UIImage?
    var user : User?{
        didSet{
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tblProfile.reloadData()
            }
        }
    }
    
    var isLoggingIn = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeLoginNotifications()
        self.navigationController?.isNavigationBarHidden = true
        self.tblProfile.contentInset = UIEdgeInsets(top: -33, left: 0, bottom: 0, right: 0)
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        self.imagePicker?.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if DataModel.shared.isLoggedIn, self.user == nil {
            self.getUserProfile()
        }
        if isLoggingIn {
            self.tabBarController?.selectedIndex = 0
            isLoggingIn = false
        }
        self.tblProfile.reloadData()
    }
    
    override func setupForUserLoginStatus() {
        self.tblProfile.reloadData()
    }
    
    
    @IBAction func changeImageButtonTapped(_ sender: Any) {
        self.pickImage()
    }
    
    
    private func logoutUser() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure to want to logout?",preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Logout",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        self.proceedLogout()
                                        
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func proceedLogout() {
        //logout service api todo
        DataModel.shared.logoutUser()
        self.user = nil
        self.profileImage = nil
        self.handleLoginStatus()
        self.isLoggingIn = true
        self.appDelegate.showAuthentication()
    }
    
    func handleLoginStatus() {
        //           self.viewPoints.isHidden = !DataModel.shared.isLoggedIn
        //           self.editProfileButton.isHidden = !DataModel.shared.isLoggedIn
        //           self.loginButton.isHidden = DataModel.shared.isLoggedIn
        //           self.loginButton.setTitle(R.string.localisable.login.localized(), for: .normal)
        //           self.nameLabel.text = DataModel.shared.isLoggedIn ? "" : R.string.localisable.welcomeToAnuj Garg()
        //           self.locationLabel.text = ""
        self.tblProfile.reloadData()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0{
            return arrOptions.count
        }else if section == 1 {
            return arrOptions1.count
        }else{
            return arrOptions2.count-1
        }
        //return arrOptions.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTopCell", for: indexPath) as! ProfileTopCell
                if let user = self.user{
                    //let defaultAvatar = UIImage(named: "profileimg")
                    if self.profileImage != nil{
                         cell.imgProfile.image = self.profileImage
                    }else{
                    if let imgUrl = URL(string: user.image!) {
                        UIImageView().dowloadFromServer(url:imgUrl) { (imageProfile) in
                            self.profileImage = imageProfile
                            DispatchQueue.main.async {
                                cell.imgProfile.image = self.profileImage
                            }
                        }
                       }
                    }
                    
                    cell.lblName.text = user.username ?? ""//(user.first_name ?? "") + " " + (user.last_name ?? "")
                    cell.lblEmail.text = user.email ?? ""
                    cell.lblMobileNo.text = user.phone_no ?? ""
                    
                }
                else{
                    let defaultAvatar = UIImage(named: "profileimg")
                    cell.imgProfile.image = defaultAvatar
                    cell.lblName.text = ""
                    cell.lblEmail.text = ""
                    cell.lblMobileNo.text = ""
                    if self.profileImage != nil {
                        cell.imgProfile.image = self.profileImage
                    }
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOptionCell", for: indexPath) as! ProfileOptionCell
                cell.lblOption.text = self.arrOptions[indexPath.row]
                return cell
            }
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOptionCell", for: indexPath) as! ProfileOptionCell
            cell.lblOption.text = self.arrOptions1[indexPath.row]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOptionCell", for: indexPath) as! ProfileOptionCell
            if self.user != nil{
                cell.lblOption.text = self.arrOptions2[0]
            }
            else{
                cell.lblOption.text = self.arrOptions2[1]
            }
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 185
            }else{
                return 60
            }
        }else{
            return 60
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0
            {}
            else if indexPath.row == 1{
                if #available(iOS 13.0, *) {
                    let myBookingView = self.storyboard?.instantiateViewController(identifier: "MyBookingViewController") as! MyBookingViewController
                    self.navigationController?.showDetailViewController(myBookingView, sender: self)
                    
                } else {
                    let myBookingView = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingViewController") as! MyBookingViewController
                    self.navigationController?.showDetailViewController(myBookingView, sender: self)
                }
            }
            else //if indexPath.row == 2
            {
                if let phoneCallURL = URL(string: "tel://\(9967487121)"), UIApplication.shared.canOpenURL(phoneCallURL)
                {
                    UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
                }else{
                    let alert = UIAlertController(title: "Alert", message: "Phone call not available", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        @unknown default:
                            print("No action")
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            }}
        else if indexPath.section == 1{
            if indexPath.row == 0{
                if #available(iOS 13.0, *) {
                    let settingView = self.storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
                    self.navigationController?.showDetailViewController(settingView, sender: self)
                    
                } else {
                    let settingView = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                    self.navigationController?.showDetailViewController(settingView, sender: self)
                }
            }
            else {
                if #available(iOS 13.0, *) {
                    let aboutUsView = self.storyboard?.instantiateViewController(identifier: "AboutUsViewController") as! AboutUsViewController
                    self.navigationController?.showDetailViewController(aboutUsView, sender: self)
                    
                } else {
                    let aboutUsView = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                    self.navigationController?.showDetailViewController(aboutUsView, sender: self)
                }
            }
        }
        else{
            if self.user != nil{
             self.logoutUser()
             }
             else{
                self.appDelegate.showAuthentication()
             }
        }
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickImage(){
        let alertController = UIAlertController.init(title: "Choose Profile Picture",
                                                     message: nil,
                                                     preferredStyle: .actionSheet)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        guard let imagePicker = self.imagePicker else { return }
        let camera = UIAlertAction.init(title: "Camera", style: .default) { (alertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                imagePicker.sourceType = .camera
                imagePicker.modalPresentationStyle = .overFullScreen
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else {
                self.showAlertController(title: "Alert", message: "Camera is not available")
            }
        }
        
        let photos = UIAlertAction.init(title: "Photos", style: .default) { (alertAction) in
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .overFullScreen
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(camera)
        alertController.addAction(photos)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        // self.profileImage = pickedImage
        picker.dismiss(animated: true, completion: nil)
        
        guard let userId = DataModel.shared.currentUserId() else {return}
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = pickedImage as? UIImage else { return }
        
        uploadProfileImage(profileImage: image, userId: userId, complitionHandller: { (success, result) in
            if success{
                let imgUrl = URL(string: result?.value(forKey: "image_path") as! String)
                UIImageView().dowloadFromServer(url: imgUrl!) { (imageProfile) in
                    self.profileImage = imageProfile
                    DispatchQueue.main.async {
                        self.tblProfile.reloadData()
                    }
                    
                }
            }
        })
        // uploadProfilePic(profileImage: self.profileImage!, userId: userId)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
