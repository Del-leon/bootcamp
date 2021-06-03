*** Settings ***
Library         RequestsLibrary         WITH NAME   Req
Library         PostgreSQLDB            WITH NAME   DB
Library         JsonValidator
Library         Collections             WITH NAME   Col
Library         orders.Orders           WITH NAME   Ord
Library         categories.Categories   WITH NAME   Cat