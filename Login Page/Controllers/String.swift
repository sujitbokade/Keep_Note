//
//  Validations.swift
//  Login Page
//
//  Created by Macbook on 14/12/22.
//

import Foundation

extension String {
    func validateEmailId() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return applyPredicate(regexStr: emailRegex)
    }
    
    func validatePassword(min: Int = 8, max: Int = 8) -> Bool {
        var passRegex = ""
        if min >= max {
            passRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min),}$"
        } else {
            passRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(min),\(max)}$"
           }
        return applyPredicate(regexStr: passRegex)
    }
        func applyPredicate(regexStr: String) -> Bool {
            let trimmedString = self.trimmingCharacters(in: .whitespaces)
            let validateOtherString = NSPredicate(format: "SELF MATCHES %@",regexStr)
            let isValidateOtherString = validateOtherString.evaluate(with: trimmedString)
            return isValidateOtherString
        }
    }
