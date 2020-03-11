*** Settings ***				
Resource        ../../resources/services.robot

Suite Setup     Set Token   lourival@jr.com
*** Test Cases ***
Create a new spot
    ${thumb}            Get Image  acme.jpg
    &{payload}=         Create Dictionary       company=Google      techs=Java      price=50         
    Remove Company      ${payload['company']}
    ${response}=        Save spot               ${payload}      ${thumb}
    ${code}=            Convert To String       ${response.status_code}
    Should Be Equal     ${code}                 200

Empty Company
    ${thumb}            Get Image  acme.jpg
    &{payload}=         Create Dictionary       company=${EMPTY}    techs=Java      price=50
    ${response}=        Save spot               ${payload}      ${thumb}
    ${code}=            Convert To String       ${response.status_code}
    Should Be Equal     ${code}                 412
    ${business_code}=   Convert To Integer      1001
    Dictionary Should Contain Value             ${response.json()}  ${business_code}
    Dictionary Should Contain Value             ${response.json()}  Company is required

Empty Techs
    ${thumb}            Get Image  acme.jpg
    &{payload}=         Create Dictionary       company=Acme    techs=${EMPTY}      price=50
    ${response}=        Save spot               ${payload}      ${thumb}
    ${code}=            Convert To String       ${response.status_code}
    Should Be Equal     ${code}                 412
    ${business_code}=   Convert To Integer      1002
    Dictionary Should Contain Value             ${response.json()}  ${business_code}
    Dictionary Should Contain Value             ${response.json()}  Technologies is required

Empty Thumb
    &{payload}=         Create Dictionary       company=Acme        techs=${EMPTY}      price=50
    ${response}=        Save spot               ${payload}      ${EMPTY}
    ${code}=            Convert To String       ${response.status_code}
    Dictionary Should Contain Value             ${response.json()}  Incorrect Spot data :(