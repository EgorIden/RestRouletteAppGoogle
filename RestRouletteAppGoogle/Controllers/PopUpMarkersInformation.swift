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
        lbl.alpha = 0.76
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
    
    let button: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        btn.titleLabel?.text = "Uber"
        btn.backgroundColor = UIColor.black
        return btn
    }()
    
    let closeView: UIImageView = {
        let img = UIImage(named: "close")
        let close = UIImageView(frame: .zero)
        close.image = img
        close.isUserInteractionEnabled = true
        return close
    }()
    
    weak var baseViewController: ViewController?
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
        button.translatesAutoresizingMaskIntoConstraints = false
        closeView.translatesAutoresizingMaskIntoConstraints = false
        
        let namePlaceTopConstraint = NSLayoutConstraint(item: namePlace, attribute: .top, relatedBy: .equal, toItem: baseView, attribute: .top, multiplier: 1.0, constant: 8)
        let namePlaceLeftConstraint = NSLayoutConstraint(item: namePlace, attribute: .leading, relatedBy: .equal, toItem: baseView, attribute: .leading, multiplier: 1.0, constant: 12)
        
        let addressPlaceTopConstraint = NSLayoutConstraint(item: addressPlace, attribute: .top, relatedBy: .equal, toItem: namePlace, attribute: .bottom, multiplier: 1.0, constant: 6)
        let addressPlaceLeftConstraint = NSLayoutConstraint(item: addressPlace, attribute: .leading, relatedBy: .equal, toItem: namePlace, attribute: .leading, multiplier: 1.0, constant: 0)

        let buttonTopConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: addressPlace, attribute: .bottom, multiplier: 1.0, constant: 24)
        let buttonLeftConstraint = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: addressPlace, attribute: .leading, multiplier: 1.0, constant: 0)

        let closeViewTopConstraint = NSLayoutConstraint(item: closeView, attribute: .top, relatedBy: .equal, toItem: baseView, attribute: .top, multiplier: 1.0, constant: 10)
        let closeViewRightConstraint = NSLayoutConstraint(item: closeView, attribute: .trailing, relatedBy: .equal, toItem: baseView, attribute: .trailing, multiplier: 1.0, constant: -10)

        
        baseView.addConstraints([namePlaceTopConstraint, namePlaceLeftConstraint, addressPlaceTopConstraint, addressPlaceLeftConstraint, buttonTopConstraint, buttonLeftConstraint, closeViewTopConstraint, closeViewRightConstraint])
    }
    // MARK: отображение информации о месте
    func showPopUpMarkersInformation(controller: ViewController, tappedMarker: PlaceMarker) {
        
        baseViewController = controller
        
        let height: CGFloat = 140.0
        let yCoord = controller.view.bounds.height-height
        
        baseView.frame = CGRect(x: 0, y: controller.view.frame.height,
                                width: controller.view.frame.width,
                                height: height)
        //baseView.dropShadow()
        
        namePlace.text = tappedMarker.name
        addressPlace.text = tappedMarker.vicinity
        
        baseView.addSubview(namePlace)
        baseView.addSubview(addressPlace)
        baseView.addSubview(closeView)
        baseView.addSubview(button)
        
        setupContraints()
        
        controller.view.addSubview(baseView)
        controller.view.bringSubviewToFront(baseView)
    
        UIView.animate(withDuration: 0.2) {
            self.baseView.frame = CGRect(x: 0, y: yCoord, width: self.baseView.frame.width, height: height)
        }
        
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopUp)))
        
        //animatewithduration более плавно потом посмотреть
    }
    @objc func dismissPopUp(){
                UIView.animate(withDuration: 0.15) {
                    self.baseView.frame = CGRect(x: 0, y: (self.baseViewController?.view.bounds.height)!, width: self.baseView.frame.width, height: self.baseView.frame.height)
        }
    }
    
}

