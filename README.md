# kanbanize-automation-qa-task
Task from Kanbanize

[TEST SETUP]


Robot Framework - To install Robot Framework, you can use pip, a package installer for Python. Open a terminal and type the following command:

pip install robotframework

Collections - Collections library is a part of Python's standard library. Therefore, it doesn't require any separate installation.

JSONLibrary and RequestsLibrary - To install Open a terminal and type the following command:

    pip install robotframework-requests
    
    pip install robotframework-jsonlibrary
    
After installing all these libraries, you should be able to run the files. 


[BEFORE YOU RUN]

Make sure you have to update the kanbanize_resource.robot file with:
${BASE_URL} The url of the sandbox
${API_KEY} The API Key for the account


The code should take into account every new run and create a new variable.

[RESULTS]
You can view the results by opening the log.html and report.html files attached to the repo.
