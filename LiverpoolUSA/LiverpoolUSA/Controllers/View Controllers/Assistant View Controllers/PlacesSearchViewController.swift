//
//  PlacesSearchViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/21/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

protocol PlaceSelectionDelegate {
    func didSelectPlace(place: Place)
}

class PlacesSearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var placesSearchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.isHidden = true
        searchResultsTableView.tableFooterView = UIView()
        let textFieldInsideSearchBar = placesSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        placesSearchBar.delegate = self
        placesSearchBar.placeholder = "Search for a location..."
        placesSearchBar.searchBarStyle = .minimal
        placesSearchBar.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Properties
    var placeDelegate: PlaceSelectionDelegate!
    var searchResults: [Place] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
            }
        }
    }
    var isSearching: Bool = false
    
    // MARK: - Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = placesSearchBar.text else { return }
        PlaceManager.fetchPlaces(searchTerm: searchTerm) { (places) in
            DispatchQueue.main.async {
                self.searchResultsTableView.isHidden = false
                self.searchResults = places
                print(searchTerm)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResults = []
            print("Clear text (x) tapped.")
        }
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - Extensions
extension PlacesSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesSearchResultsCell", for: indexPath)
        let place = searchResults[indexPath.row]
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = place.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = searchResults[indexPath.row]
        placeDelegate.didSelectPlace(place: place)
        self.dismiss(animated: true)
    }
}
