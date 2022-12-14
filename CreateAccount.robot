*** Settings ***
Resource                        ../Resources/common.robot
Suite Setup                     Setup Browser
Suite Teardown                  End suite


*** Test Cases ***
Create Account Growmore
    [Tags]                      Account                     New Account
    Appstate                    Home
    LaunchApp                   Sales
    ClickText                   Accounts
    ClickText                   New
    UseModal                    On
    Sleep                       1 sec

    Wait Until Keyword Succeeds                             1 min                   5 sec       TypeText        Account Name    Growmore
    PickList                    Type                        Competitor
    ClickText                   Website
    TypeText                    Website                     www.growmore.org
    ClickText                   Phone
    TypeText                    Phone                       1234567890
    PickList                    Industry                    Banking
    ClickText                   Employees
    TypeText                    Employees                   100
    ClickText                   Save                        partial_match=false
    UseModal                    Off

    ClickText                   Details                     anchor=Related
    VerifyText                  Growmore
    VerifyText                  Growmore                    anchor=Account Name
    VerifyField                 Phone                       (123) 456-7890
    VerifyField                 Employees                   100
    VerifyField                 Website                     www.growmore.org
    VerifyField                 Industry                    Banking
