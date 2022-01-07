//
//  PDFViewController.swift
//  OasisBooking
//
//  Created by MYGOV4 on 16/05/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//



import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    var pdfURL: URL! //= URL(string:"https://oasis.albicarepharma.in/tickets/ticket_1589608917.pdf")
    
    
    static var newInstance: PDFViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "PDFViewController") as! PDFViewController
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
            pdfView.autoScales = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        //  pdfView.frame = view.frame
    }
    @IBAction func downloadTicket(_ sender: Any) {
        //self.download()
        self.save(filename: "ticket.pdf")
    }
    @IBAction func dismisslMe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PDFViewController{
    func download(){
        guard let url = pdfURL else { return }
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    
    func save(filename : String) {
        //Save to file
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = pdfView.document?.dataRepresentation() else {return}
        let fileURL = url.appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
            
            let documento = data
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento], applicationActivities: nil)
             activityViewController.popoverPresentationController?.sourceView=self.view
             present(activityViewController, animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}


extension PDFViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfURL = destinationURL            
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    func downloadANdSave(){
        // Create destination URL
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(Date().timeIntervalSinceNow)ticket.pdf")
        
        //Create URL to the source file you want to download
        let fileURL = self.pdfURL
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                
                    
                    
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
                
            } else {
                print("Error took place while downloading a file. Error description: %@", error?.localizedDescription);
            }
        }
        task.resume()
        
    }
    
}


