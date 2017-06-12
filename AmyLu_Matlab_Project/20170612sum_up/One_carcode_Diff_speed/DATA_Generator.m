clc;
close all
clear all
%% 设置部分
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 以下为程序控制部分     你要设置的
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CarCode_Mode=1;     % 1 使用外部txt 文件 0 使用本程序生成的随机车牌
Char_Flag = 1;      % 1 为打开  0 为关闭 车牌后5位随机更换为字母
Log_Flag = 1;       % 1 为打开 Log 0 为 关闭 (调试用，输出运行中的记录)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 以下为初始化设置部分   你要设置的 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Title_Name='CarCode';   % Txt 文件的数据组名称
Txt_File_Name='AmyLuTxt.txt';    % 要读取的 Python 生成的Txt文件名
Video_Form='.mp4';
FolderPath='C:\Users\Amy Lu\Desktop\AmyLu_Matlab_Project\testspeed\';	% 变更文件地址 注意 '\'斜线
Start_Speed=0.1;    % 起始速度
Speed_Step=0.1;     % 速度变化步进
Speed_Num=5;        % 速度类别数
End_Speed=Start_Speed+(Speed_Num-1)*Speed_Step;      % 终止速度
Excel_Start=2;      % Excel 开始行数
Car_Code_Num=1;    % 自定义车牌的总数量
%% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 数据初始化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Car_City={'京','津','豫','渝','翼','苏','云','辽','黑','湘','皖','鲁','新',...
    '浙','赣','鄂','桂','甘','晋','蒙','陕','吉','闽','粤','沪'};
Car_Char='ABCDEFGHIJKLMNOPQRSTUVWXYZ'; % 字符串组
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % 得到Excel电子表格完整目录
CarCode_Cell={};    % 存放车牌
OutPut_Cell={};     % 初始化输出项
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(CarCode_Mode==1)
    %% 读取 TXT 文件
    TXT_CarCode_FileName = [FolderPath,Txt_File_Name];  % TXT 文件名
    TXT_CarCode = fopen(TXT_CarCode_FileName,'r','n','UTF-8');      % 设置UTF-8码才能转换
    TXT_CarCode_Tline = fgetl(TXT_CarCode);                         % 读取第一行
    Temp_Index=1;                                                   % 设置临时引索
    while ischar(TXT_CarCode_Tline)                                 % 循环读取
        CarCode_Cell(Temp_Index)={TXT_CarCode_Tline};               % 添加到Cell
        TXT_CarCode_Tline = fgetl(TXT_CarCode);
        Temp_Index=Temp_Index+1;
    end
    fclose(TXT_CarCode);                                            % 关闭文件
    CarCode_Cell=CarCode_Cell(2:end);                               % 去除 TXT 开头文件数据组名称
    Car_Code_Num=length(CarCode_Cell);                              % 读取数据长度
end
Excel_All=(Car_Code_Num*((End_Speed-Start_Speed)/Speed_Step+1));
Excel_End=Excel_Start+Excel_All-1;   % Excel 结束行数

%% 打印设置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 设置输出
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(Log_Flag==1)
    if(CarCode_Mode==1)
        disp('-->外部读取TXT文件')
    else
        disp('-->程序生成随机车牌')
    end
    disp(['-->是否生成后5位含字母的车牌: ',num2str(Char_Flag),' (1 是 0 否)'])
    disp(['-->车牌数量: ',num2str(Car_Code_Num)])
    disp(['-->起始速度: ',num2str(Start_Speed),' m/s  终止速度: ',num2str(End_Speed),' m/s  速度步进: ',num2str(Speed_Step),' m/s'])
    disp(['-->速度类数: ',num2str(Speed_Num)])
end
%% 主循环函数
if(CarCode_Mode==0)
    for Main_Index=1:Car_Code_Num    % 设置循环
    %% 生成车牌
    Temp_CarCode_Num=randperm(9);
    Temp_CarCode=[char(Car_City(unidrnd(length(Car_City)))),char(Car_Char(unidrnd(length(Car_Char)))),num2str(Temp_CarCode_Num(1:5))];
    Temp_CarCode=strrep(Temp_CarCode,' ','');
    if(Char_Flag==1)
        Temp_Char_Change_Index=unidrnd(3)+2;
        Temp_CarCode(Temp_Char_Change_Index)=char(Car_Char(unidrnd(length(Car_Char))));
    end
    % 记录函数
    CarCode_Cell(Main_Index)={Temp_CarCode};
    end
    % 打印提示
    if(Log_Flag==1)
        disp('-->随机车牌生成完成')
    end
    %% 保存车牌
    CarCode_Txt_OutPut=fopen('CarCode.txt','w','n','UTF-8');
    fprintf(CarCode_Txt_OutPut,[Title_Name,'\r\n']);
    for index=1:length(CarCode_Cell)
        fprintf(CarCode_Txt_OutPut,[char(CarCode_Cell(index)),'\r\n']);  % \r\n Windows版本换行符
    end
    fclose(CarCode_Txt_OutPut);
    % 打印提示
    if(Log_Flag==1)
        CarCode_Cell
        disp('-->文本保存完成')
    end
end
%% 循环 生成Excel表格内容
for Excel_Index=1:Excel_All
    %% 计算类别
    Temp_Category=ceil(Excel_Index/Speed_Num);
    if (Temp_Category<10) % 添加0
        Temp_Category_Char=[int2str(0),int2str(Temp_Category)];% 添加零
    else
        Temp_Category_Char=num2str(Temp_Category);              % 转化为字符串
    end
    % 计算速度
    Temp_Speed=mod(Excel_Index,Speed_Num);
    if(Temp_Speed==0)
        Temp_Speed=Speed_Num;
    end
    Temp_Speed=Start_Speed*10+(Temp_Speed-1);               % 生成速度 
    if (Temp_Speed<10) % 添加0
        Temp_Speed_Char=[int2str(0),int2str(Temp_Speed)];   % 添加零
    else
        Temp_Speed_Char=num2str(Temp_Speed);                % 转化为字符串
    end
    % 记录
    OutPut_Cell(Excel_Index,1)=num2cell(Excel_Index);       % 记录序号
    OutPut_Cell(Excel_Index,2)={Temp_Category_Char};        % 记录类别
    OutPut_Cell(Excel_Index,3)={Temp_Speed_Char};           % 记录速度
    OutPut_Cell(Excel_Index,4)={Video_Form};                % 记录视频文件类型
    OutPut_Cell(Excel_Index,5)=CarCode_Cell(Temp_Category); %记录车牌内容
end
%% 记录到 Excel 文件
if(Log_Flag==1)
    Temp={'序号','类别','速度','文件类型','车牌内容'}
    OutPut_Cell
end
xlswrite(Excel_DATA_FileName, {'序号','类别','速度','文件类型','车牌内容'}, 'Sheet1', 'A1:E1')
xlswrite(Excel_DATA_FileName, OutPut_Cell, 'Sheet1', ['A',num2str(Excel_Start),':','E',num2str(Excel_End)])
if(Log_Flag==1)
    disp(['-->实验数据保存成功 ！'])
end