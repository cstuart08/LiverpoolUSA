//
//  SearchableRecord.swift
//  LiverpoolUSA
//
//  Created by Apps on 9/19/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation

protocol SearchableRecord: class {
    func matches(searchTerm: String) -> Bool
}
