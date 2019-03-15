#coding=utf-8
__author__ = 'lidan'
import json
import  traceback
import re
import random
import math
class deal_premises():
    ROBOT_LIBRARY_SCOPE = 'TEST CASE'
    ROBOT_LIBRARY_VERSION = '0.1'
    def select_project(self,list,list1=[]):
       '''
       :param list: 传入1001015返回的data数据，筛选调度数为0的楼盘
       :param list1: 楼盘id列表,id为None时b表示清零所有楼盘，判断所有counts是否为0的楼盘，不为0表示判断该楼盘id的counts为0，其他楼盘不为0
       :return:
       '''

       var = 0
       if len(list)!=0:#判断列表是否为空，不为空表示清零部分楼盘的点位
           list3 = []  # 传入id的楼盘详细信息
           if len(list1)!= 0:#判断是否传入id，没传默认id是全部
               for i in list1:
                   for j in list:
                       if str(j['id'])==str(i):
                           list3.append(j)
                           list.remove(j)#s删除传入id的楼盘详细信息
               for i in list3:#判断传入id的楼盘counts是否为0，不为零则改变var
                   if i["counts"]!=0:
                       var=var+1
               for i in list:#判断没传入id的楼盘counts是否为0，为零则改变var
                   if i["counts"]==0:
                       var=var+1
               return var
           else:#表示清零全部，判断是否有楼盘counts为0，如果不为零，更改var值
               for i in list:#遍历list，
                   if i['counts']!=0:
                       var = var+1
               return var
       else:
           return "没有获取到已调度项目"

    def get_machine_code(self,list):#获取code
        """

        :param list: 传入GetCanDispatchEquipment 中的${premisesCode}能调度的楼盘
        :return:code 列表
        """
        premiseMachineCodeDict={}
        premiseMachineCodeList=[]#楼盘设备编码列表
        if len(list)!=0:
            for premiseMachine in list:
                for premise in premiseMachine:
                    premiseMachineCodeList.append(premise["code"].encode("utf-8").replace("'",'"'))
            premiseMachineCodeDict["code"]=(json.dumps(premiseMachineCodeList))

            return (premiseMachineCodeDict)
        else:
            return 0
    def get_dispatch_suc_code(self,dict):
        """

        :param list:传入autoDispatch1中的 ${selectDict}
        :return:已调度成功的设备编码
        """
        list = []  # 将传入的参数转为列表
        for k in dict:
            list.append(dict[k])
        try:
            codeList=[]#已调度成功的设备编码
            if len(list)!=0:
                for i in list:
                    for j in i:
                        codeList.append(j["code"].encode("utf-8"))

            '''
            for i in list:
                if i.keys()[0]=="selected":
                    if i["selected"]!=[]:
                        for j in i["selected"]:
                            codeList.append(j["code"].encode("utf-8"))
                            '''

        except Exception,e:
            traceback.print_exc()
            print(traceback.print_exc())
        return codeList




    def list_change_string(self,list):
        for i in list:
            if isinstance(i,int):
                list[list.index(i)]=str(i)
        return ",".join(list)
    def list_string_change_int(self,list):
        for i in list:
            if isinstance(i,str)or isinstance(i,unicode):
                list[list.index(i)]=int(i)
        return list

    def get_select_and_unselect_code(self,data):
        #获取已调度的楼盘的已调度和未调度的设备
        selectData=data['selected']
        unSelectData=data['unselected']
        selectCodeList=[]
        unSelectCodeList=[]
        if selectData !=[]:
            for i in selectData:
                selectCodeList.append(i['code'])
        else:
            selectCodeList=selectData
        if unSelectData !=[]:
            for i in unSelectData:
                unSelectCodeList.append(i['code'])
        else:
            unSelectCodeList=unSelectData
        return (selectCodeList,unSelectCodeList)
    def new_get_premises_info(self,premises,num=5):#提取楼盘相关信息
        """

        :param premises: 为项目选择里（1001014接口）楼盘列表
        :param num: 提取楼盘的数量，默认5
        :return:
        """
        premisesList = []#单元数和设备数都不为0的列表
        for premise in premises:
            if premise['units'] != 0 and premise['machines'] != 0:
                premisesList.append(premise)
        if len(premisesList)<=num:
            return (premisesList)
        else:
            premiseList1=random.sample(premisesList, num)
            return (premiseList1)
    def get_premises_id(self,premiseList):
        premiseIdList=[]
        if len(premiseList)!=0:
            for i in premiseList:
                premiseIdList.append(i["id"])
            return premiseIdList
        else:
            return "没有项目加入"
    def count_premises1(self,premisesAllCodeDict1):#统计楼盘的单元数
        """

        :param premisesAllCodeDict: 楼盘详情
        :return: 统计楼盘的字典，格式{项目id：{楼栋1：{单元1：[code1,code2],单元2:[....]}，楼栋2:{单元1：[],..}}}
        """
        premisesAllCodeDict=json.loads(json.dumps(premisesAllCodeDict1))
        dict={}#统计楼盘单元
        for key in premisesAllCodeDict.keys():#1185770
            building={}#楼盘楼栋列表
            if len(premisesAllCodeDict[key])!=0:
                for i in premisesAllCodeDict[key]:#a["1185770"]
                    if i["building"] in building.keys():#如果楼栋在build
                        if i["unit"] in building[i["building"]].keys():#循环{"2单元": ["53254234566"], "1单元": ["sh-b-testm1"]}
                            building[i["building"]][i["unit"]].append(i['code'])
                        else:#存在楼栋，不存在单元
                            building[i["building"]][i["unit"]]=[i['code']]
                    else:#不存在楼栋
                        unit_dict = {}  # 单元数字典
                        code = []  # 设备列表
                        code.append(i['code'])
                        unit_dict[i['unit']] = code
                        building[i["building"]] = unit_dict
            dict[key]=building
        return (json.dumps(dict, ensure_ascii=False))

    def compare_deliverymode(self,allSelect1,select1,canDispatch1,mode):
        """
        :param allSelect:所有的楼盘
        :param select:调度后的楼盘
        param canDispatch:可以调度的楼盘
        :param mode:投放方式t2或者t3
        :return: 返回比较后的结果，0表示比较成功，大于0表示比较失败
        """
        allSelect=json.loads(allSelect1)
        select=json.loads(select1)
        canDispatch=json.loads(canDispatch1)
        count = 0
        try:
            for i in allSelect:  # 遍历所有的楼盘，i为楼盘id
                print("i=",i)
                dict = select[i]  # 已调度成功的楼盘编码
                allDict = allSelect[i]  # 该楼盘下所有的楼盘编码
                for j in allDict:  # 遍历i楼盘下已调度成功的楼盘，j为楼栋
                    print("j=", j)
                    for k in allDict[j]:  # 遍历i楼盘下j栋下的单元，k为单元数
                        print("k=", k)
                        #list = dict[j][k]  # i楼盘下j栋k单元下的已调度设备编码列表
                        #allList = allDict[j][k]  # i楼盘下j栋K单元下所有已调度的设备编码列表
                        #canDispatch = canDispatch[j][k]  # 该楼盘下可以调度的设备
                        if mode.upper()=="T2":
                            print("dict.keys=", dict.keys())
                            if j in  dict.keys():#如果楼栋在已调度和可以调度里
                                print("dict[j].keys=", dict[j].keys())
                                if k in dict[j].keys():#如果单元在已调度的楼栋里
                                    print("len(dict[j][k])=", len(dict[j][k]))
                                    if len(dict[j][k]) == 1:  # 如果每个楼盘下的每个单元的设备编码只有1个且设备编码在可以调度里，则判断正确，否则失败
                                        print("len(canDispatch[i][j][k])=", len(canDispatch[i][j][k]))
                                        if len(canDispatch[i][j][k])==1:#如果可以调度的设备只有一个，则判断已调度的和可调度的设备相等则判断正确，否则失败
                                            if dict[j][k]==canDispatch[i][j][k]:
                                                continue
                                            else:
                                                count = count + 1
                                        elif len(canDispatch[i][j][k])>=2:#如果可调度的设备不止一个，则已调度的在可以调度的设备里则判断正确，否则失败
                                            if set(canDispatch[i][j][k])>set(dict[j][k]):
                                                continue
                                            else:
                                                count = count + 1
                                        else:#如果可调度的为0，则失败
                                            count = count + 1
                                    else:
                                        count = count + 1
                                else:#如果单元不在已调度里
                                    if k in canDispatch[i][j].keys():#如果单元在可以调度里，但是不在已调度里，则判断失败，否则成功
                                        count = count + 1
                                    else:
                                        continue
                            else:#如果楼栋不在已调度里
                                if j in canDispatch[i].keys():#如果楼栋不在已调度里，但是在可以调度里面，则失败，否则成功
                                    count = count + 1
                                else:
                                    continue
                        elif mode.upper()=="T3":#如果投放方式为T3
                            if j in  dict.keys():#如果楼栋在已调度和可以调度里
                                if k in dict[j].keys():#如果单元在已调度的楼栋里
                                    if len(dict[j][k]) == 1:  # 如果每个楼盘下的每个单元的设备编码只有1个且可以调度的设备编码只有一个或者2个，则判断正确，否则失败
                                        if len(canDispatch[i][j][k])==1:
                                            if dict[j][k]==canDispatch[i][j][k]:
                                                continue
                                            else:
                                                count = count + 1
                                        elif len(canDispatch[i][j][k])==2:
                                            if set(canDispatch[i][j][k]) > set(dict[j][k]):
                                                continue
                                            else:
                                                count = count + 1
                                    elif len(dict[j][k])>=2:#如果已调度的设备不止一个，则已调度的数是可以调度的设备数的一半（奇数向上取整）则判断正确，
                                        if len(dict[j][k])==int(math.ceil(float(len(allDict[j][k]))/len(dict[j][k]))):
                                            if len(dict[j][k])==len(canDispatch[i][j][k]):
                                                continue
                                            else:
                                                if set(canDispatch[i][j][k]) > set(dict[j][k]):
                                                    continue
                                                else:
                                                    count = count + 1
                                        elif len(dict[j][k])<int(math.ceil(float(len(allDict[j][k]))/len(dict[j][k]))):#如果没有奇数，但是跟已调度数一致则也正确，否则失败
                                            if dict[j][k]==canDispatch[i][j][k]:
                                                continue
                                            else:
                                                count = count + 1
                                        else:
                                            count = count + 1
                                    else:
                                        count = count + 1
                                else:#如果单元不在已调度里
                                    if k in canDispatch[i][j].keys():#如果单元在可以调度里，但是不在已调度里，则判断失败，否则成功
                                        count = count + 1
                                    else:
                                        continue
                            else:#如果楼栋不在已调度里
                                if j in canDispatch[i].keys():#如果楼栋不在已调度里，但是在可以调度里面，则失败，否则成功
                                    count = count + 1
                                else:
                                    continue
                        else:
                            count=count+1
        except Exception, e:
            traceback.print_exc()
            print(traceback.print_exc())
        return count



