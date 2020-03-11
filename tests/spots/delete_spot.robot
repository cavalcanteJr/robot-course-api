*** Settings ***				
Resource    ../../resources/services.robot

# Dado que eu tenho um spots cadastrados
# Quando eu faço a remoção pelo ID
# Então deve retornar o código de resposta 204

#Desafio da semana
#enviar para fernando@qaninja.io com assunto "Desafio Robot Turma 2"


*** Test Cases ***
Delete Unique Spot
    Set Token       lourival@delete.com
    #Create the spot to be delete
    &{my_spot}=     Create Dictionary       company=Marvel Unique Delete       techs=ruby      price=100       user=${token}
    ${spot_id}=     Insert Unique Spot      ${my_spot}
    #Call to method to delete a Spot
    ${response}=    Delete Spot By Id       ${spot_id}
    ${code}=        Convert To String      ${response.status_code}
    Log To Console      ${token}
    Log To Console      ${spot_id}
    Should Be Equal                         ${code}     204


    