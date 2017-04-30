clc;
close all
clear all
%% ���ò���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ������Ʋ���     ��Ҫ���õ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PTB_Flag = 1; % 1 Ϊ�� PTB 0 Ϊ �ر� (�����ã���PTB������������� ������������)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ϊ��ʼ�����ò���   ��Ҫ���õ� 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FolderPath='D:\workspace\AmyLuProject\AmyLu_Matlab_Project\';	% ����ļ���ַ
VolunteerName='LeoLiu';  % ����������
Excel_Start=2;  % Excel ��ʼ����
Excel_End=21;   % Excel ��������
CarCode_Change_Num=3;   % ���Ʒ����仯��λ�� ����� 5
CarCode_Char_Offset=7;  % ��СֵΪ 5 
%% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ݳ�ʼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(PTB_Flag==1)
    sca
end
Data_Num=Excel_End-Excel_Start+1;
Excel_DATA_FileName = [FolderPath,'DATA.xls'];  % �õ�Excel���ӱ������Ŀ¼
Excel_OUTPUT_FileName = [FolderPath,'OutPut.xls'];  % �õ�Excel���ӱ������Ŀ¼
Picture_TargetArea=[FolderPath,'target_area.jpg'];
Picture_Wait_5s=[FolderPath,'5swait.jpg'];
[NUM,TXT,RAW]=xlsread(Excel_DATA_FileName ,1,['A',num2str(Excel_Start),':','C',num2str(Excel_End)]);  % ��ñ���е�����
Video_Name_C=RAW; % �ļ����� Video_Name_C(�к�,�к�) ������1��ʼ
% Video_Name_C(N,1) ���
% Video_Name_C(N,2) �ļ���
% Video_Name_C(N,3) ���ƺ�
CarCodeAll=unique(Video_Name_C(:,3))
Random_Series=randperm(length(Video_Name_C));   % �����������
OutPut_Cell={}; % ����ĳ�ʼ��
%% PTB���߳�ʼ��
if(PTB_Flag==1)
    PsychDefaultSetup(2);
    Screen('Preference','TextEncodingLocale','UTF-8');  % �ı���ʾ������ GBK
    Screen('Preference', 'SkipSyncTests', 1)    % �������
    screenGrps=Screen('Screens');   % ��ʼ�� ��Ļ
    screenNumber=max(screenGrps);  % Select the external screen if it is present, else revert to the native
    Color_black = BlackIndex(screenNumber); % �õ���ɫ��Ļ����ɫ��ֵ
    Color_white = WhiteIndex(screenNumber);
    Color_grey = Color_white / 2;
    [window,windowRect] = PsychImaging('OpenWindow', screenNumber,Color_black);
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    Picture_Read_TargetArea= imread(Picture_TargetArea);
    Picture_Read_Wait_5s= imread(Picture_Wait_5s);
    PTB_IMG_TargetArea=Screen('MakeTexture',window ,Picture_Read_TargetArea);
    PTB_IMG_Wait_5s=Screen('MakeTexture',window ,Picture_Read_Wait_5s);
    % Set the blend funciton for the screen
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    Screen('TextSize', window, 100);
    Screen('TextFont', window, 'simhei'); 
