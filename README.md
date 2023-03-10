# kanbanize-automation-qa-task
Task from Kanbanize

[TEST SETUP]


Robot Framework - To install Robot Framework, you can use pip, a package installer for Python. Open a terminal and type the following command:

pip install robotframework

Collections - Collections library is a part of Python's standard library. Therefore, it doesn't require any separate installation.

JSONLibrary - To install JSONLibrary, you can use pip. Open a terminal and type the following command:

pip install robotframework-jsonlibrary

RequestsLibrary - To install RequestsLibrary, you can use pip. Open a terminal and type the following command:

    pip install robotframework-requests

After installing all these libraries, you can import them in your Robot Framework test suite by adding the following lines to your test suite:

javascript

*** Settings ***
Library    Collections
Library    JSONLibrary
Library    RequestsLibrary


[BEFORE YOU RUN]

Make sure you have to update the kanbanize_resource.robot file with:
${BASE_URL} The url of the sandbox
${API_KEY} The API Key for the account


The code should take into account every new run and create a new variable.

