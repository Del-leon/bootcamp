*** Settings ***
Library           String

*** Test Cases ***
Celsius and Fahrenheit Test
    @{row}  create list  0;32  350;662  -32;-25.6  100;212
    FOR    ${item}    IN    @{row}
        ${input}=    Split String    ${item}    ;
        ${Celsius}  convert to number    ${input}[0]
        ${Fahrenheit}  convert to number    ${input}[1]
        ${True_Fahrenheit}  Calculation  ${Celsius}

        Should Be Equal  ${Fahrenheit}  ${True_Fahrenheit}  Что-то не так
    END

*** Keywords ***
Calculation
    [Arguments]  ${Cels}
    ${True_Fahr}=  evaluate  ${Cels}*9/5+32
    [Return]  ${True_Fahr}
