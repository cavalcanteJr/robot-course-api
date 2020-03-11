*** Settings ***				
Resource    ../../resources/services.robot

# Dado que eu tenho um spots cadastrados
# Quando eu faço uma consulta Get pelo ID
# Então deve retornar o spots na consulta

*** Test Cases ***
Get Unique Spot
    Set Token       lourival@jr.com
    &{my_spot}=     Create Dictionary       company=Marvel Unique Lou       techs=ruby      price=100       user=${token}
    ${spot_id}=     Insert Unique Spot      ${my_spot}
    ${response}=    Get Spot By Id          ${spot_id}
    ${code}=        Convert To String      ${response.status_code}
    Should Be Equal                         ${code}     200
    Dictionary Should Contain Value         ${response.json()}      ${my_spot.company}

Spot Not Found
    ${spot_id}=         Get Mongo Id
    ${response}=        Get Spot By Id         ${spot_id}
    ${code}=            Convert To String      ${response.status_code}
    Should Be Equal                             ${code}     404

Filter spots
    Set Token           lourival@jrjr.com
    Hard Reset          ${token}
    Save Spot List      filter.json

    ${response}=        Get Spot By Filter      lourival
    ${code}=            Convert To String       ${response.status_code}
    Should Be Equal                             ${code}     200
    Should Not Be Empty                         ${response.json()}
    Dictionary Should Contain Item              ${response.json()[0]}      company     Acme X

    ${total}=           Get Length              ${response.json()}
    ${total}=           Convert To String       ${total}
    Should Be Equal                             ${total}        2