if __name__=="__main__":
    f=deal_premises()
    building={"1栋": [{"2单元": ["53254234566"], "1单元": ["sh-b-testm1"], "3单元": ["7656746747"]}]}
    allSelect=	{"42731": {"8栋": {"2单元": ["KMB-D08-075"], "1单元": ["KMB-D08-074"], "4单元": ["KMB-D08-077"], "3单元": ["KMB-D08-076"], "5单元": ["KMB-D08-078"]}, "9栋": {"2单元": ["KMB-D08-080"], "1单元": ["KMB-D08-079"]}, "6栋": {"2单元": ["KMB-D08-069"], "1单元": ["KMB-D08-068"]}, "10栋": {"2单元": ["KMB-D08-082"], "1单元": ["KMB-D08-081"]}, "12栋": {"2单元": ["KMB-D08-086"], "1单元": ["KMB-D08-085"]}, "7栋": {"2单元": ["KMB-D08-071"], "1单元": ["KMB-D08-070"], "4单元": ["KMB-D08-073"], "3单元": ["KMB-D08-072"]}, "11栋": {"2单元": ["KMB-D08-084"], "1单元": ["KMB-D08-083"]}, "3栋": {"2单元": ["KMB-D08-061", "KMB-D08-060"], "1单元": ["KMB-D08-059", "KMB-D08-058"]}, "4栋": {"2单元": ["KMB-D08-065", "KMB-D08-064"], "1单元": ["KMB-D08-063", "KMB-D08-062"]}, "5栋": {"2单元": ["KMB-D08-067"], "1单元": ["KMB-D08-066"]}, "1栋": {"2单元": ["KMB-D08-051", "KMB-D08-050"], "1单元": ["KMB-D08-049", "KMB-D08-048"]}, "2栋": {"2单元": ["KMB-D08-055", "KMB-D08-054"], "1单元": ["KMB-D08-052", "KMB-D08-053"], "3单元": ["KMB-D08-056", "KMB-D08-057"]}}, "42890": {"8栋": {"1单元": ["KMB-C06-042", "KMB-C06-041", "KMB-C06-043"]}, "9栋": {"1单元": ["KMB-C06-044", "KMB-C06-046", "KMB-C06-045"]}, "12栋": {"1单元": ["KMB-C06-053", "KMB-C06-055", "KMB-C06-054"]}, "10栋": {"1单元": ["KMB-C06-048", "KMB-C06-047", "KMB-C06-049"]}, "13栋": {"1单元": ["KMB-C06-057", "KMB-C06-056", "KMB-C06-058"]}, "6栋": {"1单元": ["KMB-C06-035", "KMB-C06-037", "KMB-C06-036"]}, "7栋": {"1单元": ["KMB-C06-039", "KMB-C06-038", "KMB-C06-040"]}, "11栋": {"1单元": ["KMB-C06-051", "KMB-C06-050", "KMB-C06-052"]}, "3栋": {"1单元": ["KMB-C06-029", "KMB-C06-031", "KMB-C06-030"]}, "4栋": {"1单元": ["KMB-C06-033", "KMB-C06-032", "KMB-C06-034"]}, "1栋": {"1单元": ["KMB-C06-024", "KMB-C06-023", "KMB-C06-025"]}, "2栋": {"1单元": ["KMB-C06-026", "KMB-C06-028", "KMB-C06-027"]}}, "42571": {"3栋": {"1单元": ["KMB-E03-004", "KMB-E03-003"]}, "1栋": {"1单元": ["KMB-E02-099", "KMB-E02-098"]}, "4栋": {"1单元": ["KMB-E03-005", "KMB-E03-006"]}, "5栋": {"1单元": ["KMB-E03-008", "KMB-E03-007"]}, "2栋": {"1单元": ["KMB-E03-001", "KMB-E03-002"]}}, "42543": {"32栋": {"1单元": ["KMB-D05-035", "KMB-D05-036"]}, "35栋": {"1单元": ["KMB-D05-042", "KMB-D05-041"]}, "29栋": {"1单元": ["KMB-D05-034", "KMB-D05-033"]}, "33栋": {"1单元": ["KMB-D05-037", "KMB-D05-038"]}, "34栋": {"1单元": ["KMB-D05-039", "KMB-D05-040"]}}, "42493": {"51栋": {"1单元": ["KMB-B04-002", "KMB-B04-003"]}}}
    select={"42731": {"8栋": {"2单元": ["KMB-D08-075"], "1单元": ["KMB-D08-074"], "4单元": ["KMB-D08-077"], "3单元": ["KMB-D08-076"], "5单元": ["KMB-D08-078"]}, "9栋": {"2单元": ["KMB-D08-080"], "1单元": ["KMB-D08-079"]}, "6栋": {"2单元": ["KMB-D08-069"], "1单元": ["KMB-D08-068"]}, "10栋": {"2单元": ["KMB-D08-082"], "1单元": ["KMB-D08-081"]}, "12栋": {"2单元": ["KMB-D08-086"], "1单元": ["KMB-D08-085"]}, "7栋": {"2单元": ["KMB-D08-071"], "1单元": ["KMB-D08-070"], "4单元": ["KMB-D08-073"], "3单元": ["KMB-D08-072"]}, "11栋": {"2单元": ["KMB-D08-084"], "1单元": ["KMB-D08-083"]}, "3栋": {"2单元": ["KMB-D08-060"], "1单元": ["KMB-D08-059"]}, "4栋": {"2单元": ["KMB-D08-065"], "1单元": ["KMB-D08-063"]}, "5栋": {"2单元": ["KMB-D08-067"], "1单元": ["KMB-D08-066"]}, "1栋": {"2单元": ["KMB-D08-050"], "1单元": ["KMB-D08-049"]}, "2栋": {"2单元": ["KMB-D08-055"], "1单元": ["KMB-D08-052"], "3单元": ["KMB-D08-056"]}}, "42890": {"8栋": {"1单元": ["KMB-C06-041"]}, "9栋": {"1单元": ["KMB-C06-045"]}, "12栋": {"1单元": ["KMB-C06-055"]}, "10栋": {"1单元": ["KMB-C06-049"]}, "13栋": {"1单元": ["KMB-C06-057"]}, "6栋": {"1单元": ["KMB-C06-037"]}, "7栋": {"1单元": ["KMB-C06-038"]}, "11栋": {"1单元": ["KMB-C06-051"]}, "3栋": {"1单元": ["KMB-C06-029"]}, "4栋": {"1单元": ["KMB-C06-034"]}, "1栋": {"1单元": ["KMB-C06-023"]}, "2栋": {"1单元": ["KMB-C06-027"]}}, "42571": {"3栋": {"1单元": ["KMB-E03-003"]}, "1栋": {"1单元": ["KMB-E02-099"]}, "4栋": {"1单元": ["KMB-E03-006"]}, "5栋": {"1单元": ["KMB-E03-007"]}, "2栋": {"1单元": ["KMB-E03-001"]}}, "42543": {"32栋": {"1单元": ["KMB-D05-036"]}, "35栋": {"1单元": ["KMB-D05-041"]}, "29栋": {"1单元": ["KMB-D05-034"]}, "33栋": {"1单元": ["KMB-D05-037"]}, "34栋": {"1单元": ["KMB-D05-039"]}}, "42493": {"51栋": {"1单元": ["KMB-B04-003"]}}}
    canDispatch={"42731": {"8栋": {"2单元": ["KMB-D08-075"], "1单元": ["KMB-D08-074"], "4单元": ["KMB-D08-077"], "3单元": ["KMB-D08-076"], "5单元": ["KMB-D08-078"]}, "9栋": {"2单元": ["KMB-D08-080"], "1单元": ["KMB-D08-079"]}, "6栋": {"2单元": ["KMB-D08-069"], "1单元": ["KMB-D08-068"]}, "10栋": {"2单元": ["KMB-D08-082"], "1单元": ["KMB-D08-081"]}, "12栋": {"2单元": ["KMB-D08-086"], "1单元": ["KMB-D08-085"]}, "7栋": {"2单元": ["KMB-D08-071"], "1单元": ["KMB-D08-070"], "4单元": ["KMB-D08-073"], "3单元": ["KMB-D08-072"]}, "11栋": {"2单元": ["KMB-D08-084"], "1单元": ["KMB-D08-083"]}, "3栋": {"2单元": ["KMB-D08-061", "KMB-D08-060"], "1单元": ["KMB-D08-059", "KMB-D08-058"]}, "4栋": {"2单元": ["KMB-D08-065", "KMB-D08-064"], "1单元": ["KMB-D08-063", "KMB-D08-062"]}, "5栋": {"2单元": ["KMB-D08-067"], "1单元": ["KMB-D08-066"]}, "1栋": {"2单元": ["KMB-D08-051", "KMB-D08-050"], "1单元": ["KMB-D08-049", "KMB-D08-048"]}, "2栋": {"2单元": ["KMB-D08-055", "KMB-D08-054"], "1单元": ["KMB-D08-052", "KMB-D08-053"], "3单元": ["KMB-D08-056", "KMB-D08-057"]}}, "42890": {"8栋": {"1单元": ["KMB-C06-042", "KMB-C06-041", "KMB-C06-043"]}, "9栋": {"1单元": ["KMB-C06-044", "KMB-C06-046", "KMB-C06-045"]}, "12栋": {"1单元": ["KMB-C06-053", "KMB-C06-055", "KMB-C06-054"]}, "10栋": {"1单元": ["KMB-C06-048", "KMB-C06-047", "KMB-C06-049"]}, "13栋": {"1单元": ["KMB-C06-057", "KMB-C06-056", "KMB-C06-058"]}, "6栋": {"1单元": ["KMB-C06-035", "KMB-C06-037", "KMB-C06-036"]}, "7栋": {"1单元": ["KMB-C06-039", "KMB-C06-038", "KMB-C06-040"]}, "11栋": {"1单元": ["KMB-C06-051", "KMB-C06-050", "KMB-C06-052"]}, "3栋": {"1单元": ["KMB-C06-029", "KMB-C06-031", "KMB-C06-030"]}, "4栋": {"1单元": ["KMB-C06-033", "KMB-C06-032", "KMB-C06-034"]}, "1栋": {"1单元": ["KMB-C06-024", "KMB-C06-023", "KMB-C06-025"]}, "2栋": {"1单元": ["KMB-C06-026", "KMB-C06-028", "KMB-C06-027"]}}, "42571": {"3栋": {"1单元": ["KMB-E03-004", "KMB-E03-003"]}, "1栋": {"1单元": ["KMB-E02-099", "KMB-E02-098"]}, "4栋": {"1单元": ["KMB-E03-005", "KMB-E03-006"]}, "5栋": {"1单元": ["KMB-E03-008", "KMB-E03-007"]}, "2栋": {"1单元": ["KMB-E03-001", "KMB-E03-002"]}}, "42543": {"32栋": {"1单元": ["KMB-D05-035", "KMB-D05-036"]}, "35栋": {"1单元": ["KMB-D05-042", "KMB-D05-041"]}, "29栋": {"1单元": ["KMB-D05-034", "KMB-D05-033"]}, "33栋": {"1单元": ["KMB-D05-037", "KMB-D05-038"]}, "34栋": {"1单元": ["KMB-D05-039", "KMB-D05-040"]}}, "42493": {"51栋": {"1单元": ["KMB-B04-002", "KMB-B04-003"]}}}

    #print(f.count_premises1(a))
    #print(f.get_machine_code())
    print(f.compare_deliverymode(allSelect,select,canDispatch,"t3"))
