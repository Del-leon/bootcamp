*** Variables ***
@{ROW}      1  2  3  5  1  0  -1  10

*** Test Cases ***
Show Min and Max
    ${min}=  evaluate  min(map(int, ${ROW}))
    ${max}=  evaluate  max(map(int, ${ROW}))
    log  Минимальное значение: ${min}
    log  Максимальное значение: ${max}

Show only unique
    ${set}=  evaluate  set(${ROW})
    log  Уникальные значения: ${set}

Show Sum
    ${sum}=  evaluate  sum(map(int, ${ROW}))
    log  Сумма ряда = ${sum}