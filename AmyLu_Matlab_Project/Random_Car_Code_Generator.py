# -*- coding: utf-8 -*-
"""
Created on Mon May  8 16:03:43 2017
@author: Anshare_LY
"""
import random
import time
import codecs

def Random_Car_Code_Generator(NumOfText,city):
    Car_City=''.join(random.sample(city,1))
    Temp_Char=chr(random.randint(67,79)) # 生成随机 A~Z 大写字母
    Car_Code=""
    for i in range(5):
        if(i<(NumOfText-1)):
            Temp=chr(random.randint(67,90)) # 生成随机 A~Z 大写字母
        else:
            Temp=str(random.randint(0,9)) # 生成 0~9 随机数字
        Car_Code=Car_Code+Temp
    Car_Code=random.sample(Car_Code,len(Car_Code)) # 乱序排列 得到列表
    Car_Code=Car_City+Temp_Char+''.join(Car_Code) # 添加城市文字
    print("最终车牌:  "+Car_Code)
    return Car_Code

def OutPutCarCodeList(Car_Code_List, num ,title):
    try:
        FileName="CarCode_"+str(num)+" "+(time.strftime('%Y%m%d',time.localtime(time.time())))+".txt"
        TextFile=codecs.open(FileName,"w","utf-8")
        TextFile.write(u""+title+"\n")
        for i in range(num):
            CarCode_Temp=Car_Code_List[i]
            TextFile.write(u""+str(CarCode_Temp)+"\n")
        TextFile.close()
        print("--> 文件保存成功! 文件名: "+FileName+"\n--> 车牌总数: %d个"%(num))
    except:
        print("\n-!-> 文件输出函数错误!")

def main():
    Num_Of_Text=2
    Num_Of_Car_Code=40
    city=['京','津','翼','苏','云','军','粤','沪']
    Car_Code=[]
    for x in range(Num_Of_Car_Code):
        Car_Code.append(Random_Car_Code_Generator(Num_Of_Text,city))
    OutPutCarCodeList(Car_Code, len(Car_Code) ,"CarCode")

main()