*** Settings ***
Resource          ../common/rf_keyword/OperatePlan.txt
Resource          ../common/rf_keyword/Common.txt
Resource          ../common/rf_keyword/SalePlanList_JX.txt
Library           DateTime

*** Test Cases ***
delPlan_T1
    [Documentation]    创建方案后删除
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #删除方案
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

delPlan_T2
    [Documentation]    创建方案且选点后删除
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    Comment    #获取所有可选项目idlist
    Comment    ${res}    GetItemsList    ${id}
    Comment    ${res2}    to json    ${res.content}
    Comment    ${list}    set variable    ${res2["data"]}
    Comment    ${idlist}    Evaluate    [int(i["id"])for i in ${list}]
    Comment    #加入全部项目
    Comment    ${res}    addItem    ${id}    ${idlist}
    Comment    LogAndLogToConsole    ${res}
    Comment    ${res2}    to json    ${res.content}
    Comment    Should Be Equal As Strings    ${res2["msg"]}    成功
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #删除方案
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

delPlan_F1
    [Documentation]    保留方案后删除（失败）
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #删除方案
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案不处于预定状态,不能进行此操作
    #清理数据-先转预订再删除
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

delPlan_F2
    [Documentation]    销售方案后删除（失败）
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #转销售
    ${res}    ToSale    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #删除方案
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案不处于预定状态,不能进行此操作
    #清理数据-先转预订再删除
    ${res}    SaleToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

state1-2_T1
    [Documentation]    预订->保留
    ...    最后清理数据
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #清理数据-先转预订再删除
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

state1-2-3_T2
    [Documentation]    预订->保留->销售
    ...    最后清理数据
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #转销售
    ${res}    ToSale    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #清理数据-先转预订再删除
    ${res}    SaleToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

exportPoint_T1
    [Documentation]    预定方案选点后，导出点位
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #点位导出
    ${res}    ExportPoint    ${id}
    ${res2}    to json    ${res.content}
    Should Contain    ${res2["data"]}    ${plan_name}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #清理数据
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

exportPoint_T2
    [Documentation]    保留方案，导出点位
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #点位导出
    ${res}    ExportPoint    ${id}
    ${res2}    to json    ${res.content}
    Should Contain    ${res2["data"]}    ${plan_name}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #清理数据
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

exportPoint_T3
    [Documentation]    销售方案，导出点位
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #转销售
    ${res}    ToSale    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #点位导出
    ${res}    ExportPoint    ${id}
    ${res2}    to json    ${res.content}
    Should Contain    ${res2["data"]}    ${plan_name}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #清理数据
    ${res}    SaleToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

exportPoint_T4
    [Documentation]    预定方案不选点，导出点位
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #点位导出
    ${res}    ExportPoint    ${id}
    ${res2}    to json    ${res.content}
    Should Contain    ${res2["data"]}    ${plan_name}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #清理数据
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

exportMap_T1
    [Documentation]    预定方案选点后，导出地图
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #地图导出
    ${res}    ExportMap    ${id}
    ${res2}    to json    ${res.content}
    Should Contain    ${res2["data"]["name"]}    ${plan_name}
    Should Be Equal As Strings    ${res2["msg"]}    导出成功
    #清理数据
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

exportMap_T2
    [Documentation]    保留方案，导出地图
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #地图导出
    ${res}    ExportMap    ${id}
    ${res2}    to json    ${res.content}
    Should Contain    ${res2["data"]["name"]}    ${plan_name}
    Should Be Equal As Strings    ${res2["msg"]}    导出成功
    #清理数据
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

exportMap_T3
    [Documentation]    销售方案，导出地图
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=${beginTime}    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #转销售
    ${res}    ToSale    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #地图导出
    ${res}    ExportMap    ${id}
    ${res2}    to json    ${res.content}
    Should Contain    ${res2["data"]["name"]}    ${plan_name}
    Should Be Equal As Strings    ${res2["msg"]}    导出成功
    #清理数据
    ${res}    SaleToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

changeDate_T1
    [Documentation]    保留状态-调整结束日
    #登录
    Login
    #方案初始化数据
    PlanInit
    #新建方案
    ${res}    AddPlan    name=${plan_name}    beginTime=2019-02-14    endTime=${endTime}    cityCompanies=${cityCompanies}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功
    #查询方案id
    ${res}    SearchPlan    name=${plan_name}    cityCompany=${cityCompany}
    LogAndLogToConsole    ${res}
    ${res2}    to json    ${res.content}
    should contain    ${res2["data"]["data"][0]["name"]}    ${plan_name}
    LogAndLogTOConsole    ${res2["data"]["data"][0]["id"]}
    ${id}    set variable    ${res2["data"]["data"][0]["id"]}
    #自动调度
    ${res}    AutoDispatch    ${id}
    ${res2}    to json    ${res.content}
    Should Match Regexp    ${res2["msg"]}    ^当前方案总设备数：([1-9]\\d*)台，新增加：([1-9]\\d*)台$
    #转保留
    ${res}    ReserveToRetain    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转保留操作成功
    #调整到今天
    ${date}    Get Current Date
    ${datetime}    Convert Date    ${date}    datetime
    ${a2}    Catenate    SEPARATOR=-    ${datetime.year}    ${datetime.month}    ${datetime.day}
    ${res}    AdjustEndDate    ${id}    ${a2}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    调整结束日成功
    #清理数据
    ${res}    ToReserve    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    方案转预定成功
    ${res}    DeletePlan    ${id}
    ${res2}    to json    ${res.content}
    Should Be Equal As Strings    ${res2["msg"]}    成功

test
    ${date}    Get Current Date
    log    ${date}
    ${datetime}    Convert Date    ${date}    datetime
    log    ${datetime}
    ${a1}    Catenate    ${datetime.year}    ${datetime.month}    ${datetime.day}
    Comment    ${d}    Evaluate    string(${a1}).replace(' ','-')
    ${a2}    Catenate    SEPARATOR=-    ${datetime.year}    ${datetime.month}    ${datetime.day}
    log    ${a2}
    ${date}    Get Current Date    UTC
    log    ${date}
    ${date}    Get Current Date    result_format=datetime
    log    ${date}
