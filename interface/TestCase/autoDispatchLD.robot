*** Settings ***
Documentation     自动调度
Suite Setup
Test Setup
Test Teardown
Force Tags        LD
Default Tags      LD    # 李丹测试集
Library           RequestsLibrary
Library           json
Library           DateTime
Resource          ../common/rf_keyword/Common.txt
Resource          ../common/rf_keyword/SaleKeywordsLD.txt
Resource          ../common/rf_keyword/SalePlanList_JX.txt
Library           ../common/py_keyword/deal_premises.py
Library           string
Library           String
Library           random

*** Test Cases ***
arrangementPlan_Y
    [Documentation]    整理方案，有项目
    [Setup]    MyInit
    AddPlanInit
    AutoDispatch    ${planId}
    ${re}    ArrangementPlan    ${planId}
    Should Be Equal As Strings    '${re["status"]}'    'True'
    Should Be Equal As Strings    '${re["code"]}'    '000'
    Should Be Equal As Strings    ${re["msg"]}    整理成功
    RemovePlan    ${planId}

arrangementPlan_N
    [Documentation]    整理方案，没有项目
    [Setup]    MyInit
    AddPlanInit
    ${re}    ArrangementPlan    ${planId}
    Should Be Equal As Strings    '${re["status"]}'    'False'
    Should Be Equal As Strings    '${re["code"]}'    '001'
    Should Be Equal As Strings    ${re["msg"]}    没有添加项目
    RemovePlan    ${planId}

dispatchCancel_Y_ALL
    [Documentation]    调度清零，有项目，清零全部
    [Setup]    MyInit
    AddPlanInit
    AutoDispatch    ${planId}
    ${re}    DispatchReset    ${planId}    ${premisesId2}
    Should Be Equal As Strings    '${re["status"]}'    'True'
    Should Be Equal As Strings    '${re["code"]}'    '000'
    Should Be Equal As Strings    ${re["msg"]}    操作成功
    ${result}    SelectProject    ${planId}    #返回已调度楼盘的信息
    ${num}    deal_premises.Select Project    ${result["data"]}    \    #判断清零个数是否正确
    Should Be Equal As Integers    ${num}    0
    RemovePlan    ${planId}

dispatchCancel_N
    [Documentation]    调度清零，没有项目
    [Setup]    MyInit
    AddPlanInit
    ${re}    DispatchReset    ${planId}
    Should Be Equal As Strings    '${re["status"]}'    'False'
    Should Be Equal As Strings    '${re["code"]}'    '001'
    Should Be Equal As Strings    ${re["msg"]}    请选择项目
    RemovePlan    ${planId}

dispatchEquipment_N
    [Documentation]    没有选择设备进行调度设备，
    [Setup]    MyInit
    AddPlanInit
    ${re}    DispatchEquipment    ${planId}
    Should Be Equal As Strings    '${re["status"]}'    'False'
    Should Be Equal As Strings    '${re["code"]}'    '001'
    Should Be Equal As Strings    ${re["msg"]}    请选择设备
    RemovePlan    ${planId}

dispatchEquipmentAndCancel
    [Documentation]    调度设备和取消调度用例
    [Setup]    MyInit
    AddPlanInit
    GetCanDispatchEquipment    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    log    ${canDispatchEquipment1}
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${re}    DispatchEquipment    ${planId}    ["${canDispatchEquipment2[0]}"]
    log    ${re}
    Should Contain    ${re["msg"]}    新增加1台
    Should Be Equal    '${re["status"]}'    'True'
    ${re1}    DispatchCancel    ${planId}    ["${canDispatchEquipment1[0]}"]
    Should Contain    ${re1["msg"]}    操作成功
    Should Be Equal    '${re1["status"]}'    'True'
    RemovePlan    ${planId}

dispatchEquipmentAll
    [Documentation]    调度所有的设备
    [Setup]    MyInit
    AddPlanInit
    GetCanDispatchEquipment    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码
    log    ${canDispatchEquipment}
    log    ${canDispatchEquipment["code"]}
    ${re}    DispatchEquipment    ${planId}    ${canDispatchEquipment["code"]}
    log    ${re}
    Should Contain    ${re["msg"]}    新增加
    Should Be Equal    '${re["status"]}'    'True'
    RemovePlan    ${planId}

dispatchCancel_不传code
    [Documentation]    取消调度：不传入设备编码
    [Setup]    MyInit
    AddPlanInit
    ${re1}    DispatchCancel    ${planId}    []
    Should Contain    ${re1["msg"]}    请选择方案或者设备
    Should Be Equal    '${re1["status"]}'    'False'
    RemovePlan    ${planId}

dispatchCancel_不存在code
    [Documentation]    取消调度：错误的设备编码
    [Setup]    MyInit
    AddPlanInit
    ${re1}    DispatchCancel    ${planId}    ["87987978978789"]
    Should Contain    ${re1["msg"]}    方案没有已选成功点位
    Should Be Equal    '${re1["status"]}'    'False'
    RemovePlan    ${planId}

