*** Settings ***
Test Setup      Test Setup
Test Teardown   Test Teardown
Library         RequestsLibrary     WITH NAME   Req
Library         PostgreSQLDB        WITH NAME   DB
Library         JsonValidator
Library         Collections         WITH NAME   Col

*** Test Cases ***
Check Day Second_task1
    ${resp_task_1}      Req.GET On Session     alias    /orders?      params=select=orderdate,tax,customerid(lastname,phone,state)&tax=gt.25&orderdate=eq.2004-06-11
    Log          ${resp_task_1.json()}

    ${params}    create dictionary    tax=25  orderdate=2004-06-11
    ${SQL}       set variable         SELECT orders.orderdate, orders.tax, customers.lastname, customers.phone, customers.state FROM bootcamp.orders left join bootcamp.customers on orders.customerid = customers.customerid WHERE orders.tax > %(tax)s and orders.orderdate = %(orderdate)s
    @{result_first_task}    DB.Execute Sql String Mapped   ${SQL}   &{params}

Check Day Second_task2

    ${new_data}   create dictionary    category=${100004}  categoryname=Something
    ${new_data2}  create dictionary    category=${100005}  categoryname=Thingsome

    ${put_res}   Req.Post On Session  alias=alias  url=/categories  data=${new_data}
    ${put_res2}  Req.Post On Session  alias=alias  url=/categories  data=${new_data2}

    ${resp}      Req.GET On Session     alias    /categories?      params=category=gt.100000
    ${category}         get elements   ${resp.json()}    $..category
    ${categoryname}     get elements   ${resp.json()}    $..categoryname

    ${params_task_2}    create dictionary    category=100000
    ${SQL_task_2}       set variable         SELECT * FROM bootcamp.categories WHERE category > %(category)s
    @{result_task_2}    DB.Execute Sql String Mapped   ${SQL_task_2}    &{params_task_2}


    ${category_from_db}        create list
    ${categoryname_from_db}    create list

    FOR   ${i}  IN  @{result_task_2}
        Col.Append To List   ${category_from_db}            ${i}[category]
        Col.Append To List   ${categoryname_from_db}        ${i}[categoryname]
    END

    Col.Lists Should Be Equal   ${category}                ${category_from_db}
    Col.Lists Should Be Equal   ${categoryname}            ${categoryname_from_db}

*** Keywords ***
Test Setup
    Req.Create session            alias   http://localhost:3000
    DB.Connect To Postgresql      hadb    authenticator   mysecretpassword    localhost  8432

Test Teardown
    Req.Delete All Sessions
    DB.Disconnect From Postgresql
