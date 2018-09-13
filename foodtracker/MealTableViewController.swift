//
//  MealTableViewController.swift
//  foodtracker
//
//  Created by anhxa100 on 9/4/18.
//  Copyright © 2018 anhxa100. All rights reserved.
//

import UIKit
import os.log



class MealTableViewController: UITableViewController, UISearchResultsUpdating {
    var searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Properties
    var filterMeals:[Meal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Edit Button
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //MARK: Search
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        filterMeals = DataService.share.meals
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        // #warning Incomplete implementation, return the number of rows
        return filterMeals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let meal = filterMeals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        // Configure the cell...

        return cell
    }
    
    //Unwind
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let meal = sourceViewController.meal{
            // Add new meal
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update existing meal
                filterMeals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                //Add a new meal
                let newIndexPath = IndexPath(row: filterMeals.count, section: 0)
                filterMeals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let detailViewController = segue.destination as? ViewController {
            if let indexPath = tableView.indexPathsForSelectedRows {
                if let index = DataService.share.meals.index(of: filterMeals[indexPath]) {
                    
                }
            }
        }
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let index  = DataService.share.meals.index(of: filterMeals[indexPath.row]){
                DataService.share.deleteMeal(at: index)
                filterMeals.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    //MARK: Search func
        func updateSearchResults(for searchController: UISearchController) {
            guard let searchText = searchController.searchBar.text else {return}
            filterMeals = searchText.isEmpty ? (DataService.share.meals) : (DataService.share.meals.filter({ (meals: Meal) -> Bool in
                return meals.name.lowercased().contains(searchText.lowercased())
                }))
            
            tableView.reloadData()
        }
    
    func searchCancelFuncClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text?.removeAll()
        filterMeals = DataService.share.meals
        tableView.reloadData()
    }
    
}
