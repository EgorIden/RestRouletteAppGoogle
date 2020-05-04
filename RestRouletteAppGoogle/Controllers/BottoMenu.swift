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

class BottoMenu: NSObject{
    
    // MARK:  создание базовых элементов
    let baseView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let lable: UILabel = {
        let font = UIFont.boldSystemFont(ofSize: 20)
        let lbl = UILabel()
        lbl.text = "Категории поиска"
        lbl.textColor = UIColor.black
        lbl.font = font
        lbl.alpha = 0.86
        return lbl
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        //layout.itemSize = CGSize(width: 86, height: 94)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let buttonMenuCategory: [MenuCategory] = {
        return [MenuCategory(name: "Кафе", imageName: "pastry", type: "cafe"),
                MenuCategory(name: "Доставка", imageName: "recipe-book", type: "meal_delivery"),
                MenuCategory(name: "Рестораны", imageName: "daily-specials", type: "restaurant"),
                MenuCategory(name: "Бары", imageName: "beer", type: "bar")]
    }()
    
    weak var baseViewController: ViewController?
    
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
        let lblLeftConstraint = NSLayoutConstraint(item: lable, attribute: .leading, relatedBy: .equal, toItem: baseView, attribute: .leading, multiplier: 1.0, constant: 24)
        
        let collectionTopConstraint = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: lable, attribute: .bottom, multiplier: 1.0, constant: 8)
        let collectionLeftConstraint = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: baseView, attribute: .leading, multiplier: 1.0, constant: 0)
        let collectionTrailingConstraint = NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: baseView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let collectionBottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: baseView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        baseView.addConstraints([lblTopConstraint, lblLeftConstraint, collectionTopConstraint,
        collectionLeftConstraint, collectionTrailingConstraint, collectionBottomConstraint])
    }
    // MARK: отображение меню
    func showBottomMenu(controller: ViewController) {
        
        baseViewController = controller
        
        let height: CGFloat = 180.0
        let yCoord = controller.view.bounds.height-height
        
        baseView.frame = CGRect(x: 0, y: controller.view.frame.height, width: controller.view.frame.width, height: height)
        collectionView.frame = CGRect(x: 0, y: 0, width: baseView.bounds.width, height: baseView.bounds.height)
        
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
        let size = CGSize(width: baseView.frame.width/4, height: 90)
        return size
    }
}
extension BottoMenu: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BottomMenuCell
        let placeType = cell.typeOfPlace
        baseViewController?.placeType = placeType
    }
}
extension BottoMenu: UICollectionViewDelegateFlowLayout{
    
}

