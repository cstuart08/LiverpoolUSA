//
//  FixturesViewController.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/16/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class FixturesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var fixturesTableView: UITableView!
    
    // MARK: - Properties
    var fixtures: [Fixture] = []
    var pastFixtures: [PastFixture] = []
    var liveFixture: LiveFixture?
    var noGameData: LiveFixture = LiveFixture(time: "noMatch", homeTeamName: "noMatch", awayTeamName: "noMatch", location: "noMatch", league: "noMatch", score: "0 - 0")
    var apiCallCount: Int = 0
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fixturesTableView.delegate = self
        fixturesTableView.dataSource = self
        fixturesTableView.isHidden = true
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .liverpoolRed
        getAllFixtures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showLoadingScreen()
    }
    
    // MARK: - Methods
    func showLoadingScreen() {
        if apiCallCount == 0 {
            let loadingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loadingVC")
            loadingViewController.modalPresentationStyle = .overCurrentContext
            present(loadingViewController, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    func getAllFixtures() {
        FixturesController.shared.getFixtures { (success) in
            print("Received upcoming fixtures.")
            if success {
                self.fixtures = FixturesController.shared.placeholder
                print("WE did it")
            }
            LiveFixtureController.getLiveFixtures { (liveFixture) in
                if let liveLiverpoolFixture = liveFixture {
                    print("Received a live Liverpool fixture.")
                    self.liveFixture = liveLiverpoolFixture
                } else {
                    print("Did not receive a live Liverpool fixture.")
                    self.liveFixture = self.noGameData
                }
                PastFixturesController.getPastFixtures { (pastFixtures) in
                    print("Recieved past fixtures.")
                    self.pastFixtures = pastFixtures
                    DispatchQueue.main.async {
                        self.fixturesTableView.isHidden = false
                        self.navigationController?.isNavigationBarHidden = false
                        self.tabBarController?.tabBar.isHidden = false
                        let notification = Notification(name: Notification.Name(rawValue: "dismissLoadingView"))
                        NotificationCenter.default.post(notification)
                        self.fixturesTableView.reloadData()
                        let indexPath = NSIndexPath(row: 0, section: 1)
                        if self.apiCallCount == 0 {
                            self.fixturesTableView.scrollToRow(at: (indexPath as IndexPath), at: .top, animated: false)
                        }
                        self.apiCallCount = self.apiCallCount + 1
                    }
                }
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        getAllFixtures()
    }
}

// MARK: - Extensions
extension FixturesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pastFixtures.count
        } else if section == 1 {
            return 1
        } else {
            return fixtures.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fixtureCell", for: indexPath) as? FixtureTableViewCell else { return UITableViewCell() }
        cell.indexPath = indexPath
        cell.homeTeamLogo.image = nil
        cell.awayTeamLogo.image = nil
        if indexPath.section == 0 {
            let pastFixture = pastFixtures[indexPath.row]
            TeamLogoManager.shared.getLogos(fixture: nil, pastFixture: pastFixture, liveFixture: nil) { (homeLogo, awayLogo) in
                // Only pass this info if it is still the correct cell.
                let homeLogo = homeLogo
                let awayLogo = awayLogo
                cell.configure(fixture: nil, pastFixture: pastFixture, liveFixture: nil, logos: (homeLogo, awayLogo))
            }
        } else if indexPath.section == 1 {
            if let liveFixture = liveFixture {
                if liveFixture.homeTeamName == "noMatch" {
                    cell.awayScoreLabel.isHidden = true
                    cell.homeScoreLabel.isHidden = true
                    cell.fixtureTimeLabel.text = "No Live Match..."
                } else {
                    cell.awayScoreLabel.isHidden = false
                    cell.homeScoreLabel.isHidden = false
                }
                TeamLogoManager.shared.getLogos(fixture: nil, pastFixture: nil, liveFixture: liveFixture) { (homeLogo, awayLogo) in
                    // Only pass this info if it is still the correct cell.
                    let homeLogo = indexPath == cell.indexPath ? homeLogo : #imageLiteral(resourceName: "noImageAvailable")
                    let awayLogo = indexPath == cell.indexPath ? awayLogo : #imageLiteral(resourceName: "noImageAvailable")
                    cell.configure(fixture: nil, pastFixture: nil, liveFixture: liveFixture, logos: (homeLogo, awayLogo))
                }
            }
        } else {
            let fixture = fixtures[indexPath.row]
            TeamLogoManager.shared.getLogos(fixture: fixture, pastFixture: nil, liveFixture: nil) { (homeLogo, awayLogo) in
                // Only pass this info if it is still the correct cell.
                let homeLogo = homeLogo
                let awayLogo = awayLogo
                cell.configure(fixture: fixture, pastFixture: nil, liveFixture: nil, logos: (homeLogo, awayLogo))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [1, 0] {
            if liveFixture?.homeTeamName == "noMatch" {
                return 50
            } else {
                return 155
            }
        } else {
            return 155
        }
    }
}
