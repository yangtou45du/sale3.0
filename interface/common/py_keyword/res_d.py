# coding=utf-8

__author__ = 'Ljq'

import random
import json

class ResData(object):
    ROBOT_LIBRARY_SCOPE = 'TEST CASE'
    ROBOT_LIBRARY_VERSION = '0.3'

    def __init__(self):
        pass

    def res_data(self, str_a):
        res_d = []
        res_str = str_a
        for i in res_str["aaData"]:
            res_d.append(int(i["id"]))
        res_d = random.sample(res_d,10)
        return res_d