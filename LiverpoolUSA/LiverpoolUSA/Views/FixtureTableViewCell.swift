//
//  FixtureTableViewCell.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/16/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class FixtureTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var fixtureDateLabel: UILabel!
    @IBOutlet weak var fixtureTimeLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var competitionLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    
    //MARK: - Properties
    var fixture: Fixture?
    var pastFixture: PastFixture?
    var liveFixture: LiveFixture?
    var indexPath: IndexPath?
    
    
    //MARK: - Methods
    func configure(fixture: Fixture?, pastFixture: PastFixture?, liveFixture: LiveFixture?, logos: (UIImage, UIImage)) {
        
        self.fixture = fixture
        self.pastFixture = pastFixture
        
        if let fixture = fixture {
            DispatchQueue.main.async {
                self.homeTeamLabel.isHidden = false
                self.awayTeamLabel.isHidden = false
                self.homeScoreLabel.isHidden = true
                self.awayScoreLabel.isHidden = true
                self.homeTeamLogo.isHidden = false
                self.awayTeamLogo.isHidden = false
                self.fixtureDateLabel.isHidden = false
                self.competitionLabel.isHidden = false
                self.fixtureTimeLabel.isHidden = false
                self.fixtureDateLabel.text = DateHelper.shared.dateFromString(strDate: fixture.date)
                self.fixtureTimeLabel.text = DateHelper.shared.timeFromString(strTime: fixture.time)
                self.homeTeamLogo.image = logos.0
                self.awayTeamLogo.image = logos.1
                
                // Set home team name - with conditions
                if fixture.homeTeamName == "Wolverhampton Wanderers" {
                    self.homeTeamLabel.text = "Wolves"
                } else if fixture.homeTeamName == "Brighton & Hove Albion" {
                    self.homeTeamLabel.text = "Brighton"
                } else if fixture.homeTeamName == "Milton Keynes Dons" {
                    self.homeTeamLabel.text = "MK Dons"
                } else {
                    self.homeTeamLabel.text = fixture.homeTeamName
                }
                
                // Set away team name - with conditions
                if fixture.awayTeamName == "Wolverhampton Wanderers" {
                    self.awayTeamLabel.text = "Wolves"
                } else if fixture.awayTeamName == "Brighton & Hove Albion" {
                    self.awayTeamLabel.text = "Brighton"
                } else if fixture.awayTeamName == "Milton Keynes Dons" {
                    self.awayTeamLabel.text = "MK Dons"
                } else {
                    self.awayTeamLabel.text = fixture.awayTeamName
                }
                
                self.competitionLabel.text = LeagueGenerator.leagueNameGenerator(id: fixture.league, intID: nil)
                self.competitionLabel.layer.cornerRadius = 8
                self.competitionLabel.layer.masksToBounds = true
                if self.competitionLabel.text == LeagueNameConstants.premierLeague {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        self.competitionLabel.layer.backgroundColor = UIColor.clQualificationGreenDarkMode.cgColor
                    } else {
                        self.competitionLabel.layer.backgroundColor = UIColor.clQualificationGreen.cgColor
                    }
                } else if self.competitionLabel.text == LeagueNameConstants.championsLeague {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        self.competitionLabel.layer.backgroundColor = UIColor.championsLeagueBlue.cgColor
                    } else {
                        self.competitionLabel.layer.backgroundColor = UIColor.europaQualificationBlue.cgColor
                    }
                } else {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        self.competitionLabel.layer.backgroundColor = UIColor.superDarkGray.cgColor
                    } else {
                        self.competitionLabel.layer.backgroundColor = UIColor.superLightGray.cgColor
                    }
                }
            }
        } else if let liveFixture = liveFixture {
            if liveFixture.homeTeamName == "noMatch" {
                DispatchQueue.main.async {
                    self.fixtureTimeLabel.isHidden = false
                    self.homeTeamLabel.isHidden = true
                    self.awayTeamLabel.isHidden = true
                    self.homeScoreLabel.isHidden = true
                    self.awayScoreLabel.isHidden = true
                    self.homeTeamLogo.isHidden = true
                    self.awayTeamLogo.isHidden = true
                    self.fixtureDateLabel.isHidden = true
                    self.competitionLabel.isHidden = true
                    self.fixtureTimeLabel.text = "No Live Match..."
                }
                
            } else {
                DispatchQueue.main.async {
                    self.fixtureDateLabel.text = "Live"
                    self.fixtureTimeLabel.text = "\(liveFixture.time)'"
                    self.homeTeamLogo.image = logos.0
                    self.awayTeamLogo.image = logos.1
                    
                    let scoreStr = liveFixture.score
                    let scores = scoreStr.components(separatedBy: " - ")
                    self.homeScoreLabel.isHidden = false
                    self.awayScoreLabel.isHidden = false
                    self.homeScoreLabel.text = scores[0]
                    self.awayScoreLabel.text = scores[1]
                    self.homeTeamLabel.text = liveFixture.homeTeamName
                    self.awayTeamLabel.text = liveFixture.awayTeamName
                    self.competitionLabel.text = LeagueGenerator.leagueNameGenerator(id: nil, intID: liveFixture.league)
                    self.competitionLabel.layer.cornerRadius = 8
                    self.competitionLabel.layer.masksToBounds = true
                    if self.competitionLabel.text == LeagueNameConstants.premierLeague {
                        if self.traitCollection.userInterfaceStyle == .dark {
                            self.competitionLabel.layer.backgroundColor = UIColor.clQualificationGreenDarkMode.cgColor
                        } else {
                            self.competitionLabel.layer.backgroundColor = UIColor.clQualificationGreen.cgColor
                        }
                    } else if self.competitionLabel.text == LeagueNameConstants.championsLeague {
                        if self.traitCollection.userInterfaceStyle == .dark {
                            self.competitionLabel.layer.backgroundColor = UIColor.championsLeagueBlue.cgColor
                        } else {
                            self.competitionLabel.layer.backgroundColor = UIColor.europaQualificationBlue.cgColor
                        }
                    } else {
                        if self.traitCollection.userInterfaceStyle == .dark {
                            self.competitionLabel.layer.backgroundColor = UIColor.superDarkGray.cgColor
                        } else {
                            self.competitionLabel.layer.backgroundColor = UIColor.superLightGray.cgColor
                        }
                    }
                    self.colorScores()
                }
            }
        } else if let pastFixture = pastFixture {
            DispatchQueue.main.async {
                self.homeTeamLabel.isHidden = false
                self.awayTeamLabel.isHidden = false
                self.homeScoreLabel.isHidden = false
                self.awayScoreLabel.isHidden = false
                self.homeTeamLogo.isHidden = false
                self.awayTeamLogo.isHidden = false
                self.fixtureDateLabel.isHidden = false
                self.competitionLabel.isHidden = false
                self.fixtureDateLabel.text = DateHelper.shared.dateFromString(strDate: pastFixture.date)
                self.fixtureTimeLabel.isHidden = true
                self.homeTeamLogo.image = logos.0
                self.awayTeamLogo.image = logos.1
                
                let scoreStr = pastFixture.score
                let scores = scoreStr.components(separatedBy: " - ")
                self.homeScoreLabel.text = scores[0]
                self.awayScoreLabel.text = scores[1]
                self.homeTeamLabel.text = pastFixture.homeTeamName
                self.awayTeamLabel.text = pastFixture.awayTeamName
                self.competitionLabel.text = LeagueGenerator.leagueNameGenerator(id: pastFixture.league, intID: nil)
                self.competitionLabel.layer.cornerRadius = 8
                self.competitionLabel.layer.masksToBounds = true
                if self.competitionLabel.text == LeagueNameConstants.premierLeague {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        self.competitionLabel.layer.backgroundColor = UIColor.clQualificationGreenDarkMode.cgColor
                    } else {
                        self.competitionLabel.layer.backgroundColor = UIColor.clQualificationGreen.cgColor
                    }
                } else if self.competitionLabel.text == LeagueNameConstants.championsLeague {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        self.competitionLabel.layer.backgroundColor = UIColor.championsLeagueBlue.cgColor
                    } else {
                        self.competitionLabel.layer.backgroundColor = UIColor.europaQualificationBlue.cgColor
                    }
                } else {
                    if self.traitCollection.userInterfaceStyle == .dark {
                        self.competitionLabel.layer.backgroundColor = UIColor.superDarkGray.cgColor
                    } else {
                        self.competitionLabel.layer.backgroundColor = UIColor.superLightGray.cgColor
                    }
                }
                self.colorScores()
            }
        }
    }
    
    func colorScores() {
        guard let homeScore = Int(homeScoreLabel.text!) else {
            return
        }
        
        guard let awayScore = Int(awayScoreLabel.text!) else {
            return
        }
        
        if homeScore > awayScore {
            homeScoreLabel.textColor = .red
            if self.traitCollection.userInterfaceStyle == .dark {
                awayScoreLabel.textColor = .white
            } else {
                awayScoreLabel.textColor = .black
            }
        } else if homeScore < awayScore {
            awayScoreLabel.textColor = .red
            if self.traitCollection.userInterfaceStyle == .dark {
                homeScoreLabel.textColor = .white
            } else {
                homeScoreLabel.textColor = .black
            }
        } else {
            if self.traitCollection.userInterfaceStyle == .dark {
                homeScoreLabel.textColor = .white
                awayScoreLabel.textColor = .white
            } else {
                homeScoreLabel.textColor = .black
                awayScoreLabel.textColor = .black
            }
        }
    }
}
