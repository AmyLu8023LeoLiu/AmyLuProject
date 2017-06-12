clc;
close all
clear all
PsychDefaultSetup(2);
Screen('Preference','TextEncodingLocale','UTF-8');  % 文本显示编码用 UTF-8
Screen('Preference', 'SkipSyncTests', 1);    % 跳过检查
screenGrps=Screen('Screens');   % 初始化 屏幕
screenNumber=max(screenGrps);  % 选择次要 投放显示器
Color_black = BlackIndex(screenNumber); % 得到黑色屏幕的颜色数值
Color_white = WhiteIndex(screenNumber); % 得到白色屏幕的颜色数值
Color_grey = Color_white / 2; % 得到灰色屏幕的颜色数值
[window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black); % 获得当前屏幕与屏幕的相关信息
[screenXpixels, screenYpixels] = Screen('WindowSize', window); % 获得屏幕尺寸
[xCenter, yCenter] = RectCenter(windowRect); % 获得中心坐标
% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
Screen('TextSize', window, 100);
Screen('TextFont', window, 'simhei'); 
%% 获得视频路径
FolderPath=[fileparts(mfilename('fullpath')),'\'];  % 自动获取 .m 文件目录 因此项目的相对文件位置不要改变
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % 得到Excel电子表格完整目录
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % 得到Excel电子表格完整目录
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1);  % 获得表格中的数据
DATA_Input_Cell=RAW(2:end,:); % 去掉表头保留数据 
CarCodeAll=unique(DATA_Input_Cell(:,5));   % 获取全部车牌信息
Excel_Start=2;                          % Excel 开始行数
Speed_Num=length(unique(cell2mat(DATA_Input_Cell(:,3)))); % 速度的类别数
CarCode_Class_Num=length(CarCodeAll);   % 车牌类别数
Excel_End=Excel_Start+CarCode_Class_Num*Speed_Num-1; % 计算 Excel 结束行数
OutPut_Cell={}; % 输出的初始化
%% 视频播放

for Main_Index=1:length(DATA_Input_Cell)
    Temp=Main_Index;  % 读取随机数列的值
    Temp_Number=DATA_Input_Cell(Temp,1);       % 读取序号
    Temp_Video_Class=cell2mat(DATA_Input_Cell(Temp,2));    % 读取类别
    Temp_Video_Speed=cell2mat(DATA_Input_Cell(Temp,3));    % 读取速度
    Temp_Video_Form=DATA_Input_Cell(Temp,4);    % 读取文件类型
    Temp_CarCode=char(DATA_Input_Cell(Temp,5));      % 读取车牌号
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 转化格式 (由于Excel 存入的类型是数字，所以在此转化为字符)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Temp_Video_Class<10) % 视频类别转化为字符
        Temp_Category_Char=[int2str(0),int2str(Temp_Video_Class)];% 添加零
    else
        Temp_Category_Char=num2str(Temp_Video_Class);              % 转化为字符串
    end
    if (Temp_Video_Speed<10) % 视频速度转化为字符
        Temp_Speed_Char=[int2str(0),strrep(num2str(Temp_Video_Speed),'.','')];   % 添加零 去掉小数点
    else
        Temp_Speed_Char=num2str(Temp_Video_Speed);                % 转化为字符串
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Temp_VideoName=[char(Temp_Category_Char),'-',char(Temp_Speed_Char),char(Temp_Video_Form)]; % 组成视频文件名
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % 得到完整的视频文件路径
    [Car_MoviePtr] = Screen('OpenMovie', window,VideoFileName);
    Screen('PlayMovie',Car_MoviePtr, 1);
    while (1) % 逐帧播放视频
        Movie_IMG_Temp = Screen('GetMovieImage', window, Car_MoviePtr); % 获得一帧视频图像
        if Movie_IMG_Temp<=0 %判断视频是否已经读取完
        break
    end
	%更新画面
    Screen('DrawTexture', window, Movie_IMG_Temp);% 绘制图像
    Screen('Flip', window);% 更新显示
    Screen('Close', Movie_IMG_Temp);% 释放视频资源
end
Screen('CloseMovie', Car_MoviePtr);
end
sca