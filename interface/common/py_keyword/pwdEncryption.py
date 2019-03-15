# coding=utf-8

__author__ = 'Ljq'

import base64
import rsa
import requests
import json

class pwdEncryption(object):
    """
    实现密码加密
    url 为权限系统地址
    """
    def get_public_key(self,url):
        """
        获取产品密钥
        :param url:权限系统域名
        :return: 返回pubkey_info
        """
        url = url+"/auth/api/open/pubKey"
        resa = requests.get(url=url).text
        pubkey_info = json.loads(resa)["data"]["pubkey"]
        print(pubkey_info)
        return pubkey_info

    def get_private_password(self,url, password):
        """
        根据pubkey_info进行密码加密
        :param url:权限系统域名
        :param password: 实际密码
        :return: 返回加密后密码
        """
        b_str = base64.b64decode(self.get_public_key(url))

        if len(b_str) < 162:
            return False

        hex_str = ''

        for x in b_str:
            h = hex(ord(x))[2:]
            h = h.rjust(2, '0')
            hex_str += h

        m_start = 29 * 2
        e_start = 159 * 2
        m_len = 128 * 2
        e_len = 3 * 2

        modulus = hex_str[m_start:m_start + m_len]
        exponent = hex_str[e_start:e_start + e_len]

        modulus = int(modulus, 16)
        exponent = int(exponent, 16)
        message = password
        rsa_pubkey = rsa.PublicKey(modulus, exponent)
        message = message.encode('gb2312')
        crypto = rsa.encrypt(message, rsa_pubkey)
        b64str = base64.b64encode(crypto)
        return b64str

# if __name__ == "__main__":
#     url = "http://t.zuul.xinchao.mobi"
#     password = "tang123456"
#     a = pwdEncryption().get_private_password(url,password)
#     print(a)