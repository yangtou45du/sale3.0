# coding=utf-8

__author__ = 'Zjj'

import datetime
import time


class OtherKW(object):
    ROBOT_LIBRARY_SCOPE = 'TEST CASE'
    ROBOT_LIBRARY_VERSION = '0.3'

    def __init__(self):
        self.time_a = time.time()

    """
            根据当前时间获取最近的下个周一或者周二的具体日期
            :param now:  现在的时间，数据类型是时间戳
            :param weeks_num:  获取这个时间对应的下一个指定周几的日期
            :return:
            standard_time 返回对应日期的的标准时间
            time_stamp_a  返回对应日期的时间戳
            """
    def get_weeks(self, now, weeks_num, num):
        for i in range(30):
            if num == 1:
                time_stamp_a = now + i * 24 * 60 * 60 + 8 * 60 * 60
            elif num == 2:
                time_stamp_a = now - i * 24 * 60 * 60 + 8 * 60 * 60
            else:
                time_stamp_a = now + i * 24 * 60 * 60 + 8 * 60 * 60 + 7 * 24 * 60 * 60 + 8 * 60 * 60
            Over_time = datetime.datetime.utcfromtimestamp(time_stamp_a)
            standard_time = Over_time.strftime("%Y-%m-%d")
            Year = int(Over_time.strftime("%Y"))
            Month = int(Over_time.strftime("%m"))
            Day = int(Over_time.strftime("%d"))
            Weeks = datetime.datetime(Year, Month, Day).strftime("%w")
            if int(Weeks) == weeks_num:
                return standard_time, time_stamp_a, Year, Month, Day

    #获取最近的周五（今天之后）的时间
    def get_two_weeks(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 5, 1)
        day_b, time_c, y_2, m_2, d_2 = self.get_weeks(time_b, 5, 1)
        return day_b

    # 获取最近的周六（今天之后）的时间
    def get_two_week_friday(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 6, 1)
        return day_a

    # 获取最近第二个的周五（今天之后）的时间
    def get_two_weeks_friday(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 5, 3)
        return day_a

    # 改变最近的周六（今天之后）的时间，格式
    def change_two_week_friday(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 6, 1)
        new_day = str(m_1) + "/" + str(d_1) + "/" + str(y_1)
        return new_day

    # 改变最近的第二个周五（今天之后）的时间，格式
    def change_two_week_fridays(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 5, 3)
        new_day = str(m_1)+"/"+str(d_1)+"/"+str(y_1)
        return new_day

	#author：sgrj
	#以下的日期用于调整结束日
	
    # 获取最近第二个的周四（今天之后）的时间
    def get_two_week_thursday(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 4, 3)
        return day_a

    # 改变最近的第二个周四（今天之后）的时间，格式
    def change_two_week_thursday(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 4, 3)
        new_day = str(m_1) + "/" + str(d_1) + "/" + str(y_1)
        return new_day

    # 获取最近第三个的周二（今天之后）的时间
    def get_three_week_tuesday(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 2, 4)
        return day_a

    # 改变最近的第三个周二（今天之后）的时间，格式
    def change_three_week_tuesday(self):
        day_a, time_b, y_1, m_1, d_1 = self.get_weeks(self.time_a, 2, 4)
        new_day = str(m_1) + "/" + str(d_1) + "/" + str(y_1)
        return new_day

# if __name__ == "__main__":
#     a= OtherKW().get_two_weeks()
#     print(a)
#     b = OtherKW().get_two_week_friday()
#     print(b)
#     c = OtherKW().get_two_weeks_friday()
#     print(c)
#     d = OtherKW().change_two_week_friday()
#     print(d)
#     e = OtherKW().change_two_week_fridays()
#     print(e)
#     f = OtherKW().get_two_week_thursday()
#     print(f)
#     g = OtherKW().change_two_week_thursday()
#     print(g)
#     h = OtherKW().get_three_week_tuesday()
#     print(h)
#     i = OtherKW().change_three_week_tuesday()
#     print(i)
