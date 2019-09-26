//
//  TeamStandingTableViewCell.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/16/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class TeamStandingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var matchesPlayedLabel: UILabel!
    @IBOutlet weak var matchesWonLabel: UILabel!
    @IBOutlet weak var matchesDrawnLabel: UILabel!
    @IBOutlet weak var matchesLostLabel: UILabel!
    @IBOutlet weak var goalsScoredConcededLabel: UILabel!
    @IBOutlet weak var goalDifferenceLabel: UILabel!
    @IBOutlet weak var teamTotalPointsLabel: UILabel!
    @IBOutlet weak var customSeparatorView: UIView!
    
    var teamLogoURL = ""
    
    var content: TeamStanding? {
        didSet {
            logoImage.image = nil
            guard let content = content else { return }
            
            DispatchQueue.main.async {
                if content.teamRank == "1" || content.teamRank == "2" ||  content.teamRank == "3" || content.teamRank == "4" {
                    self.customSeparatorView.backgroundColor = .greenSeparatorColor
                } else if content.teamRank == "5" {
                    self.customSeparatorView.backgroundColor = .blueSeparatorColor
                } else if content.teamRank == "18" || content.teamRank == "19" || content.teamRank == "20" {
                    self.customSeparatorView.backgroundColor = .redSeparatorColor
                } else {
                    self.customSeparatorView.backgroundColor = .superLightGray
                }
            }
            
            TeamLogoManager.shared.getTeamLogo(teamName: content.teamName) { (teamLogo) in
                DispatchQueue.main.async {
                    self.logoImage.image = teamLogo
                }
            }
            
            rankLabel.text = content.teamRank
            
            if content.teamName == "Wolverhampton Wanderers" {
                teamNameLabel.text = "Wolves"
            } else if content.teamName == "Brighton & Hove Albion" {
                teamNameLabel.text = "Brighton"
            } else {
                teamNameLabel.text = content.teamName
            }
            matchesPlayedLabel.text = content.matchesPlayed
            matchesWonLabel.text = content.matchesWon
            matchesDrawnLabel.text = content.matchesDrawn
            matchesLostLabel.text = content.matchesLost
            goalsScoredConcededLabel.text = "\(content.goalsScored)-\(content.goalsConceded)"
            goalDifferenceLabel.text = content.goalDifference
            teamTotalPointsLabel.text = content.teamPoints
        }
    }
}
