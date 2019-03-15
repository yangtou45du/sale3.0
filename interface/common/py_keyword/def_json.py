# coding=utf-8

__author__ = 'Ljq'

import json
import math

# 处理所有楼盘信息,将楼盘中所有可添加的设备全部获取出来

class def_json(object):
    ROBOT_LIBRARY_SCOPE = 'TEST CASE'
    ROBOT_LIBRARY_VERSION = '0.1'
    # 将list中的json按照key进行排序
    def SortDict(self,elem):
        return list(elem.keys())[0]

    # 用于def_api.get_all方法调用
    def create_json(self,machine_count, premisesID):
        L = {}
        L1 = []
        data = machine_count[1]["aaData"]
        # print(data)
        building = []
        print("len(data)", len(data))
        for i in data:
            building.append(i["building"])
        for i in set(building):
            L1.append({i: []})
        # print(L1)
        for i in range(len(L1)):
            building_unit = []
            for i1 in data:
                if (L1[i].keys())[0] == i1["building"]:
                    if {i1["unit"]: []} not in building_unit:
                        building_unit.append({i1["unit"]: []})
            L1[i][(L1[i].keys())[0]] = building_unit
        # print(L1)
        for a in range(len(L1)):
            for a1 in L1[a]:
                for a3 in L1[a][a1]:
                    unit_code = []
                    for a4 in data:
                        if a4["unit"] == (a3.keys())[0]:
                            if a4["building"] == a1:
                                unit_code.append(a4['code'])
                    a3[(a3.keys())[0]] = unit_code
        L1.sort(key=self.SortDict)
        L[premisesID] = L1
        return L

    # 处理所有楼盘信息,将楼盘中所有可添加的设备全部获取出来
    # 用于def_api.get_all_b方法调用
    def create_json_already_add(self,machine_count, premisesID):
        L = {}
        L1 = []
        data = machine_count[0]["aaData"]
        # print(data)
        building = []
        print("len(data)", len(data))
        for i in data:
            building.append(i["building"])
        for i in set(building):
            L1.append({i: []})
        # print(L1)
        for i in range(len(L1)):
            building_unit = []
            for i1 in data:
                if (L1[i].keys())[0] == i1["building"]:
                    if {i1["unit"]: []} not in building_unit:
                        building_unit.append({i1["unit"]: []})
            L1[i][(L1[i].keys())[0]] = building_unit
        # print(L1)
        for a in range(len(L1)):
            for a1 in L1[a]:
                for a3 in L1[a][a1]:
                    unit_code = []
                    for a4 in data:
                        if a4["unit"] == (a3.keys())[0]:
                            if a4["building"] == a1:
                                unit_code.append(a4['code'])
                    a3[(a3.keys())[0]] = unit_code
        L1.sort(key=self.SortDict)
        L[premisesID] = L1
        return L

    # 创建的json中的设备信息并将该楼盘的设备信息创建一个list,供return_all_code方法调用
    def json_to_list(self,aop):
        a = []
        for i in aop:
            for i1 in aop[i]:
                for i2 in i1:
                    for i3 in i1[i2]:
                        for i4 in i3:
                            for i5 in i3[i4]:
                                a.append(i5)
        return a

    # 调用json_to_list,将所有楼盘建立的json中的设备信息进行提取
    def return_all_code(self,all_loupan_and_code):
        all_code = []
        for one_loupan_and_code in all_loupan_and_code:
            one_code = self.json_to_list(one_loupan_and_code)
            # print(len(one_code))
            # print(one_code)
            all_code = all_code + one_code
        return all_code

    # json_data,code_list,供remo_code_from_json方法调用
    def analysis_json(self,json_data, code_list):
        for code_a in code_list:
            for i in json_data:
                for i1 in json_data[i]:
                    for i2 in i1:
                        for i3 in i1[i2]:
                            for i4 in i3:
                                for i5 in i3[i4]:
                                    if code_a == i5:
                                        i3[i4].remove(code_a)
        return json_data

    # 调用analysis_json.移除json中的设备信息
    def remo_code_from_json(self,json_data, code_list):
        for one_json in json_data:
            self.analysis_json(one_json, code_list)
        return json_data

    # 将json中不可添加的设备移除
    def return_can_add_json(self,all_loupan_and_code, return_all_can_adds, all_machine):
        for machine in all_machine:
            for can_adds in return_all_can_adds:
                if machine == can_adds:
                    print("machine%s" % machine)
                    all_machine.remove(machine)
        can_add_codes = len(all_machine)
        for i in all_loupan_and_code:
            all_machine = self.analysis_json(i, all_machine)
        return all_loupan_and_code, can_add_codes

    # json比较
    def compare_res(self,json_a, json_b, ad_type,num=0):
        """
        :param json_a: 已调度点位的总信息
        :param json_b: 可调度点位的总信息
        :param ad_type:广告方案的delivery_mode类型,002对应T2,003对应T3
        :param num:num=0 num不需要进行传值,默认为0
        :return:
        返回0表示对比成功无异常
        返回值大于0则表示对比出现错误
        eg:
        如果num传入了参数,则需要返回的参数与num一致时才表示对比成功
        """
        ad_type = str(ad_type)
        print("begin test data compare")
        print("json_a%s---------type%s" % (json_a, type(json_a)))
        print("json_b%s---------type%s" % (json_b, type(json_b)))
        print("ad_type%s" % ad_type)
        if type(json_a) == list and type(json_b) == list:
            for a_child in json_a:
                for b_child in json_b:
                    if a_child.keys() == b_child.keys():
                        print(list(a_child.keys())[0])
                        if type(a_child[list(a_child.keys())[0]]) == list and type(b_child[list(a_child.keys())[0]])==list:
                            if a_child[list(a_child.keys())[0]] != [] and b_child[list(a_child.keys())[0]] != []:
                                if type(a_child[list(a_child.keys())[0]][0]) == dict and type(b_child[list(a_child.keys())[0]][0]) == dict:
                                    num = self.compare_res(a_child[list(a_child.keys())[0]],b_child[list(a_child.keys())[0]],ad_type,num)
                                elif type(a_child[list(a_child.keys())[0]][0]) == unicode and type(b_child[list(a_child.keys())[0]][0]) == unicode:
                                    # print("-----------aaa------------")
                                    print(len(a_child[list(a_child.keys())[0]]),len(b_child[list(a_child.keys())[0]]))
                                    if ad_type == '002':
                                        print("-------------002----------")
                                        if len(a_child[list(a_child.keys())[0]]) <= 1:
                                            pass
                                        else:
                                            num = num +1
                                    elif ad_type == '003':
                                        print("-------------003----------")
                                        if len(a_child[list(a_child.keys())[0]]) <= math.ceil(float(len(b_child[list(a_child.keys())[0]]))/float(2)):
                                            pass
                                        else:
                                            num = num +1
                                    elif ad_type == '001':
                                        print("-------------001----------")
                                        if int(len(a_child[list(a_child.keys())[0]])) <= int(len(b_child[list(a_child.keys())[0]])):
                                            pass
                                        else:
                                            num = num +1
                                    else:
                                        print("not right")
        return num
