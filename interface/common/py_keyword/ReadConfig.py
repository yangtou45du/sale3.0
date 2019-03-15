# coding=utf-8

__author__ = 'Ljq'

import configparser

import os

class ReadConfig(object):
    ROBOT_LIBRARY_SCOPE = 'TEST CASE'
    ROBOT_LIBRARY_VERSION = '0.4'

    def __init__(self):
        self.conf = configparser.ConfigParser()
        self.evn_name = os.name
        self.file_name = r'test_config.ini'
        if self.evn_name == 'nt':
            self.relative_path = r'/interface/config/'
            self.file_path = os.path.abspath(os.path.join(os.getcwd(), "../..")) + self.relative_path+self.file_name
        elif self.evn_name == 'posix':
            self.relative_path = r'/Sale3.0/interface/config/'
            self.file_path = os.path.abspath(os.path.join(os.getcwd())) + self.relative_path + self.file_name
            # self.file_path = os.getcwd()
        self.conf.read(self.file_path,encoding="utf-8")

    def ReturnSections(self):
        sections = self.conf.sections()
        print(sections)
        return sections

    def ReturnOptions(self,options):
        options = self.conf.options(options)
        print(options)
        return options

    def ReturnItems(self,items):
        items = self.conf.items(items)
        print(items)

    def ReturnGet(self,options,items):
        value = self.conf.get(options,items)
        print(value)
        return value

    def ReturnFilePath(self):
        print(self.file_path)
        return self.file_path


