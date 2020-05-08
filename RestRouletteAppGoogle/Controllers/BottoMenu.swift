//
//  BottoMenu.swift
//  RestRouletteAppGoogle
//
//  Created by Egor on 02/05/2020.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BottoMenu: NSObject, UIGestureRecognizerDelegate{
    
    // MARK:  создание базовых элементов
    weak var baseViewController: ViewController?
    
    let baseView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let lable: UILabel = {
        let font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        let lbl = UILabel()
        lbl.text = "Категории поиска"
        lbl.textColor = UIColor.black
        lbl.font = font
        lbl.alpha = 0.86
        return lbl
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 12)
        layout.minimumInteritemSpacing = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let buttonMenuCategory: [MenuCategory] = {
        return [MenuCategory(name: "Кафе", imageName: "sandwich", type: RequestWord.cafe.rawValue),
                MenuCategory(name: "Доставка", imageName: "deliver-food", type: RequestWord.meal_delivery.rawValue),
                MenuCategory(name: "Рестораны", imageName: "barbecue", type: RequestWord.restaurant.rawValue),
                MenuCategory(name: "Бары", imageName: "cola", type: RequestWord.bar.rawValue)]
    }()
    
    // MARK: init
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BottomMenuCell.self, forCellWithReuseIdentifier: "botomMenuCell")
    }
    
    // MARK: добавление констрейнтов элементов
    func setupContraints() {
        
        lable.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let lblTopConstraint = NSLayoutConstraint(item: lable, attribute: .top, relatedBy: .equal, toItem: baseView, attribute: .top, multiplier: 1.0, constant: 12)
        let lblLeftConstraint = NSLayoutConstraint(item: lable, attribute: .leading, relatedBy: .equal, toItem: baseView, attribute: .leading, multiplier: 1.0, constant: 12)
        
        let collectionTopConstraint = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: lable, attribute: .bottom, multiplier: 1.0, constant: 10)
        let collectionLeftConstraint = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: baseView, attribute: .leading, multiplier: 1.0, constant: 0)
        let collectionTrailingConstraint = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: baseView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let collectionBottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: baseView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        baseView.addConstraints([lblTopConstraint, lblLeftConstraint, collectionTopConstraint,
        collectionLeftConstraint, collectionTrailingConstraint, collectionBottomConstraint])
    }
    
    // MARK: отображение меню
    func showBottomMenu(controller: ViewController) {
        
        baseViewController = controller
        
        let height: CGFloat = 150.0
        let yCoord = controller.view.bounds.height-height
        
        baseView.frame = CGRect(x: 0, y: controller.view.frame.height,
                                width: controller.view.frame.width, height: height)
        baseView.dropShadow()
        collectionView.frame = CGRect(x: 0, y: 0,
                                      width: baseView.bounds.width,
                                      height: baseView.bounds.height)
        
        baseView.addSubview(lable)
        baseView.addSubview(collectionView)
        setupContraints()
        
        controller.view.addSubview(baseView)
        controller.view.bringSubviewToFront(baseView)
    
        UIView.animate(withDuration: 0.2) {
            self.baseView.frame = CGRect(x: 0, y: yCoord, width: self.baseView.frame.width, height: height)
        }
        //animatewithduration более плавно потом посмотреть
    }
    
}

// MARK: экстеншены
extension BottoMenu: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttonMenuCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "botomMenuCell", for: indexPath) as! BottomMenuCell
        cell.menuCategory = buttonMenuCategory[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: baseView.frame.width/4 - 15, height: 80)
        return size
    }
}
extension BottoMenu: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BottomMenuCell
        let placeType = cell.typeOfPlace
        //baseViewController?.placeType = placeType
        baseViewController?.showCategoryMarker(type: placeType)
    }
}
extension BottoMenu: UICollectionViewDelegateFlowLayout{
    
}

