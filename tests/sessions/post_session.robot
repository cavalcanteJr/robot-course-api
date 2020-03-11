*** Settings ***				
Resource        ../../resources/services.robot
*** Test Cases ***
New Session
    &{payload}=         Create Dictionary       email=lourival@google.com
    ${response}=        Post Session            ${payload}
    ${code}=            Convert To String       ${response.status_code}
    Should Be Equal     ${code}     200

Wrong Email
    &{payload}=         Create Dictionary       email=lourival&google.com
    ${response}=        Post Session            ${payload}
    ${code}=            Convert To String       ${response.status_code}
    Should Be Equal     ${code}                 409

Empty Email
    &{payload}=         Create Dictionary       email=${EMPTY}
    ${response}=        Post Session            ${payload}
    ${code}=            Convert To String       ${response.status_code}
    Should Be Equal     ${code}                 412
Without Data
    Create Session      spotapi     http://spotlab-api.herokuapp.com
    &{headers}=         Create Dictionary       Content-Type=application/json
    ${response}=        Post Request            spotapi     /sessions       headers=${headers}
    ${code}=            Convert To String      ${response.status_code}
    Should Be Equal     ${code}                 412