# NOTE: readme.txt contains important information you need to take into account
# before running this suite.

*** Settings ***
Documentation                   Example / template for REST API automation
Library                         RequestsLibrary             # import library "RequestsLibrary" for REST API testing
Library                         DateTime                    # imported for date conversion in second test
Library                         String
Resource                        ../resources/common.resource


*** Variables ***
${ISBN_10}                      0201558025
${EXPECTED_TITLE}               Concrete mathematics
${EXPECTED_YEAR}                1994
${EXPECTED_AUTHOR}              Ronald L. Graham
${ProjectID}                    7640                        #Your Project ID Here
${SuiteID}                      23879                       #Your Suite ID Here
${RunID}
${CRTPAT}                       #Should be secret, define at suite level


*** Test Cases ***

Verify Book details
    [Documentation]             Verify Book details using Open Library REST API (https://openlibrary.org/dev/docs/api/books)
    [tags]                      GET

    # Create a session using Create Session
    ${var}=                     Create Session              openbookslib                http://openlibrary.org/api

    # Populate query and parameters
    ${query}=                   Set Variable                bibkeys=ISBN:${ISBN_10}
    &{params}=                  Create Dictionary           format=json                 jscmd=data

    # Call a specific endpoint with our query using Get Request. Get response to a variable
    ${resp} =                   Get On Session              openbookslib                /books?${query}             params=&{params}
    # Check and log status code from the response
    Should Be Equal As Strings                              ${resp.status_code}         200
    Log                         ${resp.text}

    # parse returned data to variables using helper keyword from resources
    ${book_info}=               Get Field Value From Json                               ${resp.text}                ISBN:${ISBN_10}
    Log                         ${book_info}
    ${title}=                   Get From Dictionary         ${book_info}                title
    ${published}=               Get From Dictionary         ${book_info}                publish_date
    ${authors}=                 Get From Dictionary         ${book_info}                authors
    Log                         ${authors}
    ${main_author_name}=        Get From Dictionary         ${authors[0]}               name

    # Verify returned information against known values
    Should Be Equal As Strings                              ${title}                    ${EXPECTED_TITLE}
    Should Be Equal As Strings                              ${published}                ${EXPECTED_YEAR}
    Should Be Equal As Strings                              ${main_author_name}         ${EXPECTED_AUTHOR}


Verify Unix Timestamp
    [Documentation]             POST example - get date based on Unix timestamp (https://unixtime.co.za/)
    [tags]                      POST
    # Create a session using Create Session
    ${var}=                     Create Session              unixtimestamp               https://showcase.api.linx.twenty57.net/UnixTime

    # Populate body to be sent when calling API
    # Here we send an unix timestamp and timezone value
    &{body}=                    Create Dictionary           UnixTimeStamp=1987654321    Timezone=+3

    # Call a specific endpoint with body using Post On Session. Get response to a variable
    ${resp} =                   Post On Session             unixtimestamp               /fromunixtimestamp          json=&{body}

    # Check and log status code from the response
    Should Be Equal As Strings                              ${resp.status_code}         200
    Log                         ${resp.text}

    # parse returned data to variables using helper keyword from resources
    ${resp_date}=               Get Field Value From Json                               ${resp.text}                Datetime

    # Convert received date to suitable format and verify that it is as expected
    ${date} =                   Convert Date                ${resp_date}                exclude_millis=yes          result_format=%d.%m.%Y %H:%M
    Should Be Equal             ${date}                     26.12.2032 09:12

Run Another CRT Test and Get The RunID
    [Documentation]             POST & GET Example - Run one of our test suites from this suite. Then get the run ID to check the status
    [tags]                      POST                        GET                         CRT

    #Create a dictionary of Headers for the session
    &{headers}=                 Create Dictionary           X-AUTHORIZATION=${CRTPAT}

    #Create JSON body with execution parameters
    &{InnerDictionary}=         Create Dictionary           key=-i                      value=New Account
    &{body}=                    Create Dictionary           inputParameters=${InnerDictionary}                      #{"inputParameters":[{"key":"-i","value":"Salesforce Login"}]}

    #Create a session using Create Session
    ${var}=                     Create Session              CRTAPI                      https://api.robotic.copado.com/pace                     headers=${headers}

    #Make the Callout to the run suite endpoint
    ${url}=                     Format String               /v4/projects/{}/jobs/{}/builds                          ${ProjectID}                ${SuiteID}
    ${resp}=                    Post On Session             CRTAPI                      ${url}                      json=&{body}

    #Check and log status code from the response
    Should Be Equal As Strings                              ${resp.status_code}         201
    Log To Console              ${resp.text}

    #Convert the json to python (RF) dictionary and parse for the RunID
    &{AllData}=                 Evaluate                    json.loads("""${resp.text}""")                          json
    &{RunData}=                 Create Dictionary           &{AllData}[data]
    ${RunID}=                   Set Variable                ${RunData}[id]

    #Now we want to make another Callout to get the run results
    #We will wait just long enough for our test to run and then get the run results
    ${url}=                     Format String               /v4/projects/{}/jobs/{}/builds/{}                       ${ProjectID}                ${SuiteID}    ${RunId}
    WHILE                       True                        limit=480 seconds
        ${resp}=                GET On Session              CRTAPI                      ${url}
        Log To Console          ${resp.text}
        ${status_Bool}=         Run Keyword And Return Status                           Should Contain              ${resp.text}                "status":"executing"
        Log To Console          ${status_Bool}
        
        IF                      "${status_Bool}" == "False"
            BREAK
        END
        
        Sleep                   10s
    END
    Should Contain              ${resp.text}                "status":"pass"