end
%% ��ѭ������
for Main_Index=1:length(Video_Name_C)    % ����ѭ��
    %% ��ȡ��Ƶ��Ϣ
    Temp=Random_Series(Main_Index);  % ��ȡ������е�ֵ
    Temp_Number=Video_Name_C(Temp,1);       % ��ȡ���
    Temp_VideoName=Video_Name_C(Temp,2);    % ��ȡ�ļ���
    Temp_CarCode=Video_Name_C(Temp,3);      % ��ȡ���ƺ�
    VideoFileName =[FolderPath,'video/',char(Temp_VideoName)];   % �õ���������Ƶ�ļ�·��
    Flag_Change_Random=unidrnd(2)-1; % ������� 0 �� 1 
    %% ���������Ϣ 
    if (Flag_Change_Random==1) % �ı���ʾ�ĳ�������
        CarCode_Mask_Middle=[ones(1,CarCode_Change_Num) zeros(1,(5-CarCode_Change_Num))];
        CarCode_Mask_Middle_Size = length(CarCode_Mask_Middle);
        CarCode_Mask_Middle(randperm(CarCode_Mask_Middle_Size)) = CarCode_Mask_Middle(1:1:CarCode_Mask_Middle_Size);
        CarCode_Mask=[0 CarCode_Mask_Middle 0];
        Text_Offset_Random=randperm(CarCode_Char_Offset);
        CarCode_Text_Offset_SQ=[0 Text_Offset_Random(1:5) 0];
        CarCode_Text_Offset=CarCode_Text_Offset_SQ.*CarCode_Mask;
        Temp_CarCode_Char=char(Temp_CarCode);
        for CarChange_Index=1:7
            Temp_Text=[];
            Temp_Text(1,1)=Temp_CarCode_Char(CarChange_Index)+CarCode_Text_Offset(CarChange_Index);
            Temp_Text(1,2)=Temp_CarCode_Char(CarChange_Index)-CarCode_Text_Offset(CarChange_Index);
            Temp_Text(1,3)=Temp_CarCode_Char(CarChange_Index)+floor(mod(CarCode_Text_Offset(CarChange_Index),5)+1);
            Temp_Text(1,4)=Temp_CarCode_Char(CarChange_Index)-floor(mod(CarCode_Text_Offset(CarChange_Index),5)+1);
            for i=1:length(Temp_Text)
                if((Temp_Text(1,i)>=65 & Temp_Text(1,i)<=90)|(Temp_Text(1,i)>=97 & Temp_Text(1,i)<=122)|(Temp_Text(1,i)>=48 & Temp_Text(1,i)<=57))
                    Temp_CarCode_Char(CarChange_Index)=Temp_Text(1,i);
                    break % ���ѭ�� ����������������� ������ѭ��
                end
            end
        end
        Display_CarCode=Temp_CarCode_Char;
    else % ���ı���ʾ�ĳ�������
        Display_CarCode=Temp_CarCode;
    end
    % ��ʾ ��ӡ
    disp(['-->ԭʼ���ƣ�',char(Temp_CarCode),'�Ƿ�ı䣺',num2str(Flag_Change_Random),' ( 1 �ı� 0 ���ı�)'])
    disp(['-->�ı���ƣ�',char(Display_CarCode)])
    %% ��ʾ���� �� ������Ƶ
    if(PTB_Flag==1)
        %% ��ʾ����
        Screen('DrawTexture', window ,PTB_IMG_Wait_5s); % �ȴ�5���ӵ�ͼƬ
        Screen('Flip',window);  % ������ʾ
        WaitSecs(1); % ��Ļ�ȴ�ʱ��
        %% ��ʾ����
        DrawFormattedText(window, double('��۲����г��ƺ�:'), 'center', screenYpixels * (2/7), Color_white); % ��ʾ����
        DrawFormattedText(window, double(char(Display_CarCode)), 'center', screenYpixels * (4/7), Color_white); % ��ʾ����
        Screen('Flip',window);
        WaitSecs(3);
        %% ��ʾ��λ
        Screen('DrawTexture', window ,PTB_IMG_TargetArea);
        Screen('Flip',window);
        WaitSecs(1);
        %% ��Ƶ����
        [ssss] = Screen('OpenMovie', window,VideoFileName);
        Screen('PlayMovie',ssss, 1);
        while (1) % ��֡������Ƶ
            tex = Screen('GetMovieImage', window, ssss); % ���һ֡��Ƶͼ��
            if tex<=0 %�ж���Ƶ�Ƿ��Ѿ���ȡ��
                break
            end
            %���»���
            Screen('DrawTexture', window, tex);% ����ͼ��
            Screen('Flip', window);% ������ʾ
            Screen('Close', tex);% �ͷ���Ƶ��Դ
        end
    end
    %% ѡ���
    if(PTB_Flag==1)
        DrawFormattedText(window, double('��ʹ�ü�������\nY (һ��) / N (��һ��)'), 'center', 'center', Color_white); % window,����,X���꣬Y���꣬��ɫ
        Screen('Flip', window);% ������ʾ
    end
    %��������
    keyIsDown=0;
    [keyIsDown, ~, keyCode, ~]=KbCheck;
    while(keyIsDown==0)
        [keyIsDown, ~, keyCode, ~]=KbCheck;
    end
    % Y 89  N 78 �ж�ѡ���Ƿ���ȷ
    if(Flag_Change_Random==1)
        if (keyCode(1,78)==1)
            Temp_Anwser=1;
        else
            Temp_Anwser=0;
        end
    else
        if (keyCode(1,89)==1)
            Temp_Anwser=1;
        else
            Temp_Anwser=0;
        end
    end
    keyCode(1,78)=0;    % ����
    keyCode(1,89)=0;    % ����
    keyIsDown=0;        % ����
    disp(['-->��',num2str(Main_Index),'��ѡ���û��ش���ȷ���: ',num2str(Temp_Anwser),'( 1 ��ȷ 0 ����)'])
    %% ��¼����
    OutPut_Cell(Main_Index,1)=num2cell(Main_Index);   %��¼���
    OutPut_Cell(Main_Index,2)=Temp_Number;   %��¼ԭʼ���
    OutPut_Cell(Main_Index,3)=Temp_VideoName;%��¼��Ƶ�ļ���
    OutPut_Cell(Main_Index,4)=Temp_CarCode;  %��¼���ƺ�
    OutPut_Cell(Main_Index,5)=num2cell(Temp_Anwser); %��¼�ش�����
end
%% �����ʺ�
if(PTB_Flag==1)
    DrawFormattedText(window, [double('��л���뱾�β���'),double('\n���β��Ե��˽�����'),double('\nлл��ף����죡')], 'center', 'center', Color_white);
    Screen('Flip', window);% ������ʾ
    WaitSecs(5);
    sca % �ر���Ļ
end
%% ��¼�� Excel �ļ�
OutPut_Cell
xlswrite(Excel_OUTPUT_FileName, {'���','ԭʼDATA���','��Ƶ�ļ���','���ƺ�','�ش�����(1Ϊ��ȷ,0Ϊ����)'}, VolunteerName, 'A1:E1')
xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName, ['A',num2str(Excel_Start),':','E',num2str(Excel_End)])
%xlswrite(Excel_OUTPUT_FileName, OutPut_Cell, VolunteerName)