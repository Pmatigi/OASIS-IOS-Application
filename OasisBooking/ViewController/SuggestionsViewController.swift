//
//  SuggestionsViewController.swift
//  OasisBooking
//
//  Created by Anuj Garg on 11/02/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol SuggestionDelegate : class{
    func suggestedCityName(data:City)
}

class SuggestionsViewController: UIViewController {

    static var newInstance: SuggestionsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "SuggestionsViewController") as! SuggestionsViewController
        return vc
    }
    
    @IBOutlet weak var suggetionTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate: SuggestionDelegate?

    var city : Array<City> = []{
        didSet {
          self.filteredCity = self.city
        }
    }

    var filteredCity: Array<City> = [] {
            didSet {
              self.suggetionTableView.delegate = self
              self.suggetionTableView.dataSource = self
              self.suggetionTableView.reloadData()
            }
          }
          
    var isSearchActive = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated:  true)
        City().getAllCities { (city, Success) in
            if Success{
                self.city = city ?? []
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            else{
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnClick(sender: UIButton!) {
           self.dismiss(animated: true, completion: nil)
       }
}

extension SuggestionsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCity.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let cell = tableView.dequeueReusableCell(withIdentifier: "BusWithTravelAgencyCell", for: indexPath) as! BusWithTravelAgencyCell
        // cell.lblRating.text = (filteredCity[indexPath.row] as? NSDictionary)?.value(forKey: "name") as? String//
        cell.lblRating.text = filteredCity[indexPath.row].cityName

         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.suggestedCityName(data: filteredCity[indexPath.row])
        DispatchQueue.main.async {
         self.dismiss(animated: false, completion: nil)

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension SuggestionsViewController: UISearchBarDelegate{
  
func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
    isSearchActive = true
}

func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
    searchBar.text = ""
    searchBar.resignFirstResponder()
    isSearchActive = false
    
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.filterArrayBy(strText: searchText)
    if searchText.isEmpty{
        isSearchActive = false
    }
}


func filterArrayBy(strText: String) {
    if !strText.isEmpty{
        self.isSearchActive = true
    }
    else{
        self.isSearchActive = false
        
    }

    let result = city.filter { (($0.cityName?.lowercased())?.contains(strText.lowercased()))! }
    print(result)
    
    if !strText.isEmpty {
        self.filteredCity  = result
    }
    else{
        self.filteredCity = self.city
     }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text!.isEmpty {
           searchBar.resignFirstResponder()
            return
        }
    }
}
