*** Settings ***
Resource            ../Resources/common.robot
Library             String
Suite Setup         Setup Browser
Suite Teardown      End suite

*** Test Cases ***
Entering A Lead
    [tags]          Lead                        FileImport
    ${iterator}=    Set Variable                0
    FOR             ${FirstName}                IN                          @{FirstNames}
        Appstate    Home
        LaunchApp                               Sales

        ClickText                               Leads
        VerifyText                              Recently Viewed             timeout=120s
        ClickText                               New
        VerifyText                              Lead Information
        UseModal    On                          # Only find fields from open modal dialog

        TypeText    First Name                  ${FirstNames}[${iterator}]
        TypeText    Last Name                   ${LastNames}[${iterator}]
        Picklist    Lead Status                 Working
        TypeText    Phone                       ${Companies}[${iterator}]             First Name
        TypeText    Company                     ${PhoneNums}[${iterator}]             Last Name
        TypeText    Website                     ${Websites}[${iterator}]

        ClickText                               Lead Source
        ClickText                               Advertisement
        ClickText                               Save                        partial_match=False
        UseModal    Off
        Sleep       1

        #Delete the lead afterward
        LaunchApp                               Sales
        ClickText                               Leads
        VerifyText                              Recently Viewed             timeout=120s

        ${fullName}=                            Catenate                    ${FirstNames}[${iterator}]    ${LastNames}[${iterator}]

        ClickText                               ${fullName}
        ClickText                               Delete
        ClickText                               Delete
        VerifyText                              Recently Viewed
    END
