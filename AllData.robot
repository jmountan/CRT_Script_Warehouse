*** Settings ***
Resource                      ../resources/common.robot
Library                       DataDriver    reader_class=TestDataApi    name=Leads.csv    #iterates through the Leads csv
Suite Setup                   Setup Browser
Suite Teardown                End suite
Test Template                 Entering A Lead With Data

*** Test Cases ***
Entering A Lead With Data with ${First Name} ${Last Name}    ${Phone}    ${Company}    ${Website}
    [Tags]                    AllData

*** Keywords ***
Entering A Lead With Data
    [Arguments]               ${First Name}    ${Last Name}    ${Phone}    ${Company}    ${Website}
    [tags]                    Lead
    Home
    LaunchApp                 Sales
    LaunchApp                 Sales

    ClickText                 Leads
    VerifyText                Recently Viewed             timeout=120s
    ClickText                 New
    VerifyText                Lead Information
    UseModal                  On                          # Only find fields from open modal dialog

    TypeText                  First Name                  ${First Name}
    TypeText                  Last Name                   ${Last Name}
    Picklist                  Lead Status                 Working
    TypeText                  Phone                       ${Phone}                    First Name
    TypeText                  Company                     ${Company}                  Last Name
    TypeText                  Website                     ${Website}

    ClickText                 Lead Source
    ClickText                 Advertisement
    ClickText                 Save                        partial_match=False
    UseModal                  Off
    Sleep                     1

    #Delete the lead to clean up data
    LaunchApp                 Sales
    ClickText                 Leads
    VerifyText                Recently Viewed             timeout=120s

    ClickText                 ${first Name}
    ClickText                 Delete
    ClickText                 Delete
    VerifyText                Recently Viewed
    VerifyNoText              ${First Name}
    VerifyNoText              ${Last Name}
