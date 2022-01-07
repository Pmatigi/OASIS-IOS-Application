//
//  TicketDetailViewController.swift
//  OasisBooking
//
//  Created by Neeraj Mishra on 11/04/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit

class TicketDetailViewController: UIViewController {
    
    @IBOutlet weak var tblTicketDetail: UITableView!
    public var bookind_Id : String?
    
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var isCurrentBooking = Bool()
    
    static var newInstance: TicketDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "TicketDetailViewController") as! TicketDetailViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tblTicketDetail.contentInset = UIEdgeInsets(top: -33, left: 0, bottom: 0, right: 0)
        self.btnCancel.isHidden = !isCurrentBooking
    }
    
    var booking : Booking?{
        didSet {
            bookind_Id = booking?.booking_id
        }
    }
    
    @IBAction func backBtnClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.cancelPayment { (success, message) in
            if success{
                let alert = UIAlertController(title: "Success!", message: message,preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnDownloadClick(_ sender: Any) {
        let vc = PDFViewController.newInstance
        guard let url = URL(string:(booking?.ticket_pdf)!) else {return}
        vc.pdfURL = url
        self.present(vc, animated: true, completion: nil)
    }
    
}

// Extension UItableview datasource and delegates

extension TicketDetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketCell", for: indexPath) as! TicketCell
        cell.viewTop.layer.cornerRadius = 12.0
        cell.viewTop.clipsToBounds = true
        cell.viewMiddle.layer.cornerRadius = 15.0
        cell.viewMiddle.clipsToBounds = true
        cell.configure(booking:self.booking!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}
