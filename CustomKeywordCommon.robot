*** Settings ***
Library                   QWeb
Library                   QForce
Library                   String


*** Variables ***
${username}               YOUR USERNAME HERE
${login_url}              https://YOURDOMAIN.my.salesforce.com          # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}               ${login_url}/lightning/page/home


*** Keywords ***
Start New Account
    [Arguments]        ${Account_Name}        ${Unique_id}

    #Create a unique name for the account
    ${unique_name}=               Catenate               ${Unique_id}    ${Account_Name}

    LaunchApp                     Sales
    ClickText                     Accounts
    ClickText                     New
    UseModal                      On
    Sleep                         2s
    Wait Until Keyword Succeeds   1 min   5 sec   TypeText   Account Name    ${unique_name} 

    [Return]                      ${unique_name}     

Setup Browser
    Set Library Search Order                          QWeb                   QForce
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    SetConfig             DefaultTimeout              20s                    #sometimes salesforce is slow


End suite
    Set Library Search Order                          QWeb                   QForce
    Close All Browsers


Login
    [Documentation]       Login to Salesforce instance
    Set Library Search Order                          QWeb                   QForce
    GoTo                  ${login_url}
    TypeText              Username                    ${username}             delay=1
    TypeText              Password                    ${password}
    ClickText             Log In


Home
    [Documentation]       Navigate to homepage, login if needed
    Set Library Search Order                          QWeb                   QForce
    GoTo                  ${home_url}
    ${login_status} =     IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If        ${login_status}             Login
    ClickText             Home
    VerifyTitle           Home | Salesforce

