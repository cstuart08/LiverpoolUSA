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
    
    // MARK: - Properties
    let button1: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 60))
    var refreshing = false
    
    // MARRK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.setTitle("", for: .normal)
        button1.setImage(UIImage(systemName:    "arrow.clockwise"), for: .normal)
        button1.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        let barItem1: UIBarButtonItem = UIBarButtonItem(customView: button1)
        navigationItem.setLeftBarButton(barItem1, animated: true)
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.tableFooterView = UIView()
        eventsTableView.isHidden = true
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
                DispatchQueue.main.async {
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "noNetworkSB") as! NoNetworkViewController
                    viewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
                    viewController.modalPresentationStyle = .overFullScreen
                    self.definesPresentationContext = true
                    self.present(viewController, animated: true)
                }
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViews), name: EventController.shared.eventsWereUpdatedNotification, object: nil)
        rotateBarButton()
        getAllEvetns()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectCells()
    }
    
    // MARK: - Methods
    
    func deselectCells() {
        guard let selectedItems = eventsTableView.indexPathsForSelectedRows else { return }
        for indexPath in selectedItems {
            eventsTableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func getAllEvetns() {
        refreshing = true
        EventController.shared.fetchAllEvents { (events) in
            self.refreshing = false
            DispatchQueue.main.async {
                print("Reloading events tableview data")
                self.eventsTableView.reloadData()
                self.eventsTableView.isHidden = false
            }
        }
    }
    
    @objc func refreshButtonTapped() {
        getAllEvetns()
        rotateBarButton()
    }
    
    @objc func reloadViews() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.eventsTableView.reloadData()
        }
    }
    
    func rotateBarButton() {
        UIView.animate(withDuration: 0.7) { () -> Void in
          self.button1.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }

        UIView.animate(withDuration: 0.7, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
          self.button1.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }) { (_) in
            if self.refreshing == true {
                self.rotateBarButton()
            }
        }
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
