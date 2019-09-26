//
//  EventsViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/20/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARRK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.liverpoolRed
        self.navigationController?.navigationBar.backgroundColor = UIColor.liverpoolRed
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.tabBarController?.tabBar.barTintColor = UIColor.liverpoolRed
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.tabBarUnselectedColor
        UserBlacklistController.shared.fetchBlacklist { (success) in
            if success {
                print("Blacklist retreived.")
            } else {
                print("No Blacklist found.")
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: EventController.shared.eventsWereUpdatedNotification, object: nil)
        getAllEvetns()
    }
    
    // MARK: - Methods
    func getAllEvetns() {
        EventController.shared.fetchAllEvents { (events) in
            print("attempting fetch of all events")
            DispatchQueue.main.async {
                print("Reloading events tableview data")
                self.eventsTableView.reloadData()
            }
        }
    }
    
    @objc func reloadViews() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.eventsTableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        getAllEvetns()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventCellToDetailVC" {
            if let index = eventsTableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? EventDetailViewController else { return }
                let eventToSend = EventController.shared.events[index.row]
                destinationVC.eventLandingPad = eventToSend
                destinationVC.eventIndex = index.row
            }
        }
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventController.shared.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventsTableViewCell else { return UITableViewCell() }
        
        let event = EventController.shared.events[indexPath.row]
        cell.event = event
        
        return cell
    }
}
