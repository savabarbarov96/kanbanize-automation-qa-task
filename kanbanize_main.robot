*** Settings ***
Library         RequestsLibrary
Library         Collections
Library         JSONLibrary 
Resource        kanbanize_resources.robot

*** Variables ***
${end_point}    /cards
${custom_id}    'custom_id':'RobotTest'
${result_card_id}
${headers}  accept=application/json Content-Type=application/json apikey=${API_KEY} 
*** Test Cases ***
TC01: Create a new card (POST)
    [Documentation]    Create a card with requirments: title: title, position != 0, color != #34a97b, priority = 250
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'track':1, ${custom_id}, 'lane_id':1, 'column_id':2, 'title':'title', 'position':1, 'color':'#FF0000', 'priority':250})
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    verify=True
    ${response}=    POST On Session    mysession    ${end_point}    data=${body}    headers=${headers}

    #VALIDATIONS
    ${test_id}=    Convert String To Json    ${response.content}
    ${real_test}=    Get Value From Json    ${test_id}    $.data.[:].card_id
    Set Suite Variable     ${result_card_id}    ${real_test}
    Log To Console    Expecting status code 200...
    Verify the status code is correct    ${response.status_code}    200

TC02: Validate card properties(GET)
    [Documentation]    Verify if: If the card is created. Position of the card, Priority and Color
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'card_id':${result_card_id}, ${custom_id}})
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    
    ${response}=    GET On Session    mysession    ${end_point}    data=${body}    headers=${headers}
    [Tags]    Validations
    Verify Card Position Priority and Colour    ${response.content}
    Log To Console    Expecting status code 200...
    Verify the status code is correct    ${response.status_code}    200

TC03: Move card to a different column (PATCH)
    [Documentation]    Create a card with requirments: title: title, position != 0, color != #34a97b, priority = 250
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'card_id':'${result_card_id}', ${custom_id}, "column_id":3 })
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    verify=True
    Sleep    3
    ${response}=    PATCH On Session    mysession    ${end_point}/${result_card_id}[0]   data=${body}    headers=${headers}
    [Tags]    Validations
    Log To Console    Expecting status code 200...
    Verify the status code is correct    ${response.status_code}    200

TC04: Validate card position (GET)
    [Documentation]    Validate if the card is in the correct column (3)
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'card_id':'${result_card_id}', ${custom_id}})
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    
    ${response}=    GET On Session    mysession    ${end_point}    data=${body}    headers=${headers}
    [Tags]    Validations
    Verify Card Column Id    ${response.content}
    Log To Console    Expecting status code 200...
    Verify the status code is correct    ${response.status_code}    200

TC05: Move card to invalid column (PATCH)
    [Documentation]    Move card to invalid column and validate the error
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'track':1, 'custom_id':'Test', 'lane_id':1, 'column_id':6, 'card_id':'${result_card_id}'})
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    verify=True
    ${response}=    Run Keyword And Ignore Error    PATCH On Session    mysession    ${end_point}    data=${body}    headers=${headers}
    [Tags]    Validations
    Log To Console    ${response}
    Log To Console    Expecting status code 405...
    Verify the status code is correct    ${response}    405

TC06: Create subtask to card (PATCH)
    [Documentation]    Create a subtask for the card
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'card_id':'${result_card_id}', 'subtasks_to_add': [{'description': 'test', 'owner_user_id': 2, 'is_finished': 0, 'position': 0,}]}, separators=(',', ':'), sort_keys=True)
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    verify=True
    ${response}=    PATCH On Session    mysession    ${end_point}/${result_card_id}[0]    data=${body}    headers=${headers}
    [Tags]    Validations
    Log To Console    Expecting status code 200...
    Verify the status code is correct    ${response.status_code}    200

TC07: Newly created subtask to be converted to "Child"
    Skip

TC08: Delete the card (DELETE)
    [Documentation]    Delete the created card
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'card_id':'${result_card_id}',})
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    
    ${response}=    DELETE On Session    mysession    ${end_point}/${result_card_id}[0]    data=${body}    headers=${headers}
    [Tags]    Validations
    Sleep    1    #Give some time for the request to be received by the API
    Log To Console    Expecting status code 204...
    Verify the status code is correct    ${response.status_code}    204

TC09: Verify the card has been deleted (GET)
    [Documentation]    Verify the card ${result_card_id}[0] was deleted
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'card_id':'${result_card_id}', 'custom_id':'Test'})
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    
    ${response}=    Run Keyword And Ignore Error     GET On Session   mysession    ${end_point}/${result_card_id}[0]    data=${body}    headers=${headers}
    Log To Console    Card with ID:${result_card_id}[0] has been deleted
    [Tags]    Validations
    Log To Console    Expecting status code 404...
    Verify the status code is correct    ${response}    404

TC10: Create a request to invalid card id to change its size (PATCH)
    [Documentation]    Create a subtask for the card
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({'card_id':'999', 'size':'500'})
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    verify=True
    ${response}=    Run Keyword and Ignore Error    PATCH On Session    mysession    ${end_point}/999   data=${body}    headers=${headers}    
    [Tags]    Validations
    Log To Console    Expecting status code 404...
    Verify the status code is correct    ${response}    404 

TC11: Create a card with deadline before 1970-01-01 (POST)
    [Documentation]    Card with deadline > 1970-01-01
    Create Session    mysession    ${BASE_URL}
    ${body}=    Evaluate    json.dumps({"deadline": "1969-01-01T12:57:39.757Z", "column_id": 2})
    ${headers}=    Create Dictionary    accept=application/json    Content-Type=application/json    apikey=${API_KEY}    verify=True
    ${response}=    Run Keyword and Ignore Error    POST On Session    mysession    ${end_point}    data=${body}    headers=${headers}
    [Tags]    Validations
    Log To Console    Expecting status code 400...
    Verify the status code is correct    ${response}    400

*** Keywords ***
Get card_id variable from initial POST request
    [Arguments]    ${response.content}
    ${test_id}=    Convert String To Json    ${response.content}
    ${real_test}=    Get Value From Json    ${test_id}    $.data.[:].card_id
    RETURN    ${real_test}
Verify Card Position Priority and Colour
    [Arguments]    ${response.content}
    ${string_response}=    Convert To String    ${response.content}
    Should Contain    ${string_response}    RobotTest
    Should Contain    ${string_response}    "position":1
    Should Contain    ${string_response}    "color":"ff0000"

Verify Card Column Id
    [Arguments]    ${response.content}
    ${string_response}=    Convert To String    ${response.content}
    Should Contain    ${string_response}    "column_id":3

Verify the status code is correct
    [Arguments]    ${response.status_code}    ${status_code}
    ${verify_status_code}=    Convert Json To String    ${response.status_code}
    Should Contain    ${verify_status_code}    ${status_code}