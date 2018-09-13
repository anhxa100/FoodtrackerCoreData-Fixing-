//
//  Dataservice.swift
//  foodtracker
//
//  Created by anhxa100 on 9/12/18.
//  Copyright © 2018 anhxa100. All rights reserved.
//

import Foundation
import UIKit
import os.log

class DataService: NSObject {
    static let share: DataService = DataService()
    private var _meals: [Meal]?
    var meals: [Meal] {
        get {
            if _meals == nil {
                loadSimpleMeals()
            }
            return _meals ?? []
        }
        set {
            _meals = newValue
        }
    }
    func loadSimpleMeals() {
        _meals = []
        guard let meal1 = Meal(name: "Caprese Slalad", photo: #imageLiteral(resourceName: "meal1"), rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let meal2 = Meal(name: "Chicken and Potatoe", photo: #imageLiteral(resourceName: "meal2"), rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let meal3 = Meal(name: "Pasta with Meatballs" , photo: #imageLiteral(resourceName: "meal3"), rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        _meals? = [meal1, meal2, meal3]
        printMeals()
        
    }
    
    //MARK: Private methods
    private func saveMeals(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successful saved.", log: OSLog.default, type: .debug)
        }else{
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
    //MARK: add new meal
    func addNewMeal(meal: Meal){
        _meals?.append(meal)
    }
    //MARK: delete meal
    func deleteMeal(at index: Int){
        _meals?.remove(at: index)
    }
    //MARK: edit meal
    func editMeal(index: Int, meal: Meal){
        _meals?[index] = meal
    }
    //MARK: Debug
    func printMeals() {
        var i = 0
        for meal in meals {
            print("meal.name: [\(i)] '\(meal.name)'") // Debug
            i += 1
        }
    }
//    if let saveMeals = loadMeals() {
//        meals += saveMeals
//        printMeals() //Debug
//    }else{
//    loadSimpleMeals()
//    }
}
