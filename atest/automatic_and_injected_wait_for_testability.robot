*** Settings ***
Library         SeleniumLibrary
Library         ${CURDIR}/../src/SeleniumTestability     enable_implicit_wait=True
Library         DateTime
Library         Process
Test Template   Automatically Call Testability Ready

*** Variables ***
${URL}                  http://localhost:5000
${INJECT_FROM_RF}       1

*** Test Cases ***
Testability in Firefox  Firefox   20.0   30.0
Testability in Chrome   Chrome    20.0   30.0


*** Keywords ***
Automatically Call Testability Ready
  [Arguments]   ${BROWSER}    ${HIGHER_THAN}  ${LOWER_THAN}
  [Teardown]    Teardown Test Environment

  Setup Test Environment    ${BROWSER}
  Click All And Verify    ${HIGHER_THAN}  ${LOWER_THAN}

Click All And Verify
  [Arguments]   ${HIGHER_THAN}  ${LOWER_THAN}
  ${start}=   Get Time        epoch
  Click Element               id:fetch-button
  Log To Console              click!
  Click Element               id:shorttimeout-button
  Log To Console              click!
  Click Element               id:xhr-button
  Log To Console              click!
  Click Element               id:transition-button
  Log To Console              click!
  Click Element               id:animate-button
  Log To Console              Wait
  Wait For Testability Ready
  ${end}=   Get Time        epoch
  ${diff}=  Subtract Date From Date   ${end}  ${start}
  Should Be True              ${diff} >= ${HIGHER_THAN}
  Should Be True              ${diff} <= ${LOWER_THAN}


Start Flask App
  ${FLASK_HANDLE}=            Start Process   flask   run   shell=True    cwd=${EXEC_DIR}/assets
  Set Suite Variable        ${FH}   ${FLASK_HANDLE}

Stop Flask App
  Terminate Process           ${FH}   kill=True

Setup Test Environment
  [Arguments]   ${BROWSER}
  Start Flask App
  ${URL}=   Set Variable    ${URL}?inject=${INJECT_FROM_RF}
  Set Selenium Timeout        120 seconds
  Open Browser                ${URL}    browser=${BROWSER}
  Instrument Browser
  Wait For Document Ready

Teardown Test Environment
  Close Browser
  Stop Flask App