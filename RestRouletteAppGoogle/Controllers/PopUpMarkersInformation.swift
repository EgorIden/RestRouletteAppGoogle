//
//  PopUpMarkersInformation.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 04/05/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import UberRides

class PopUpMarkersInformation: NSObject{
    
    // MARK:  создание базовых элементов
    weak var baseViewController: ViewController?
    
    let baseView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let namePlace: UILabel = {
        let font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        let lbl = UILabel()
        lbl.text = "Название места"
        lbl.textColor = UIColor.black
        lbl.font = font
        lbl.alpha = 0.86
        return lbl
    }()
    
    let addressPlace: UILabel = {
        let font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        let lbl = UILabel()
        lbl.text = "Адрес"
        lbl.textColor = UIColor.black
        lbl.font = font
        lbl.alpha = 0.54
        return lbl
    }()
    
    let uber: UIImageView = {
        let img = UIImage(named: "uber")
        let ub = UIImageView(frame: .zero)
        ub.image = img
        return ub
    }()
    
    let uberView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let closeView: UIImageView = {
        let img = UIImage(named: "close")
        let close = UIImageView(frame: .zero)
        close.image = img
        close.isUserInteractionEnabled = true
        return close
    }()
    
    var currentUserLatitude: CLLocationDegrees?
    var currentUserLongitude: CLLocationDegrees?
    
    // MARK: init
    override init() {
        super.init()
        
    }
    
    // MARK: добавление констрейнтов элементов
    func setupContraints() {
        
        namePlace.translatesAutoresizingMaskIntoConstraints = false
        addressPlace.translatesAutoresizingMaskIntoConstraints = false
        uber.translatesAutoresizingMaskIntoConstraints = false
        uberView.translatesAutoresizingMaskIntoConstraints = false
        closeView.translatesAutoresizingMaskIntoConstraints = false
        
        uberView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        uberView.heightAnchor.constraint(equalTo: uber.heightAnchor, multiplier: 1.0).isActive = true
        
        let namePlaceTopConstraint = NSLayoutConstraint(item: namePlace, attribute: .top, relatedBy: .equal, toItem: baseView, attribute: .top, multiplier: 1.0, constant: 12)
        let namePlaceLeftConstraint = NSLayoutConstraint(item: namePlace, attribute: .leading, relatedBy: .equal, toItem: baseView, attribute: .leading, multiplier: 1.0, constant: 12)
        
        let addressPlaceTopConstraint = NSLayoutConstraint(item: addressPlace, attribute: .top, relatedBy: .equal, toItem: namePlace, attribute: .bottom, multiplier: 1.0, constant: 6)
        let addressPlaceLeftConstraint = NSLayoutConstraint(item: addressPlace, attribute: .leading, relatedBy: .equal, toItem: namePlace, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let uberCenterConstraint = NSLayoutConstraint(item: uber, attribute: .centerX, relatedBy: .equal, toItem: uberView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let uberCenterYConstraint = NSLayoutConstraint(item: uber, attribute: .centerY, relatedBy: .equal, toItem: uberView, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        let uberViewTopConstraint = NSLayoutConstraint(item: uberView, attribute: .top, relatedBy: .equal, toItem: addressPlace, attribute: .bottom, multiplier: 1.0, constant: 16)
        let uberViewLeftConstraint = NSLayoutConstraint(item: uberView, attribute: .leading, relatedBy: .equal, toItem: addressPlace, attribute: .leading, multiplier: 1.0, constant: 0)

        let closeViewTopConstraint = NSLayoutConstraint(item: closeView, attribute: .top, relatedBy: .equal, toItem: baseView, attribute: .top, multiplier: 1.0, constant: 12)
        let closeViewRightConstraint = NSLayoutConstraint(item: closeView, attribute: .trailing, relatedBy: .equal, toItem: baseView, attribute: .trailing, multiplier: 1.0, constant: -12)

        
        baseView.addConstraints([namePlaceTopConstraint, namePlaceLeftConstraint, addressPlaceTopConstraint, addressPlaceLeftConstraint, uberCenterConstraint, uberCenterYConstraint, uberViewTopConstraint, uberViewLeftConstraint, closeViewTopConstraint, closeViewRightConstraint])
    }
    
    // MARK: отображение информации о месте
    func showPopUpMarkersInformation(controller: ViewController, tappedMarker: PlaceMarker) {
        
        baseViewController = controller
        
        let height: CGFloat = 150.0
        let yCoord = controller.view.bounds.height-height
        
        baseView.frame = CGRect(x: 0, y: controller.view.frame.height,
                                width: controller.view.frame.width,
                                height: height)
        
        namePlace.text = tappedMarker.name
        addressPlace.text = tappedMarker.vicinity
        
        baseView.addSubview(namePlace)
        baseView.addSubview(addressPlace)
        uberView.addSubview(uber)
        baseView.addSubview(uberView)
        baseView.addSubview(closeView)
        
        setupContraints()
        
        controller.view.addSubview(baseView)
        controller.view.bringSubviewToFront(baseView)
    
        UIView.animate(withDuration: 0.2) {
            self.baseView.frame = CGRect(x: 0, y: yCoord,
                                         width: self.baseView.frame.width,
                                         height: height)
        }
        
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopUp)))
        uberView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uberTap)))
    }
    @objc func dismissPopUp(){
                UIView.animate(withDuration: 0.15) {
                    self.baseView.frame = CGRect(x: 0, y: (self.baseViewController?.view.bounds.height)!, width: self.baseView.frame.width, height: self.baseView.frame.height)
        }
    }
    @objc func uberTap(){
        showTaxiAlert(title: "Uber", text: "Такси успешно заказано")
    }
    
    // MARK: алерт
    func showTaxiAlert(title: String, text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.baseViewController!.present(alert, animated: true, completion: nil)
    }
}

