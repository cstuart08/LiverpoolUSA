//
//  StandingsViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/16/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit
import SafariServices

class StandingsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var standingsTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    //MARK: - Properties
    var standings: [TeamStanding] = []
    var currentTime: Float = 0.0
    var maxTime: Float = 10.0
    var apiCallCount: Int = 0
    var isDarkMode: Bool = false
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        standingsTableView.delegate = self
        standingsTableView.dataSource = self
        standingsTableView.isHidden = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor.liverpoolRed
        navigationController?.navigationBar.backgroundColor = UIColor.liverpoolRed
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarController?.tabBar.barTintColor = UIColor.liverpoolRed
        tabBarController?.tabBar.tintColor = UIColor.white
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.tabBarUnselectedColor
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        headerView.isHidden = true
        if self.traitCollection.userInterfaceStyle == .dark {
            isDarkMode = true
        }
        fetchStandings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .liverpoolRed
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showLoadingScreen()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        standingsTableView.reloadData()
    }
    
    // MARK: - Methods
    func fetchStandings() {
        StandingsController.fetchStandings { (standings) in
            self.standings = standings
            DispatchQueue.main.async {
                self.apiCallCount = self.apiCallCount + 1
                let notification = Notification(name: Notification.Name(rawValue: "dismissLoadingView"))
                NotificationCenter.default.post(notification)
                self.navigationController?.isNavigationBarHidden = false
                self.tabBarController?.tabBar.isHidden = false
                self.headerView.isHidden = false
                self.standingsTableView.isHidden = false
                self.standingsTableView.reloadData()
            }
        }
    }
    
    func rotateBarButton() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationCurve(.easeIn)
        let radians = CGFloat(180 * Double.pi / 180)
        refreshButton.customView?.transform = CGAffineTransform(rotationAngle: radians)
        UIView.commitAnimations()
    }
    
    func showLoadingScreen() {
        if apiCallCount == 0 {
            let loadingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loadingVC")
            loadingViewController.modalPresentationStyle = .overCurrentContext
            present(loadingViewController, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    //MARK: - Actions
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://cameronstuart.com/liverpoolusa-support") else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true)
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchStandings()
        rotateBarButton()
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
            if self.traitCollection.userInterfaceStyle == .dark {
                cell.backgroundColor = .clQualificationGreenDarkMode
            } else {
                cell.backgroundColor = .clQualificationGreen
            }
        } else if standing.teamRank == "5" {
            if self.traitCollection.userInterfaceStyle == .dark {
                cell.backgroundColor = .championsLeagueBlue
            } else {
                cell.backgroundColor = .europaQualificationBlue
            }
        } else if standing.teamRank == "18" || standing.teamRank == "19" || standing.teamRank == "20" {
            if self.traitCollection.userInterfaceStyle == .dark {
                cell.backgroundColor = .relegationRedDarkMode
            } else {
                cell.backgroundColor = .relegationRed
            }
        } else {
            if isDarkMode == true {
                cell.backgroundColor = .black
            } else {
                cell.backgroundColor = .white
            }
        }
        return cell
    }
}
