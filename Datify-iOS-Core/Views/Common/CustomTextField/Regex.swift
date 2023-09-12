//
//  Regex.swift
//  Datify-iOS-Core
//
//  Created by Ildar Khabibullin on 03.09.2023.
//

import Foundation

enum Regex: String {
  case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
  case name = "^[A-Za-z\\s]{1,20}$"
  case password = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
}
