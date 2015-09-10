//
//  SRFormValidator.swift
//  SRFormValidator
//
//  Created by Stephen Radford on 09/09/2015.
//  Copyright (c) 2015 Cocoon Development Ltd. All rights reserved.
//

public class SRFormValidator {
    
    /// The dictionary of rules used to validate
    var rules: [String:String]
    
    /// The class where the forms are stored
    var target: AnyObject
    
    /**
    Initialise a new instance with rules and target
    
    :param: rules The dictionary of rules used to validate
    :param: target The target class where the fields are stored
    
    :returns: Instance of `SRFormValidator`
    */
    init(rules: [String:String], target: AnyObject) {
        self.rules = rules
        self.target = target
    }
    
    /**
    Validate an dictionary of form fields against a set of rules.
    
    :param: rules The dictionary of rules used to validate
    :param: target The target class where the fields are stored
    
    :returns: Bool
    */
    public class func isValid(rules: [String:String], _ target: AnyObject) -> [String]? {
        let validator = SRFormValidator(rules: rules, target: target)
        return validator.validate()
    }
    
    /**
    Validate the rules
    
    :returns: An array of fields that have errored or nil
    */
    func validate() -> [String]? {
        
        var invalid: [String]? = []
        
        for (field, rule) in rules {
            
            var error = false
            let split = rule.componentsSeparatedByString("|")
            
            for r in split {
                switch r {
                case "email":
                    if !isValidEmailField(field) {
                        error = true
                    }
                case "required":
                    if !isValidRequiredField(field) {
                        error = true
                    }
                default:
                    let comps = r.componentsSeparatedByString(":")
                    if r.rangeOfString("min") != nil  {
                        if !isValidMinField(field, length: comps[1].toInt()!) {
                            error = true
                        }
                    } else {
                        if !isValidMaxField(field, length: comps[1].toInt()!) {
                            error = true
                        }
                    }
                }
            }
            
            if error == true{
                invalid?.append(field)
            }
            
        }
        
        return (invalid?.count > 0) ? invalid : nil
    }
    
    // MARK: - Validators
    
    /**
    Is the current field valid?
    
    :param: keyPath The keyPath to the field on our target
    
    :returns: Bool
    */
    func isValidRequiredField(keyPath: String) -> Bool {
        let f = field(keyPath)
        return f != nil && f != ""
    }
    
    /**
    Checks if the email is valid with a regular expression
    
    :param: keyPath The keyPath to the field
    
    :returns: Bool
    */
    func isValidEmailField(keyPath: String) -> Bool {
        let f = field(keyPath)
        let pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        if let string = f {
            return checkRegexPattern(pattern, field: string) || string == ""
        }
        
        return true
    }
    
    /**
    Checks if the field is a valid alphanumeric value with a regular expression
    
    :param: keyPath The keyPath to the field
    
    :returns: Bool
    */
    func isValidAlphaNumericField(keyPath: String) -> Bool {
        let f = field(keyPath)
        let pattern = "^[a-zA-Z0-9]*$"
        
        if let string = f {
            return checkRegexPattern(pattern, field: string) || string == ""
        }
        
        return true
    }
    
    /**
    Checks if the field has a character length >= to the rule. Or if the field can be parsed as an integer it'll check if that value is >= that set in the rule.
    
    :param: keyPath The keyPath to the field
    :param: length  The length set in the rule
    
    :returns: Bool
    */
    func isValidMinField(keyPath: String, length: Int) -> Bool {
        let f = field(keyPath)
        
        if let string = f {
            if let int = string.toInt() {
                return int >= length
            } else {
                count(string) >= length
            }
        }
        
        return true
    }
    
    /**
    Checks if the field has a character length <= to the rule. Or if the field can be parsed as an integer it'll check if that value is <= that set in the rule.
    
    :param: keyPath The keyPath to the field
    :param: length  The length set in the rule
    
    :returns: Bool
    */
    func isValidMaxField(keyPath: String, length: Int) -> Bool {
        let f = field(keyPath)
        
        if let string = f {
            if let int = string.toInt() {
                return int <= length
            } else {
                count(string) <= length
            }
        }
        
        return true
    }
    
    // MARK: - Helpers
    
    /**
    Checks the field against a regex pattern
    
    :param: regex The regext pattern to check agains
    :param: field The field we'll be checking
    
    :returns: Bool
    */
    func checkRegexPattern(pattern: String, field: String) -> Bool {
        let regex = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: nil)!
        return regex.firstMatchInString(field, options: nil, range: NSMakeRange(0, count(field))) != nil
    }
    
    /**
    Convert our keyPath into an actual value
    
    :param: keyPath The path to our field
    
    :returns: The value grabbed from the field
    */
    func field(keyPath: String) -> String? {
        return target.valueForKeyPath(keyPath) as? String
    }
    
}