dispatchEquipment_不存在code
    [Documentation]    取消调度：错误的设备编码
    [Setup]    MyInit
    AddPlanInit
    GetCanDispatchEquipment    ${planId}
    ${re1}    DispatchEquipment    ${planId}    ["87987978978789"]
    Should Contain    ${re1["msg"]}    当前方案总设备数0台，新增加0台
    Should Be Equal    '${re1["status"]}'    'True'
    RemovePlan    ${planId}

dispatchEquipmentl_不传code
    [Documentation]    取消调度：不传入设备编码
    [Setup]    MyInit
    AddPlanInit
    GetCanDispatchEquipment    ${planId}
    ${re1}    DispatchEquipment    ${planId}    []
    Should Contain    ${re1["msg"]}    请选择设备
    Should Be Equal    '${re1["status"]}'    'False'
    RemovePlan    ${planId}

点位调度_T1联动全部设备
    [Documentation]    点位自动调度——T1投放方式，设备状态：全部设备，屏幕类型：联动
    [Setup]    MyInit
    AddPlanInit
    AutoDispatch1    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    Should Be Equal    ${canDispatchEquipment2}    ${dispatchSuc}
    RemovePlan    ${planId}

点位调度_T2
    [Documentation]    点位自动调度——T2投放方式，设备状态：全部设备，屏幕类型：联动
    [Setup]    MyInit
    AddPlanInit    deliveryMode=002
    AutoDispatch1    ${planId}
    log    ${premisesAllCodeDict}
    ${allSelect}    count_premises1    ${premisesAllCodeDict}    #已加入楼盘的列表
    log    ${allSelect}
    ${select}    count_premises1    ${selectDict}    #已调度的楼盘列表
    log    ${select}
    ${canDispatch}    count_premises1    ${premisesCodeDict}    #可以调度的楼盘
    log    ${canDispatch}
    ${count}    compare deliverymode    ${allSelect}    ${select}    ${canDispatch}    t2
    log    ${count}
    should be equal as integers    ${count}    0
    RemovePlan    ${planId}

点位调度_T3
    [Documentation]    点位自动调度——T3投放方式，设备状态：全部设备，屏幕类型：联动
    [Setup]    MyInit
    AddPlanInit    deliveryMode=003
    AutoDispatch1    ${planId}
    log    ${premisesAllCodeDict}
    ${allSelect}    count_premises1    ${premisesAllCodeDict}    #已加入楼盘的列表
    log    ${allSelect}
    ${select}    count_premises1    ${selectDict}    #已调度的楼盘列表
    log    ${select}
    ${canDispatch}    count_premises1    ${premisesCodeDict}    #可以调度的楼盘
    log    ${canDispatch}
    ${count}    compare deliverymode    ${allSelect}    ${select}    ${canDispatch}    t3
    log    ${count}
    should be equal as integers    ${count}    0
    RemovePlan    ${planId}

点位调度_未联网设备
    [Documentation]    点位自动调度——T1投放方式，设备状态：未联网，屏幕类型：联动
    [Setup]    MyInit
    AddPlanInit    pointStatus=2
    AutoDispatch1    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    Should Be Equal    ${canDispatchEquipment2}    ${dispatchSuc}
    RemovePlan    ${planId}

点位调度_已联网设备
    [Documentation]    点位自动调度——T1投放方式，设备状态：已联网，屏幕类型：联动
    [Setup]    MyInit
    AddPlanInit    pointStatus=1
    AutoDispatch1    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    Should Be Equal    ${canDispatchEquipment2}    ${dispatchSuc}
    RemovePlan    ${planId}

点位调度_上屏
    [Documentation]    点位自动调度——屏幕类型：上屏
    [Setup]    MyInit
    AddPlanInit    type=001
    AutoDispatch1    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    Should Be Equal    ${canDispatchEquipment2}    ${dispatchSuc}
    RemovePlan    ${planId}

点位调度_下屏
    [Documentation]    点位自动调度——屏幕类型：下屏
    [Setup]    MyInit
    AddPlanInit    type=002
    AutoDispatch1    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    Should Be Equal    ${canDispatchEquipment2}    ${dispatchSuc}
    RemovePlan    ${planId}

点位调度_合同数T1
    [Documentation]    点位自动调度——调剂数为0，合同数大于调度数
    [Setup]    MyInit
    AddPlanInit    compactNum=1000000
    AutoDispatch1    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    Should Be Equal    ${canDispatchEquipment2}    ${dispatchSuc}
    RemovePlan    ${planId}

点位调度_合同数T2
    [Documentation]    点位自动调度——调剂数为0，合同数小于调度数
    [Setup]    MyInit
    AddPlanInit    compactNum=1
    AutoDispatch1    ${planId}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    length should be    ${dispatchSuc}    1
    RemovePlan    ${planId}
