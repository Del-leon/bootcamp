*** Settings ***
Test Setup      Test Setup
Test Teardown   Test Teardown
Library         RequestsLibrary     WITH NAME   Req
Library         PostgreSQLDB        WITH NAME   DB
Library         JsonValidator
Library         Collections         WITH NAME   Col

*** Test Cases ***
Check Day Second

    ${params}    create dictionary    actor_start=ZERO\%  price=25  actor_end=\%E
    ${SQL}       set variable         SELECT products.actor, products.price, products.category, categories.categoryname FROM bootcamp.products left join bootcamp.categories on products.category = categories.category WHERE products.price > %(price)s and products.actor like %(actor_start)s and products.actor like %(actor_end)s
    @{result_first_task}    DB.Execute Sql String Mapped   ${SQL}   &{params}



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
