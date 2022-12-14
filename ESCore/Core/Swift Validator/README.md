# ESCore



# Validation 


![swift-validator-v2](https://user-images.githubusercontent.com/13080678/207071744-021e226b-bc1e-432f-8cfd-be5903f1d838.gif)



# How to add validation to your project?



## Core Concepts

- ``` UITextField ``` +  ``` [Rule] ``` + (and optional error  ``` UILabel ``` ) go into   ``` Validator  ```
- ``` UITextField ```  +  ``` ValidationError ``` come out of ``` Validator  ```
- ``` Validator ``` evaluates  ``` [Rule] ``` sequentially and stops evaluating when a ``` Rule ``` fails


## Usage



## Initialize the Validator by setting a delegate to a View Controller or other object.

```swift
// ViewController.swift
let validator = Validator()

```

## Register the fields that you want to validate

```swift
override func viewDidLoad() {
	super.viewDidLoad()

	// Validation Rules are evaluated from left to right.
	validator.registerField(fullNameTextField, rules: [RequiredRule(), FullNameRule()])
	
	// You can pass in error labels with your rules
	// You can pass in custom error messages to regex rules (such as ZipCodeRule and EmailRule)
	validator.registerField(emailTextField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule(message: "Invalid email")])
	
	// You can validate against other fields using ConfirmRule
	validator.registerField(emailConfirmTextField, errorLabel: emailConfirmErrorLabel, rules: [ConfirmationRule(confirmField: emailTextField)])
	
	// You can now pass in regex and length parameters through overloaded contructors
	validator.registerField(phoneNumberTextField, errorLabel: phoneNumberErrorLabel, rules: [RequiredRule(), MinLengthRule(length: 9)])
	validator.registerField(zipcodeTextField, errorLabel: zipcodeErrorLabel, rules: [RequiredRule(), ZipCodeRule(regex : "\\d{5}")])

	// You can unregister a text field if you no longer want to validate it
	validator.unregisterField(fullNameTextField)
	
	//You can add a custom message when you use this flag or keep the default showMessage
	validator.registerField(nameTextFiled, rules: [RequiredRule(message: "The name field is required", showMessage: true), MaxLengthRule(length: 30)])

}

```

## Validate Fields on button tap or however you would like to trigger it.

```swift
@IBAction func signupTapped(sender: AnyObject) {
	validator.validate(self)
}

```

## Implement the Validation Delegate in your View controller

```swift
// ValidationDelegate methods

func validationSuccessful() {
	// submit the form
}

func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
  // turn the fields to red
  for (field, error) in errors {
    if let field = field as? UITextField {
      field.layer.borderColor = UIColor.red.cgColor
      field.layer.borderWidth = 1.0
    }
    error.errorLabel?.text = error.errorMessage // works if you added labels
    error.errorLabel?.isHidden = false
  }
}

```

## Single Field Validation

### You may use single field validation in some cases. This could be useful in situations such as controlling responders:

```swift
// Don't forget to use UITextFieldDelegate
// and delegate yourTextField to self in viewDidLoad()
func textFieldShouldReturn(textField: UITextField) -> Bool {
    validator.validateField(textField){ error in
        if error == nil {
            // Field validation was successful
        } else {
            // Validation error occurred
        }
    }
    return true
}

```

# Custom Validation

### We will create a ``` SSNRule ```  class to show how to create your own Validation. A United States Social Security Number (or SSN) is a field that consists of XXX-XX-XXXX.

### Create a class that inherits from RegexRule

```swift

class SSNVRule: RegexRule {

    static let regex = "^\\d{3}-\\d{2}-\\d{4}$"
	
    convenience init(message : String = "Not a valid SSN"){
	self.init(regex: SSNVRule.regex, message : message)
    }
}

```


### Note 
```validationFailed``` is optinal 
