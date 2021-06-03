*** Settings ***
Documentation   Третья домашняя работа по RF
Metadata        Преподаватель     Юрий Цай
Metadata        Автор             Егор Бердин

Test Timeout    3s
Resource        resource.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Test Cases ***
Check Day Second_task1
    [Documentation]     составляем 2 запроса (PostREST и БД)

    ${list_tax}                     Ord.get_tax_from_rest     alias=alias
    ...                                                      params=select=orderdate,tax,customerid(lastname,phone,state)&tax=gt.25&orderdate=eq.2004-06-11
    ...                                                      expected_status=200

    ${list_tax_and_orders_db}       Ord.get_tax_and_orders  tax=25  orderdate=2004-06-11

Check Day Second_task2
    [Documentation]     Вносим новые данные в таблицу и проверяем их

    Cat.add_new_data  category=100004  categoryname=Something


    ${list_new_data}     Cat.get_data_from_rest                 alias=alias
    ...                                                         params=category=gt.100000
    ...                                                         expected_status=200

    ${list_new_data_db}            Cat.get_category_and_categoryname  category=100000

    Col.Lists Should Be Equal   ${list_new_data}  ${list_new_data_db}

*** Keywords ***
Test Setup
    Req.Create session            alias   http://localhost:3000
    DB.Connect To Postgresql      hadb    authenticator   mysecretpassword    localhost  8432

Test Teardown
    Req.Delete All Sessions
    DB.Disconnect From Postgresql