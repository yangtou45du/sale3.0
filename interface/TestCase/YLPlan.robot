*** Settings ***
Suite Setup
Resource          ../common/rf_keyword/PointPosition.txt
Resource          ../common/rf_keyword/SaleKeywordsLD.txt
Library           Collections
Library           ../common/py_keyword/def_json.py
Library           OperatingSystem
Library           String
Resource          ../common/rf_keyword/Common.txt
Resource          ../common/rf_keyword/YLPlan.txt

*** Test Cases ***
demo
    Login
    PlanInit
    YLPlanListSearch
    ExportYLExcel
    EditYLPlan
