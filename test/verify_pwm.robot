*** Settings ***
Suite Setup     Setup
Suite Teardown  Teardown
Test Setup      Reset Emulation
Resource        ${RENODEKEYWORDS}

*** Variables ***
${RESC}         ${CURDIR}/tang_nano_4k.resc
${REPL}         ${CURDIR}/tang_nano_4k.repl
${BIN}          ${CURDIR}/../src/ports/tang_nano_4k/build/firmware.elf
${UART}         sysbus.uart0

*** Test Cases ***
Should Verify PWM Interface
    Execute Command         $repl = @${REPL}
    Execute Command         $bin = @${BIN}
    Execute Command         include @${RESC}
    Execute Command         sysbus.cpu VectorTableOffset 0x60000000
    Execute Command         sysbus.cpu SP `sysbus ReadDoubleWord 0x60000000`
    Execute Command         sysbus.cpu PC `sysbus ReadDoubleWord 0x60000004`
    Create Terminal Tester  ${UART}
    Start Emulation
    Wait For Line On Uart   MicroPython started on Tang Nano 4K

    Write Line To Uart      from machine import PWM, Pin; print("MOD_O" + "K")
    Wait For Line On Uart   MOD_OK

    Write Line To Uart      pwm = PWM(Pin(0)); print("PWM_INI" + "T")
    Wait For Line On Uart   PWM_INIT

    Write Line To Uart      print(pwm)
    Wait For Line On Uart   PWM(pin=0, freq=1000, duty=512)

    Write Line To Uart      pwm.freq(2000); print("FREQ_O" + "K")
    Wait For Line On Uart   FREQ_OK

    Write Line To Uart      pwm.duty(256); print("DUTY_O" + "K")
    Wait For Line On Uart   DUTY_OK

    Write Line To Uart      print(pwm)
    Wait For Line On Uart   PWM(pin=0, freq=2000, duty=256)

    Write Line To Uart      pwm.deinit(); print("DEINI" + "T")
    Wait For Line On Uart   DEINIT
