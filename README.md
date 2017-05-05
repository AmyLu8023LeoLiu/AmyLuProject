# AmyLuProject
研究生项目 关于脑电实验

## 工作日志 </br>
* 2017.04.19 程序结构大体写好 主要问题集中在 PTB 的展示部分(无法调试所以无法编写)</br>
	1.视频播放 播放视频 以及 提示部分， 提示为 预示视频播放将要开始的程序 类似 PTB 启动的时候的叹号</br>
	2.选择车牌作答 程序返回1或者0(1为正确值，0为错误值)，程序主要利用PTB工具进行选择</br>
	3.采集脑电信号需要了解清楚，之后想办法融合到Matlab中去</br>

* 2017.04.19 为亲爱的讲解函数,查找 PTB 错误解决方法</br>
* 2017.04.20 为亲爱的简化视频制作流程，增加新建的工程文件</br>
* 2017.04.28 去北理工解决问题 </br>
	1. 64位 电脑 Matlab 2015 b gstreamer 1.10.2 解决视频播放</br>
	2. 完成程序 [重点是车牌选择部分]</br>
	3. 制作视频播放 Demo</br>
	4. 卢加文 导师建议： A.按照实验范式 B.速度加快，速度分布为 0.1m/s ~ 0.7m/s 【440*140px】</br>
	5. 判断方式为 1.先给出车牌字符串(变化中间三位数字) 2.播放视频  3.判断是否与视频中一致</br>
* 2017.04.29 编写程序 实现功能 </br> 
* 2017.05.02 优化程序方案 添加注释</br>
* 2017.05.03 增加播放控制，方法还在论证中 【可以正常播放调速度，但是倒放程序本身出现问题】,帮助亲爱的更新程序，完成功能上的实现</br>
* 2017.05.04 增加视频速度提取功能，添加注释,练习使用分支；更新操作说明</br>
* 2017.05.05 帮助亲爱的完成 部分功能修改[休息功能，DATA表格文件名称拆分]，另外视频文件需要重新设计【教给亲爱的视频软件Pr的操作技巧】 </br>


## 相关资料：</br>
关于 PTB Screen 函数的一些网址：</br>
[1. PTB OpenMovie 函数说明 http://docs.psychtoolbox.org/OpenMovie](http://docs.psychtoolbox.org/OpenMovie)</br>
[2. PTB PlayMovie 函数说明 http://docs.psychtoolbox.org/PlayMovie](http://docs.psychtoolbox.org/PlayMovie)</br>
[3. PTB Screen 函数说明 http://docs.psychtoolbox.org/Screen](http://docs.psychtoolbox.org/Screen)</br>
[4. PTB FAQ https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ](https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ)</br>
[5. PTB 官网  http://psychtoolbox.org/](http://psychtoolbox.org/)</br>
[6. PTB Demo例子 http://peterscarfe.com/ptbtutorials.html](http://peterscarfe.com/ptbtutorials.html)</br>
[7. PTB Text 例子程序 http://peterscarfe.com/textdemo.html](http://peterscarfe.com/textdemo.html)</br>

##　目前问题及任务</br>
* 2017.05.03 A.相关说明在视频播放前统一说明 	B.十字的出现时间随机	 C.键盘判断使用箭头 	D.每个车牌展示停顿，任意键继续


## 流程</br>
* Step 0 : 初始化数据</br>
* Step 1 : 初始化PTB</br>
* Step 2 : 显示实验说明</br>
* Step 3 : 等待键盘任意键输入</br>
* Step 4 : 主循环：读取视频信息</br>
* Step 5 : 主循环：变化车牌</br>
* Step 6 : 主循环：显示十字及车牌</br>
* Step 7 : 主循环：播放视频</br>
* Step 8 : 主循环：选择判断</br>
* Step 9 : 主循环：黑屏1秒</br>
* Step 10 : 主循环：记录信息</br>
* Step 11 : 结束程序</br>
