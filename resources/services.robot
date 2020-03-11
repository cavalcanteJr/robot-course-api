*** Settings ***				
Library     Collections			
Library     RequestsLibrary
Library     OperatingSystem
Library     ./libs/mongo.py

***Variables***
${base_uri}     http://spotlab-api.herokuapp.com

***Keywords***
Post Session
    [Arguments]         ${payload}
    Create Session      spotapi                 ${base_uri}
    &{headers}=         Create Dictionary       Content-Type=application/json
    ${response}=        Post Request            spotapi     /sessions    data=${payload}    headers=${headers}
    [Return]            ${response}

Set Token
    [Arguments]         ${email}
    &{payload}          Create Dictionary       email=${email}
    &{headers}=         Create Dictionary       Content-Type=application/json
    ${response}=        Post Session            ${payload}
    ${token}            Convert To String       ${response.json()['_id']}
    Set Suite Variable  ${token}

Get Image
    [Arguments]         ${thumb}
    ${file_data}=       Get Binary File         ${CURDIR}/img/${thumb}
    &{file}=            Create Dictionary       thumbnail=${file_data}
    [return]            ${file}

Save spot
    [Arguments]         ${payload}              ${thumb}
    Create Session      spotapi                 ${base_uri}
    &{headers}=         Create Dictionary       user_id=${token}
    ${response}=        Post Request            spotapi     /spots      files=${thumb}      data=${payload}    headers=${headers}
    [return]            ${response}

Save Spot List
    [Arguments]     ${json_file}

    ${my_spots}=     Get File         resources/fixtures/${json_file}
    ${json}=         Evaluate         json.loads('''${my_spots}''')    json
    ${data}=         Set Variable     ${json['data']}

    :FOR    ${item}     ${spot_id}=     Insert Unique Spot      ${my_spot}      @{data}
    \       ${thumb}=           Get From Dictionary     ${item}         thumb
    \       ${payload}=         Get From Dictionary     ${item}         payload
    \       ${thumb}            Get Image       ${thumb}
    \       Save Spot           ${payload}      ${thumb}

Get Spot By Id
    [Arguments]         ${spot_id}
    Create Session      spotapi                 ${base_uri}
    &{headers}=         Create Dictionary       user_id=${token}
    ${response}=        Get Request            spotapi     /spots/${spot_id}     headers=${headers}
    [return]            ${response}

Get Spot By Filter
    [Arguments]         ${tech}
    Create Session      spotapi                 ${base_uri}
    ${response}=        Get Request            spotapi     /spots?tech=${tech}
    [return]            ${response}

Delete Spot By Id
    [Arguments]         ${spot_id}
    Create Session      spotapi                 ${base_uri}
    &{headers}=         Create Dictionary       user_id=${token}
    ${response}=        Delete Request            spotapi     /spots/${spot_id}     headers=${headers}
    [return]            ${response}



### /dashboard
Get My Spots
    Create Session  spotapi     ${base_uri}

    &{headers}=     Create Dictionary   user_id=${token}
    ${response}=    Get Request     spotapi     /dashboard  headers=${headers}

    [return]        ${response}