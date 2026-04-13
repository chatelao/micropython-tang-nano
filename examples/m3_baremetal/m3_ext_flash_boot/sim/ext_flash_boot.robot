*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/ext_flash_boot.resc

*** Test Cases ***
Verify External Flash Boot
    [Documentation]    Verifies the external flash boot example by checking LED toggling.
    Execute Command         include @${RESC}

    # Configure GPIO0 (LED) to log its state changes
    Execute Command         logLevel 2 gpio0

    # Create log tester with 10 seconds timeout
    Create Log Tester       10
    Start Emulation

    # Check for LED toggling (GPIO 0)
    Wait For Log Entry      Setting pin 0 to True
    Wait For Log Entry      Setting pin 0 to False
    Wait For Log Entry      Setting pin 0 to True
    Wait For Log Entry      Setting pin 0 to False
