*** Settings ***
Resource                        ../Resources/common.robot
Library                         DateTime
Suite Setup                     Setup Browser
Suite Teardown                  End suite


*** Test Cases ***
Create Account Growmore
    [Tags]                      Account                     Leveraging Variables
    Appstate                    Home
    LaunchApp                   Sales
    ClickText                   Accounts
    ClickText                   New
    UseModal                    On

    #Create a unique name for the account
    ${currentTimestamp}=        Get Current Date
    ${genericName}=             Convert To String           Growmore
    ${uniqueAccountName}=       Catenate                    ${currentTimestamp}     ${genericName}

    Sleep                       1 sec
    Wait Until Keyword Succeeds                             1 min                   5 sec             TypeText        Account Name            ${uniqueAccountName}
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
    VerifyText                  ${uniqueAccountName}
    VerifyText                  ${uniqueAccountName}        anchor=Account Name     timeout=60s
    VerifyField                 Phone                       (123) 456-7890
    VerifyField                 Employees                   100
    VerifyField                 Website                     www.growmore.org
    VerifyField                 Industry                    Banking