点位调度_调剂数T1
    [Documentation]    点位自动调度——合同数为0，调剂数小于调度数
    [Setup]    MyInit
    AddPlanInit    regulateNum=1
    AutoDispatch1    ${planId}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    length should be    ${dispatchSuc}    1
    RemovePlan    ${planId}

点位调度_调剂数T2
    [Documentation]    点位自动调度——合同数为0，调剂数大于调度数
    [Setup]    MyInit
    AddPlanInit    regulateNum=1000000
    AutoDispatch1    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    Should Be Equal    ${canDispatchEquipment2}    ${dispatchSuc}
    RemovePlan    ${planId}

点位调度_合同数和调剂数T1
    [Documentation]    点位自动调度——合同数为+调剂数小于调度数
    [Setup]    MyInit
    AddPlanInit    regulateNum=1    compactNum=1
    AutoDispatch1    ${planId}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    length should be    ${dispatchSuc}    2
    RemovePlan    ${planId}

点位调度_合同数和调剂数T2
    [Documentation]    点位自动调度——合同数调剂数大于调度数
    [Setup]    MyInit
    AddPlanInit    regulateNum=100000    compactNum=10000
    AutoDispatch1    ${planId}
    ${canDispatchEquipment}    Get Machine Code    ${premisesCode}    #能调度的设备编码字典格式
    ${canDispatchEquipment1}    Set Variable    ${canDispatchEquipment["code"]}    #能调度的设备编码列表格式
    ${canDispatchEquipment2}    Evaluate    list(${canDispatchEquipment1})
    log    ${canDispatchEquipment2}
    ${dispatchSuc}    GetDispatchSucCode    ${selectDict}    #获取调度成功的设备编码
    log    ${dispatchSuc}
    Should Be Equal    ${canDispatchEquipment2}    ${dispatchSuc}
    RemovePlan    ${planId}
方案排斥_搜索T1
    [Documentation]    方案排斥搜索接口-默认数据搜索
    [Setup]    MyInit
    AddPlanInit
    ${result}    PlanReject_search    ${planId}
    should be equal as strings    ${result["msg"]}    成功
    RemovePlan    ${planId}
方案排斥_搜索T2
    [Documentation]    方案排斥搜索接口-方案名搜索
    [Setup]    MyInit
    AddPlanInit
    ${result}    PlanReject_search    planId=${planId}    planName=测试
    should be equal as strings    ${result["msg"]}    成功
    RemovePlan    ${planId}
方案排斥_搜索T3
    [Documentation]    方案排斥搜索接口-屏幕类型-上屏搜索
    [Setup]    MyInit
    AddPlanInit
    ${result}    PlanReject_search    planId=${planId}    planType=001
    should be equal as strings    ${result["msg"]}    成功
    RemovePlan    ${planId}
方案排斥_搜索T4
    [Documentation]    方案排斥搜索接口-屏幕类型-下屏搜索
    [Setup]    MyInit
    AddPlanInit
    ${result}    PlanReject_search    planId=${planId}    planType=002
    should be equal as strings    ${result["msg"]}    成功
    RemovePlan    ${planId}
方案排斥_搜索T5
    [Documentation]    方案排斥搜索接口-屏幕类型-联动搜索
    [Setup]    MyInit
    AddPlanInit
    ${result}    PlanReject_search    planId=${planId}    planType=003
    should be equal as strings    ${result["msg"]}    成功
    RemovePlan    ${planId}
方案排斥_设备排斥
    [Documentation]    方案排斥接口-设备排斥
    [Setup]    MyInit
    ${planId1}    AddPlanInit    deliveryMode=002    #新建方案1
    AutoDispatch1    ${planId1}
    ${select1}    GetDispatchSucCode    ${selectDict}    #方案1已调度的楼盘列表
    log    ${select1}
    ${length1}=    get length    ${select1}    #未排斥前调度点位，得到调度成功的设备数
    ${name1}    Evaluate    "newplan"+str(random.randint(1,9999))+str(random.randint(1,9999))    random    #新方案名称
    ${planId2}    AddPlanInit    name=${name1}    #新建方案2
    AutoDispatch2    planId=${planId2}    premisesId=${premisesId1}
    ${select2}    GetDispatchSucCode    ${selectDict1}    #方案2已调度的楼盘列表
    ${length2}=    get length    ${select2}    #未排斥前调度点位，得到调度成功的设备数
    DispatchReset    ${planId2}    ${premisesId1}#调度清零
    PlanReject    ${planId2}    ${planId1}    #方案排斥
    ${re}    AutoDispatch2    planId=${planId2}    premisesId=${premisesId1}    #排斥后再调度
    log    ${re["msg"]}
    ${status}    run keyword and return status    ${length2}!=0
    run keyword if    '${status}'=='True'    run keyword    should be equal    ${re["msg"]}    无符合条件的1点位
    ...    Else    run keyword    should be equal    ${select1}    当前没有调度成功的点位，请重试

demo2222
    ${res}    Evaluate    'i'*3
    Run Keyword If    Length Should Be    ${res}    3    log    1
