*** Settings ***
Resource                     ../Resources/common.custom.robot
Library                      String
Library                      DateTime
Suite Setup                  Setup Browser
Suite Teardown               End suite


*** Test Cases ***
Create Account Growmore
    [Tags]                   Account                     Custom Keyword
    Appstate                 Home
    ${uniqueAccountName}=    Start New Account           Growmore               Get Current Date

    PickList                 Type                        Competitor
    ClickText                Website
    TypeText                 Website                     www.growmore.org
    ClickText                Phone
    TypeText                 Phone                       1234567890
    PickList                 Industry                    Banking
    ClickText                Employees
    TypeText                 Employees                   100
    ClickText                Save                        partial_match=false
    UseModal                 Off

    ClickText                Details                     anchor=Related
    VerifyText               ${uniqueAccountName}
    VerifyText               ${uniqueAccountName}        anchor=Account Name
    VerifyField              Phone                       (123) 456-7890
    VerifyField              Employees                   100
    VerifyField              Website                     www.growmore.org
    VerifyField              Industry                    Banking
