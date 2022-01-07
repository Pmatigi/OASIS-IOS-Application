//
//  BusImagesCollectionViewController.swift
//  OasisBooking
//
//  Created by Anuj Garg on 09/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "BusImageCollectionViewCell"

class BusImagesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imagesCOllectionView: UICollectionView!
    
    var imagesBus = [BusImage]()
    var arrRating = [Ratings]()//["It is good i will give 4.3","It is ok i will give 3.3","It is Not satisfactory, i will give 2.3"]
    var imageAmenities = [Amenities]()  //["pillow","wifi","wifi-1","waterbottle","juice"]
    var type = String()
    
    static var newInstance: BusImagesCollectionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "BusImagesCollectionViewController") as! BusImagesCollectionViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCOllectionView.register(UINib(nibName: "AmenitiesCell", bundle: nil), forCellWithReuseIdentifier: "AmenitiesCell")
        imagesCOllectionView.register(UINib(nibName: "RatingCell", bundle: nil), forCellWithReuseIdentifier: "RatingCell")

    }
    
    @IBAction func dismissMe(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func snapToCenter() {
        let centerPoint = self.imagesCOllectionView.center
           guard let centerIndexPath = imagesCOllectionView.indexPathForItem(at: centerPoint)
               else{
                   return
           }
           imagesCOllectionView.scrollToItem(at: centerIndexPath, at: .centeredHorizontally, animated: true)
       }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if type == popUpType.rating.rawValue{
            return arrRating.count
        }
        else if type == popUpType.amenities.rawValue {
            return imageAmenities.count
        }
        else{
            return imagesBus.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = BusImageCollectionViewCell()
        if type == popUpType.bus.rawValue {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BusImageCollectionViewCell
            if let busUrl = imagesBus[indexPath.row].path as? String{
                let imageUrl = URL(string: busUrl)
                cell.busImagesView.sd_setImage(with:imageUrl, completed: nil)
            }
        }
        else if type == popUpType.amenities.rawValue {
        cell = self.imagesCOllectionView.dequeueReusableCell(withReuseIdentifier: "AmenitiesCell", for: indexPath) as! BusImageCollectionViewCell
            if imageAmenities[indexPath.row].name == "Water Bottle"
            {
                cell.lblTitle.text = imageAmenities[indexPath.row].name
                cell.busImagesView.image = UIImage(named: "Water_bottles")
            }else if imageAmenities[indexPath.row].name == "Blankets"{
                cell.lblTitle.text = imageAmenities[indexPath.row].name
                cell.busImagesView.image = UIImage(named: "Towels")
            }
            else if imageAmenities[indexPath.row].name == "Pillow"{
                cell.lblTitle.text = imageAmenities[indexPath.row].name
                cell.busImagesView.image = UIImage(named: "Towels")
            }
            else if imageAmenities[indexPath.row].name == "Charging Point"{
                cell.lblTitle.text = imageAmenities[indexPath.row].name
                cell.busImagesView.image = UIImage(named: "electric_outlet")
            }
            else if imageAmenities[indexPath.row].name == "Movie"{
                cell.lblTitle.text = imageAmenities[indexPath.row].name
                cell.busImagesView.image = UIImage(named: "tv")
            }
            else{
               cell.lblTitle.text = imageAmenities[indexPath.row].name
               cell.busImagesView.image = UIImage(named: "wifi")
            }
        }
        else{
             cell = self.imagesCOllectionView.dequeueReusableCell(withReuseIdentifier: "RatingCell", for: indexPath) as! BusImageCollectionViewCell
            cell.lblTitle.text = arrRating[indexPath.row].review
         }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if type == popUpType.bus.rawValue {
            return CGSize(width: imagesCOllectionView.frame.size.width, height: imagesCOllectionView.frame.size.height)
        }
        else if type == popUpType.rating.rawValue {
            return CGSize(width: imagesCOllectionView.frame.size.width-20, height: imagesCOllectionView.frame.size.height)

        }
        else {
           return CGSize(width: 133, height: 66)
        }
    }
   func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        snapToCenter()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToCenter()
        }
    }
}

class snapToCenterLayOut: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        let midX: CGFloat = collectionView.bounds.size.width / 2
        guard let closestAttribute = findClosestAttributes(toXPosition: proposedContentOffset.x + midX) else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        return CGPoint(x: closestAttribute.center.x - midX, y: proposedContentOffset.y)
    }
    
    private func findClosestAttributes(toXPosition xPosition: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        let searchRect = CGRect(
            x: xPosition - collectionView.bounds.width, y: collectionView.bounds.minY,
            width: collectionView.bounds.width * 2, height: collectionView.bounds.height
        )
        return layoutAttributesForElements(in: searchRect)?.min(by: { abs($0.center.x - xPosition) < abs($1.center.x - xPosition) })
    }
}
