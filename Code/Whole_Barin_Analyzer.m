%  此程序主体部分由陆新泉完成，有相关疑问敬请联系

%  此为全脑分析程序
%  处理arrow条件
%  剔除错误试次

%  运行环境 MATLAB R2021a
%  最新更新时间 2022-06-02
%%
clear
clc
%%  进度条设置 此语句需要安装progressbar所在工具包
%progressbar('总进度','被试进度','run进度');
%%
filename = 'E:\TD & BU attention\test';
cd (filename)
sub = dir (filename);
N_sub = length(sub) - 2;
%% 初始化数据
for i = 1:N_sub
    fMRI1=dir([filename,'\',sub(i+2).name,'\1\','*.vtc']);
    Behav1 = dir([filename,'\',sub(i+2).name,'\1\','*.mat']);
    fMRI2=dir([filename,'\',sub(i+2).name,'\2\','*.vtc']);
    
    %此语句用于修正超过10个run的数据排序
    %[~,index] = sortrows({fMRI2.date}.'); fMRI2 = fMRI2(index); clear index
    
    Behav2 = dir([filename,'\',sub(i+2).name,'\2\','*.mat']);
    
    run1 = length(Behav1);
    run2 = length(Behav2);
    RUN = run1+run2;
    
    mx = 58;
    my = 40;
    mz = 46;
    
    %% 第一个条件下的数据分析
    for run = 1:run1
        
        TV_BV{run}=zeros(mx,my,mz);
        TV_BN{run}=zeros(mx,my,mz);
        TV_BIV{run}=zeros(mx,my,mz);
        TN_BV{run}=zeros(mx,my,mz);
        TN_BN{run}=zeros(mx,my,mz);
        TN_BIV{run}=zeros(mx,my,mz);
        TIV_BV{run}=zeros(mx,my,mz);
        TIV_BN{run}=zeros(mx,my,mz);
        TIV_BIV{run}=zeros(mx,my,mz);
        
        load([filename,'\',sub(i+2).name,'\1\',Behav1(run).name]);
        
        ename = [filename,'\',sub(i+2).name,'\1\',fMRI1(run).name];
        etemp=BVQXfile(ename);
        detemp=etemp.VTCData;
        detemp=double(detemp)/255.0;
        
        for x=1:mx
            for y=1:my
                for z=1:mz
                    %%  初始化计数
                    a1=0;   %  TD有效，BU有效
                    a2=0;   %  TD有效，BU中性
                    a3=0;   %  TD有效，BU无效
                    a4=0;   %  TD中性，BU有效
                    a5=0;   %  TD中性，BU中性
                    a6=0;   %  TD中性，BU无效
                    a7=0;   %  TD无效，BU有效
                    a8=0;   %  TD无效，BU中性
                    a9=0;   %  TD无效，BU无效
                    %%  初始化
                    Data_TV_BV = zeros(1,7);
                    Data_TV_BN = zeros(1,7);
                    Data_TV_BIV = zeros(1,7);
                    Data_TN_BV = zeros(1,7);
                    Data_TN_BN = zeros(1,7);
                    Data_TN_BIV = zeros(1,7);
                    Data_TIV_BV = zeros(1,7);
                    Data_TIV_BN = zeros(1,7);
                    Data_TIV_BIV = zeros(1,7);
                    %%  进入不同TD和BU组合条件下进行分析
                    Bold_Baseline=mean(detemp(1:152,x,y,z)); %  以所有TR的平均值作为baseline
                    for trail=1:72
                        switch result(2,trail)
                            case 1   %  TD有效，BU有效
                                if result(6,trail) == 1  %  剔除错误试次
                                    a1=a1+1;
                                    TR_a1(a1)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TV_BV=Data_TV_BV+detemp(TR_a1(a1):TR_a1(a1)+6,x,y,z);
                                end
                                
                            case 2  %  TD有效，BU中性
                                if result(6,trail) == 1
                                    a2=a2+1;
                                    TR_a2(a2)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TV_BN=Data_TV_BN+detemp(TR_a2(a2):TR_a2(a2)+6,x,y,z);
                                end
                            case 3  %  TD有效，BU无效
                                if result(6,trail) == 1
                                    a3=a3+1;
                                    TR_a3(a3)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TV_BIV=Data_TV_BIV+detemp(TR_a3(a3):TR_a3(a3)+6,x,y,z);
                                end
                            case 4  %  TD中性，BU有效
                                if result(6,trail) == 1
                                    a4=a4+1;
                                    TR_a4(a4)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TN_BV=Data_TN_BV+detemp(TR_a4(a4):TR_a4(a4)+6,x,y,z);
                                end
                            case 5  %  TD中性，BU中性
                                if result(6,trail) == 1
                                    a5=a5+1;
                                    TR_a5(a5)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TN_BN=Data_TN_BN+detemp(TR_a5(a5):TR_a5(a5)+6,x,y,z);
                                end
                            case 6  %  TD中性，BU无效
                                if result(6,trail) == 1
                                    a6=a6+1;
                                    TR_a6(a6)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TN_BIV=Data_TN_BIV+detemp(TR_a6(a6):TR_a6(a6)+6,x,y,z);
                                end
                            case 7  %  TD无效，BU有效
                                if result(6,trail) == 1
                                    a7=a7+1;
                                    TR_a7(a7)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TIV_BV=Data_TIV_BV+detemp(TR_a7(a7):TR_a7(a7)+6,x,y,z);
                                end
                            case 8  %  TD无效，BU中性
                                if result(6,trail) == 1
                                    a8=a8+1;
                                    TR_a8(a8)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TIV_BN=Data_TIV_BN+detemp(TR_a8(a8):TR_a8(a8)+6,x,y,z);
                                end
                            case 9  %  TD无效，BU无效
                                if result(6,trail) == 1
                                    a9=a9+1;
                                    TR_a9(a9)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TIV_BIV=Data_TIV_BIV+detemp(TR_a9(a9):TR_a9(a9)+6,x,y,z);
                                end
                        end
                    end
                    %%  对上述9个条件下的不同trail求平均，得到平均下的7个TR里的BOLD信号
                    Bold_TR7_TV_BV = Data_TV_BV / a1;
                    Bold_TR7_TV_BN = Data_TV_BN / a2;
                    Bold_TR7_TV_BIV = Data_TV_BIV / a3;
                    Bold_TR7_TN_BV = Data_TN_BV / a4;
                    Bold_TR7_TN_BN = Data_TN_BN / a5;
                    Bold_TR7_TN_BIV = Data_TN_BIV / a6;
                    Bold_TR7_TIV_BV = Data_TIV_BV / a7;
                    Bold_TR7_TIV_BN = Data_TIV_BN / a8;
                    Bold_TR7_TIV_BIV = Data_TIV_BIV / a9;
                    %% 在7个TR里计算BOLD信号变化
                    for j=1:7
                        if Bold_Baseline ~= 0
                            Bold_TR7_Change_TV_BV(j) = (Bold_TR7_TV_BV(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TV_BN(j) = (Bold_TR7_TV_BN(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TV_BIV(j) = (Bold_TR7_TV_BIV(j) / Bold_Baseline -1) * 100;
                            Bold_TR7_Change_TN_BV(j) = (Bold_TR7_TN_BV(j)  / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TN_BN(j) = (Bold_TR7_TN_BN(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TN_BIV(j) = (Bold_TR7_TN_BIV(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TIV_BV(j) = (Bold_TR7_TIV_BV(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TIV_BN(j) = (Bold_TR7_TIV_BN(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TIV_BIV(j) = (Bold_TR7_TIV_BIV(j) / Bold_Baseline - 1) * 100;
                        else
                            Bold_TR7_Change_TV_BV(j) = 0;
                            Bold_TR7_Change_TV_BN(j) = 0;
                            Bold_TR7_Change_TV_BIV(j) = 0;
                            Bold_TR7_Change_TN_BV(j) = 0;
                            Bold_TR7_Change_TN_BN(j) = 0;
                            Bold_TR7_Change_TN_BIV(j) = 0;
                            Bold_TR7_Change_TIV_BV(j) = 0;
                            Bold_TR7_Change_TIV_BN(j) =  0;
                            Bold_TR7_Change_TIV_BIV(j) = 0;
                        end
                    end
                    %% 以第4个、第5个TR的平均值作为此trail的bold信号
                    TV_BV{run}(x,y,z)=(Bold_TR7_Change_TV_BV(4) + Bold_TR7_Change_TV_BV(5)) / 2;
                    TV_BN{run}(x,y,z)=(Bold_TR7_Change_TV_BN(4) + Bold_TR7_Change_TV_BN(5)) / 2;
                    TV_BIV{run}(x,y,z)=(Bold_TR7_Change_TV_BIV(4) + Bold_TR7_Change_TV_BIV(5)) / 2;
                    TN_BV{run}(x,y,z)=(Bold_TR7_Change_TN_BV(4) + Bold_TR7_Change_TN_BV(5)) / 2;
                    TN_BN{run}(x,y,z)=(Bold_TR7_Change_TN_BN(4) + Bold_TR7_Change_TN_BN(5)) / 2;
                    TN_BIV{run}(x,y,z)=(Bold_TR7_Change_TN_BIV(4) + Bold_TR7_Change_TN_BIV(5)) / 2;
                    TIV_BV{run}(x,y,z)=(Bold_TR7_Change_TIV_BV(4) + Bold_TR7_Change_TIV_BV(5)) / 2;
                    TIV_BN{run}(x,y,z)=(Bold_TR7_Change_TIV_BN(4) + Bold_TR7_Change_TIV_BN(5)) / 2;
                    TIV_BIV{run}(x,y,z)=(Bold_TR7_Change_TIV_BIV(4) + Bold_TR7_Change_TIV_BIV(5)) / 2;
                end
            end
            frac3 = x/58;
            frac2 = ((run-1)+frac3) / RUN;
            frac1 = ((i-1) + frac2) / N_sub;
            progressbar(frac1,frac2, frac3);
        end
    end
    %% 第二个条件下
    for run = run1+1 : RUN
        
        TV_BV{run}=zeros(mx,my,mz);
        TV_BN{run}=zeros(mx,my,mz);
        TV_BIV{run}=zeros(mx,my,mz);
        TN_BV{run}=zeros(mx,my,mz);
        TN_BN{run}=zeros(mx,my,mz);
        TN_BIV{run}=zeros(mx,my,mz);
        TIV_BV{run}=zeros(mx,my,mz);
        TIV_BN{run}=zeros(mx,my,mz);
        TIV_BIV{run}=zeros(mx,my,mz);
        
        load([filename,'\',sub(i+2).name,'\2\',Behav2(run-run1).name]);
        
        ename = [filename,'\',sub(i+2).name,'\2\',fMRI2(run-run1).name];
        etemp=BVQXfile(ename);
        detemp=etemp.VTCData;
        detemp=double(detemp)/255.0;
        
        for x=1:mx
            for y=1:my
                for z=1:mz
                    %%  初始化计数
                    a1=0;   %  TD有效，BU有效
                    a2=0;   %  TD有效，BU中性
                    a3=0;   %  TD有效，BU无效
                    a4=0;   %  TD中性，BU有效
                    a5=0;   %  TD中性，BU中性
                    a6=0;   %  TD中性，BU无效
                    a7=0;   %  TD无效，BU有效
                    a8=0;   %  TD无效，BU中性
                    a9=0;   %  TD无效，BU无效
                    %%  初始化
                    Data_TV_BV = zeros(1,7);
                    Data_TV_BN = zeros(1,7);
                    Data_TV_BIV = zeros(1,7);
                    Data_TN_BV = zeros(1,7);
                    Data_TN_BN = zeros(1,7);
                    Data_TN_BIV = zeros(1,7);
                    Data_TIV_BV = zeros(1,7);
                    Data_TIV_BN = zeros(1,7);
                    Data_TIV_BIV = zeros(1,7);
                    %%  进入不同TD和BU组合条件下进行分析
                    Bold_Baseline=mean(detemp(1:152,x,y,z)); %  以所有TR的平均值作为baseline
                    for trail=1:72
                        switch result(2,trail)
                            case 1   %  TD有效，BU有效
                                if result(6,trail) == 1  %  剔除错误试次
                                    a1=a1+1;
                                    TR_a1(a1)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TV_BV=Data_TV_BV+detemp(TR_a1(a1):TR_a1(a1)+6,x,y,z);
                                end
                                
                            case 2  %  TD有效，BU中性
                                if result(6,trail) == 1
                                    a2=a2+1;
                                    TR_a2(a2)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TV_BN=Data_TV_BN+detemp(TR_a2(a2):TR_a2(a2)+6,x,y,z);
                                end
                            case 3  %  TD有效，BU无效
                                if result(6,trail) == 1
                                    a3=a3+1;
                                    TR_a3(a3)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TV_BIV=Data_TV_BIV+detemp(TR_a3(a3):TR_a3(a3)+6,x,y,z);
                                end
                            case 4  %  TD中性，BU有效
                                if result(6,trail) == 1
                                    a4=a4+1;
                                    TR_a4(a4)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TN_BV=Data_TN_BV+detemp(TR_a4(a4):TR_a4(a4)+6,x,y,z);
                                end
                            case 5  %  TD中性，BU中性
                                if result(6,trail) == 1
                                    a5=a5+1;
                                    TR_a5(a5)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TN_BN=Data_TN_BN+detemp(TR_a5(a5):TR_a5(a5)+6,x,y,z);
                                end
                            case 6  %  TD中性，BU无效
                                if result(6,trail) == 1
                                    a6=a6+1;
                                    TR_a6(a6)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TN_BIV=Data_TN_BIV+detemp(TR_a6(a6):TR_a6(a6)+6,x,y,z);
                                end
                            case 7  %  TD无效，BU有效
                                if result(6,trail) == 1
                                    a7=a7+1;
                                    TR_a7(a7)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TIV_BV=Data_TIV_BV+detemp(TR_a7(a7):TR_a7(a7)+6,x,y,z);
                                end
                            case 8  %  TD无效，BU中性
                                if result(6,trail) == 1
                                    a8=a8+1;
                                    TR_a8(a8)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TIV_BN=Data_TIV_BN+detemp(TR_a8(a8):TR_a8(a8)+6,x,y,z);
                                end
                            case 9  %  TD无效，BU无效
                                if result(6,trail) == 1
                                    a9=a9+1;
                                    TR_a9(a9)=trail+sum(result(8,1:trail-1),2)+2;
                                    
                                    Data_TIV_BIV=Data_TIV_BIV+detemp(TR_a9(a9):TR_a9(a9)+6,x,y,z);
                                end
                        end
                    end
                    %%  对上述9个条件下的不同trail求平均，得到平均下的7个TR里的BOLD信号
                    Bold_TR7_TV_BV = Data_TV_BV / a1;
                    Bold_TR7_TV_BN = Data_TV_BN / a2;
                    Bold_TR7_TV_BIV = Data_TV_BIV / a3;
                    Bold_TR7_TN_BV = Data_TN_BV / a4;
                    Bold_TR7_TN_BN = Data_TN_BN / a5;
                    Bold_TR7_TN_BIV = Data_TN_BIV / a6;
                    Bold_TR7_TIV_BV = Data_TIV_BV / a7;
                    Bold_TR7_TIV_BN = Data_TIV_BN / a8;
                    Bold_TR7_TIV_BIV = Data_TIV_BIV / a9;
                    %% 在7个TR里计算BOLD信号变化
                    for j=1:7
                        if Bold_Baseline ~= 0
                            Bold_TR7_Change_TV_BV(j) = (Bold_TR7_TV_BV(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TV_BN(j) = (Bold_TR7_TV_BN(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TV_BIV(j) = (Bold_TR7_TV_BIV(j) / Bold_Baseline -1) * 100;
                            Bold_TR7_Change_TN_BV(j) = (Bold_TR7_TN_BV(j)  / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TN_BN(j) = (Bold_TR7_TN_BN(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TN_BIV(j) = (Bold_TR7_TN_BIV(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TIV_BV(j) = (Bold_TR7_TIV_BV(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TIV_BN(j) = (Bold_TR7_TIV_BN(j) / Bold_Baseline - 1) * 100;
                            Bold_TR7_Change_TIV_BIV(j) = (Bold_TR7_TIV_BIV(j) / Bold_Baseline - 1) * 100;
                        else
                            Bold_TR7_Change_TV_BV(j) = 0;
                            Bold_TR7_Change_TV_BN(j) = 0;
                            Bold_TR7_Change_TV_BIV(j) = 0;
                            Bold_TR7_Change_TN_BV(j) = 0;
                            Bold_TR7_Change_TN_BN(j) = 0;
                            Bold_TR7_Change_TN_BIV(j) = 0;
                            Bold_TR7_Change_TIV_BV(j) = 0;
                            Bold_TR7_Change_TIV_BN(j) =  0;
                            Bold_TR7_Change_TIV_BIV(j) = 0;
                        end
                    end
                    %% 以第4个、第5个TR的平均值作为此trail的bold信号
                    TV_BV{run}(x,y,z)=(Bold_TR7_Change_TV_BV(4) + Bold_TR7_Change_TV_BV(5)) / 2;
                    TV_BN{run}(x,y,z)=(Bold_TR7_Change_TV_BN(4) + Bold_TR7_Change_TV_BN(5)) / 2;
                    TV_BIV{run}(x,y,z)=(Bold_TR7_Change_TV_BIV(4) + Bold_TR7_Change_TV_BIV(5)) / 2;
                    TN_BV{run}(x,y,z)=(Bold_TR7_Change_TN_BV(4) + Bold_TR7_Change_TN_BV(5)) / 2;
                    TN_BN{run}(x,y,z)=(Bold_TR7_Change_TN_BN(4) + Bold_TR7_Change_TN_BN(5)) / 2;
                    TN_BIV{run}(x,y,z)=(Bold_TR7_Change_TN_BIV(4) + Bold_TR7_Change_TN_BIV(5)) / 2;
                    TIV_BV{run}(x,y,z)=(Bold_TR7_Change_TIV_BV(4) + Bold_TR7_Change_TIV_BV(5)) / 2;
                    TIV_BN{run}(x,y,z)=(Bold_TR7_Change_TIV_BN(4) + Bold_TR7_Change_TIV_BN(5)) / 2;
                    TIV_BIV{run}(x,y,z)=(Bold_TR7_Change_TIV_BIV(4) + Bold_TR7_Change_TIV_BIV(5)) / 2;
                end
            end
            frac3 = x/58;
            frac2 = ((run-1)+frac3) / RUN;
            frac1 = ((i-1) + frac2) / N_sub;
            progressbar(frac1,frac2, frac3);
        end
    end
    TD_Valid_BU_Valid = TV_BV{1};
    TD_Valid_BU_Neutral = TV_BN{1};
    TD_Valid_BU_Invalid = TV_BIV{1};
    TD_Neutral_BU_Valid = TN_BV{1};
    TD_Neutral_BU_Neutral = TN_BN{1};
    TD_Neutral_BU_Invalid = TN_BIV{1};
    TD_Invalid_BU_Valid = TIV_BV{1};
    TD_Invalid_BU_Neutral = TIV_BN{1};
    TD_Invalid_BU_Invalid = TIV_BIV{1};
    for j = 2 : RUN
        TD_Valid_BU_Valid =TD_Valid_BU_Valid + TV_BV{j};
        TD_Valid_BU_Neutral = TD_Valid_BU_Neutral + TV_BN{j};
        TD_Valid_BU_Invalid = TD_Valid_BU_Invalid + TV_BIV{j};
        TD_Neutral_BU_Valid = TD_Neutral_BU_Valid + TN_BV{j};
        TD_Neutral_BU_Neutral = TD_Neutral_BU_Neutral + TN_BN{j};
        TD_Neutral_BU_Invalid = TD_Neutral_BU_Invalid + TN_BIV{j};
        TD_Invalid_BU_Valid = TD_Invalid_BU_Valid + TIV_BV{j};
        TD_Invalid_BU_Neutral = TD_Invalid_BU_Neutral + TIV_BN{j};
        TD_Invalid_BU_Invalid = TD_Invalid_BU_Invalid + TIV_BIV{j};
    end
    TD_Valid_BU_Valid = TD_Valid_BU_Valid / RUN;
    TD_Valid_BU_Neutral = TD_Valid_BU_Neutral / RUN;
    TD_Valid_BU_Invalid = TD_Valid_BU_Invalid / RUN;
    TD_Neutral_BU_Valid = TD_Neutral_BU_Valid / RUN;
    TD_Neutral_BU_Neutral = TD_Neutral_BU_Neutral / RUN;
    TD_Neutral_BU_Invalid = TD_Neutral_BU_Invalid / RUN;
    TD_Invalid_BU_Valid = TD_Invalid_BU_Valid / RUN;
    TD_Invalid_BU_Neutral = TD_Invalid_BU_Neutral / RUN;
    TD_Invalid_BU_Invalid = TD_Invalid_BU_Invalid / RUN;
    
    %% 储存数据
    save ( [sub(i+2).name, '.mat'], 'TD_Valid_BU_Valid', 'TD_Valid_BU_Neutral', ...
        'TD_Valid_BU_Invalid', 'TD_Neutral_BU_Valid', 'TD_Neutral_BU_Neutral',...
        'TD_Neutral_BU_Invalid', 'TD_Invalid_BU_Valid', 'TD_Invalid_BU_Neutral',...
        'TD_Invalid_BU_Invalid');
end
