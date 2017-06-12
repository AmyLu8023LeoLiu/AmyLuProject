clc;
close all
clear all
%% 设置部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%以下为初始化设置部分   你要设置的 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sheet_Name='Data_Analysis'; % 分析表格的表单名称
Plot_Text_Flag=0;   % 是否在图中将数据以底部表格的形式表示出来 1 表示 0 不表示
%% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderPath=[fileparts(mfilename('fullpath')),'\'];  % 自动获取 .m 文件目录 因此项目的相对文件位置不要改变
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % 得到Excel电子表格完整目录
[Type Sheet Format]=xlsfinfo(Excel_OUTPUT_FileName);    % 得到表格文件属性 程序用到的是 Sheet 所有表单信息
% 处理 Sheet 中的表单 排除不需要的项
Sheet(find(strcmp(Sheet,Sheet_Name)))=[];   % 去除 分析总结表单
Sheet(find(strcmp(Sheet,'Sheet1')))=[];     % 去除 Sheet1 表单
Data_ALL_Cell={}; % 输出的输出
%% 主循环函数
for Main_Index=1:length(Sheet)    % 设置循环
    %% 获取表格信息
    [NUM,TXT,RAW]=xlsread(Excel_OUTPUT_FileName ,char(Sheet(Main_Index)));  % 获得表格中的数据
    DATA_C=RAW(2:end,:); % 文件交换 Video_Name_C(行号,列号) 引索由1开始
    % DATA_C(N,1) 序号
    % DATA_C(N,2) 原始DATA序号
    % DATA_C(N,3) 视频文件名
    % DATA_C(N,4) 车牌号
    % DATA_C(N,5) 速度(m/s)
    % DATA_C(N,6) 回答正误(1为正确,0为错误)
    %% 数据分析部分
    Speed_All=unique(cell2mat(DATA_C(:,5)))/1.0; % 获取全部速度
    Speed_Num=length(Speed_All); % 得到速度种类数
    CarCode_Class_Num=length(unique(DATA_C(:,4))); % 得到车牌种类数 [这里统计的时候无需转化Cell类型]
    Speed_All=Speed_All'; % 转置矩阵
    Correct_Speed=[]; % 建立正确率数组
    for Speed_index=1:Speed_Num
        Correct_Speed(Speed_index)=length(...       % 求总长度
        intersect((find(cell2mat(DATA_C(:,5))==Speed_All(Speed_index))),...  % intersect 求得矩阵的交集 DATA_C(:,5) 得到速度列
        (find(cell2mat(DATA_C(:,6))==1)))); % 计算正确率  DATA_C(:,6) 答案列
    end
    Correct_Speed=Correct_Speed/double(CarCode_Class_Num); % 计算每项正确率
	%% 绘图
    Figure_Arrow=[repmat('\uparrow',length(Correct_Speed),1)]; % 生成箭头
    Figure_Number=[num2str(roundn((Correct_Speed')*100,-1)),repmat(' %',length(Correct_Speed),1)]; %生成图表文字
    figure(Main_Index);
    plot(Speed_All,Correct_Speed,'bo-');
    axis([(min(Speed_All)-0.1) (max(Speed_All)+0.1) 0 1]); % 设置坐标轴在指定的区间 xmin xmax ymin ymax
    % 图表标注
    xlabel('速度');
    ylabel('正确率');
    title([char(Sheet(Main_Index)),'的测试结果统计']);
    % 数据标注
    Adjust_Temp=ones(1,length(Speed_All));
    Adjust_Temp(1,1)=0.85;
    text(Speed_All,(Correct_Speed.*Adjust_Temp-0.05),cellstr(Figure_Arrow),'center');   % 画箭头
    text(Speed_All,(Correct_Speed.*Adjust_Temp-0.1),cellstr(Figure_Number),'center');   % 画百分比
    if(Plot_Text_Flag==1)
        text(0,0.4,' 速度 (m/s)');
        text(0:0.1:max(Speed_All),(repmat(0.3,1,length(Correct_Speed))),(num2cell(Speed_All)));
        text(0,0.2,' 正确率 %');
        text(0:0.1:max(Speed_All),(repmat(0.1,1,length(Correct_Speed))),(num2cell(roundn(Correct_Speed*100,-1))));
    end
    Data_ALL_Cell(Main_Index,1)={char(Sheet(Main_Index))}; % 添加志愿者姓名
    Data_ALL_Cell(Main_Index,2:(length(Correct_Speed)+1))=num2cell(Correct_Speed); % 把正确率数据放入Cell 中
end
%% 总平均值分析
% 计算
if(length(Data_ALL_Cell(:,1))>1) % 判断是否只有一组数据
    Avg_Correct=sum(cell2mat(Data_ALL_Cell(:,2:end))/length(Data_ALL_Cell(:,1)));
else
    Avg_Correct=cell2mat(Data_ALL_Cell(:,2:end))/length(Data_ALL_Cell(:,1));
end
Figure_Arrow=[repmat('\uparrow',length(Avg_Correct),1)]; % 生成箭头
Figure_Number=[num2str(roundn((Avg_Correct')*100,-1)),repmat(' %',length(Avg_Correct),1)]; %生成图表文字
%生成图表文字
figure;
plot(Speed_All,Avg_Correct,'ro-');
axis([(min(Speed_All)-0.1) (max(Speed_All)+0.1) 0 1]); % 设置坐标轴在指定的区间 xmin xmax ymin ymax
% 图表标注
xlabel('速度');
ylabel('正确率');
title('平均准确率统计');
% 数据标注
text(Speed_All,(Avg_Correct.*Adjust_Temp-0.05),cellstr(Figure_Arrow),'center'); % 画箭头
text(Speed_All,(Avg_Correct.*Adjust_Temp-0.1),cellstr(Figure_Number),'center'); % 画百分比
if(Plot_Text_Flag==1)
    text(0,0.4,' 速度 (m/s)');
    text(0:0.1:max(Speed_All),(repmat(0.3,1,length(Correct_Speed))),(num2cell(Speed_All)));
    text(0,0.2,' 正确率 %');
    text(0:0.1:max(Speed_All),(repmat(0.1,1,length(Correct_Speed))),(num2cell(roundn(Avg_Correct*100,-1))));
end
% 添加Excel表尾信息
Data_Avg_Cell(1)={'平均准确率'}; % 表头
Data_Avg_Cell(1,2:(length(Avg_Correct)+1))=num2cell(Avg_Correct); % 放入平均准确率
%% 记录到 Excel 文件
% 添加Excel表头信息
Data_Title_Cell(1)={'志愿者姓名\速度(m/s)'}; % 表头
Data_Title_Cell(1,2:(length(Speed_All)+1))=num2cell(Speed_All); % 放入速度信息
Excel_End=length(Sheet)+1; % 计算数据截止行
% 打印
Data_Title_Cell % 表头
Data_ALL_Cell 	% 数据
Avg_Correct     % 平均值
% 写入 Excel
xlswrite(Excel_OUTPUT_FileName, Data_Title_Cell, Sheet_Name, ['A1:',char('A'+length(Speed_All)),'1']) % 记录表头
xlswrite(Excel_OUTPUT_FileName, Data_ALL_Cell, Sheet_Name, ['A2:',char('A'+length(Speed_All)),num2str(Excel_End)]) % 记录数据
xlswrite(Excel_OUTPUT_FileName, Data_Avg_Cell, Sheet_Name, ['A',num2str(Excel_End+1),':',char('A'+length(Speed_All)),num2str(Excel_End+1)]) % 记录平均值
disp(['-->实验数据分析结果保存成功 ！'])
clear all   % 释放所有资源