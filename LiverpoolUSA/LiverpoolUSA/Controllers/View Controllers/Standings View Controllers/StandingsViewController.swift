//
//  StandingsViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/16/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit
import SafariServices
import Network

class StandingsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var standingsTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    //MARK: - Properties
    var standings: [TeamStanding] = []
    var currentTime: Float = 0.0
    var maxTime: Float = 10.0
    var apiCallCount: Int = 0
    let monitor = NWPathMonitor()
    let button1: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 60))
    var refreshing = false
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        button1.setTitle("", for: .normal)
        button1.setImage(UIImage(systemName:    "arrow.clockwise"), for: .normal)
        button1.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        let barItem1: UIBarButtonItem = UIBarButtonItem(customView: button1)
        navigationItem.setLeftBarButton(barItem1, animated: true)
        standingsTableView.delegate = self
        standingsTableView.dataSource = self
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.liverpoolRed
        navigationController?.navigationBar.backgroundColor = UIColor.liverpoolRed
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarController?.tabBar.barTintColor = UIColor.liverpoolRed
        tabBarController?.tabBar.tintColor = UIColor.white
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.tabBarUnselectedColor
        self.standings = StandingsController.shared.standings
        if self.standings.count == 0 {
            self.rotateBarButton()
            self.standingsTableView.isHidden = true
            navigationController?.isNavigationBarHidden = true
            tabBarController?.tabBar.isHidden = true
            self.headerView.isHidden = true
            self.fetchStandings()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        standingsTableView.reloadData()
    }
    
    // MARK: - Methods
    func fetchStandings() {
        self.refreshing = true
        StandingsController.shared.fetchStandings { (standings) in
            self.standings = standings
            DispatchQueue.main.async {
                if self.standings.count == 0 {
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "noNetworkSB") as! NoNetworkViewController
                    viewController.view.backgroundColor = UIColor.white.withAlphaComponent(0)
                    viewController.modalPresentationStyle = .overFullScreen
                    self.definesPresentationContext = true
                    self.present(viewController, animated: true)
                    self.navigationController?.isNavigationBarHidden = false
                    self.tabBarController?.tabBar.isHidden = false
                    self.headerView.isHidden = false
                    self.refreshing = false
                } else {
                    self.apiCallCount = self.apiCallCount + 1
                    self.navigationController?.isNavigationBarHidden = false
                    self.tabBarController?.tabBar.isHidden = false
                    self.headerView.isHidden = false
                    self.standingsTableView.isHidden = false
                    self.standingsTableView.reloadData()
                    self.refreshing = false
                }
            }
        }
    }
    
    @objc func refreshButtonTapped() {
        fetchStandings()
        rotateBarButton()
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
    
    //MARK: - Actions
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://cameronstuart.com/redsusa-support") else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true)
    }
}

// MARK: - Extensions
extension StandingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "standingCell", for: indexPath) as! TeamStandingTableViewCell
        cell.logoImage.image = nil
        let standing = standings[indexPath.row]
        cell.content = standing
        
        
        if standing.teamRank == "1" || standing.teamRank == "2" ||  standing.teamRank == "3" || standing.teamRank == "4" {
            cell.backgroundColor = .clQualificationGreen
        } else if standing.teamRank == "5" {
            cell.backgroundColor = .europaQualificationBlue
        } else if standing.teamRank == "18" || standing.teamRank == "19" || standing.teamRank == "20" {
            cell.backgroundColor = .relegationRed
        } else {
            cell.backgroundColor = .liverpoolWhite
        }
        return cell
    }
}
