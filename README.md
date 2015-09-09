# SRFormValidator

A quick and dirty form validator in Swift. Inspired by [Laravel](http://laravel.com/docs/5.1/validation)

## Usage

First, import `SRFormValidator` where you need it.

`import SRFormValidator`

Next, write your rules as a Dictionary. The key should be a keyPath to your field's values and the rules should be your dictionary's value. As it fetches the value using key path you can use variables or dictionaries freely. Below is an example using several rules and two dictionaries.

    let rules = [
        "personalDetails.emailAddress": "required|email",
        "personalDetails.firstName": "required",
        "personalDetails.lastName": "required",
        "personalDetails.phone": "required|min:10|max:30",
        "shippingDetails.address": "required",
        "shippingDetails.city": "required",
        "shippingDetails.state": "required",
        "shippingDetails.zipCode": "required|alhanumeric|max:10"
    ]

You can validate your rules with the `isValid` class method. It'll return the fields that are erroring in an array or nil if the fields are valid.

    let errors = SRFormValidator.isValid(rules, self)
    if(errors != nil) {
        println(valid)
    }

## Rules

There are currently 5 rules that can be used to validate your fields. Multiple rules can be used in tandem when separated with a `|`. Some rules use a `:` to include arguments.

Rule | Effect
=================
`required` | Checks if the field is `nil` or a blank string.
`email`    | Checks if the field is a valid email address using regex.
`alphanumeric` | Checks if the field only contains a-z, A-Z, and 0-9 using regex.
`min:10` | Checks if the the field has a character length minimum to the value set or if an integer whether the value is >= to the rule.
`max:10` | Checks if the the field has a character length maximum to the value set or if an integer whether the value is <= to the rule.

## Notes

* Can only currently validate strings. It'll probably break if you try anything else but you can give it a go. Min and Max will try to parse ints.
* Messages aren't return, only that the field has failed.
