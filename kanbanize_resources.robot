*** Settings ***
Library  SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
*** Variables ***
${BASE_URL}    https://sava.kanbanize.com/api/v2
${API_KEY}     w6kJpWc7laEvyjk9RMbNnhlcT43md746bIVqkeIS
${end_point}    /cards
${custom_id}    'custom_id':'RobotTest'