#
# if __name__ =="__main__":
#     a = [{277101: []}, {22919: [{u'A\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-001']}]}, {u'B\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-004']}]}, {u'C\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-005']}]}]}, {242423: [{u'1\u680b': [{u'1\u5355\u5143': [u'SP-SG-LCC001-TEST']}]}]}, {208154: [{u'\u6d4b\u8bd5-\u8bbe\u5907\u6392\u65a5-\u697c\u680b': [{u'\u6d4b\u8bd5-\u8bbe\u5907\u6392\u65a5-\u5355\u5143': [u'TEST-WJ-001']}]}]}, {208182: []}, {25891: [{u'A\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-033']}]}, {u'B\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-034']}]}]}]
#     b = [{277101: []}, {22919: [{u'A\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-002', u'NZJB-H01-001']}]}, {u'B\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-004', u'NZJB-H01-003']}]}, {u'C\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-006', u'NZJB-H01-005']}]}]}, {242423: [{u'1\u680b': [{u'1\u5355\u5143': [u'SP-SG-LCC001-TEST']}]}]}, {208154: [{u'\u6d4b\u8bd5-\u8bbe\u5907\u6392\u65a5-\u697c\u680b': [{u'\u6d4b\u8bd5-\u8bbe\u5907\u6392\u65a5-\u5355\u5143': [u'TEST-WJ-001', u'TEST-WJ-002']}]}]}, {208182: [{u'\u697c\u680b1': [{u'\u5355\u51431': [u'SP-HZY-003-TEST']}]}]}, {25891: [{u'A\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-033']}]}, {u'B\u5e62': [{u'1\u5355\u5143': [u'NZJB-H01-034']}]}]}]
#     ad_type = "002"
#     c = def_json().compare_res(a,b,ad_type)
#     print(c)