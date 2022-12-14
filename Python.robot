*** Settings ***
Resource                      ../Resources/common.robot
Library                      ../Resources/pyLib.py
Suite Setup                   Setup Browser
Suite Teardown                End suite


*** Test Cases ***

Perform Demo With Python
    [Tags]                    Python Exercise
    
    Print Message             Hello from Python!
    Print Message             Let's explore our ability to leverage Python within CRT
    Print Message             We have a native package for CRT called robot.api.
    Print Message             That's what we are using right now to print to the console!!
    Print Message             What about other Python libraries?
    Print Message             No problem! We simply install those libraries in our pace.before
    Print Message             For this example we will use Numpy. We have a basic set of functions defined

    Print Message             Let's start with a base number of 100
    ${temp}=                  Squareroot    100
    log                       ${temp}    level=warn
    ${temp}=                  Double     100
    log                       ${temp}    level=warn
    ${temp}=                  Sum        100    50
    log                       ${temp}    level=warn
    ${temp}=                  Halve      100
    log                       ${temp}    level=warn
    ${temp}=                  Sum        100    -200
    log                       ${temp}    level=warn
