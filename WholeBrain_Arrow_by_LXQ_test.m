%  此程序主体部分由陆新泉完成，有相关疑问敬请联系
%  此为全脑分析程序
%  因实验数据情况，目前仅处理arrow条件

%%
clear all
clc
%%
mx=58;
my=40;
mz=46;
%% run的数量由第一天和第二天所做实验共同组成，不同被试不同，需要回到文件夹具体按被试具体分析
for run=1:8
    TV_BV{run}=zeros(1,mx,my,mz);
    TV_BN{run}=zeros(1,mx,my,mz);
    TV_BIV{run}=zeros(1,mx,my,mz);
    TN_BV{run}=zeros(1,mx,my,mz);
    TN_BN{run}=zeros(1,mx,my,mz);
    TN_BIV{run}=zeros(1,mx,my,mz);
    TIV_BV{run}=zeros(1,mx,my,mz);
    TIV_BN{run}=zeros(1,mx,my,mz);
    TIV_BIV{run}=zeros(1,mx,my,mz);
end
%%  按不同先后次序分开进行分析
for sequence=1:2
    %% TD先BU后
    if sequence == 1  
        filename = ['E:\Watering\test\HeQionghua[arrow only]\arrow\1'];
        eval (['cd ' filename]);
        
        %  进入第一天不同的run处理
        for run=1:4 
            filename = ['TB_RT_MRI_Arrow_HQH_' int2str(run) '_30_1.mat'];
            load(filename);
            
            %  分析vtc文件
            ename=sprintf('Run%d_3DMCT_LTR_THPFFT0.0150Hz_TAL.vtc',run);
            etemp=BVQXfile(ename);
            detemp=etemp.VTCData;
            detemp=double(detemp)/255;
            
            for x=1:mx
                tic
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
                        %%  进入不同TD和BU组合条件下进行分析
                       Bold_Baseline=mean(detemp(1:2,x,y,z));
                        for trail=1:72
                            switch result(2,trail)
                                case 1   %  TD有效，BU有效
                                    a1=a1+1;
                                    TR_a1(a1)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                    Data_TV_BV_1(a1,:)=detemp(TR_a1(a1):TR_a1(a1)+7,x,y,z);
                                    
                                case 2  %  TD有效，BU中性
                                    a2=a2+1;
                                    TR_a2(a2)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                    Data_TV_BN_1(a2,:)=detemp(TR_a2(a2):TR_a2(a2)+7,x,y,z);
                                    
                                case 3  %  TD有效，BU无效
                                   a3=a3+1;
                                    TR_a3(a3)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                    Data_TV_BIV_1(a3,:)=detemp(TR_a3(a3):TR_a3(a3)+7,x,y,z);
                                    
                                case 4  %  TD中性，BU有效
                                    a4=a4+1;
                                    TR_a4(a4)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                    Data_TN_BV_1(a4,:)=detemp(TR_a4(a4):TR_a4(a4)+7,x,y,z);
                                    
                                case 5  %  TD中性，BU中性
                                    a5=a5+1;
                                    TR_a5(a5)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                    Data_TN_BN_1(a5,:)=detemp(TR_a5(a5):TR_a5(a5)+7,x,y,z);
                                    
                                case 6  %  TD中性，BU无效
                                    a6=a6+1;
                                    TR_a6(a6)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                    Data_TN_BIV_1(a6,:)=detemp(TR_a6(a6):TR_a6(a6)+7,x,y,z);
                                    
                                case 7  %  TD无效，BU有效
                                    a7=a7+1;
                                    TR_a7(a7)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                   Data_TIV_BV_1(a7,:)=detemp(TR_a7(a7):TR_a7(a7)+7,x,y,z);
                                    
                                case 8  %  TD无效，BU中性
                                    a8=a8+1;
                                    TR_a8(a8)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                    Data_TIV_BN_1(a8,:)=detemp(TR_a8(a8):TR_a8(a8)+7,x,y,z);
                                    
                                case 9  %  TD无效，BU无效
                                    a9=a9+1;
                                    TR_a9(a9)=trail+sum(result(8,1:trail-1),2)+2;
                               
                                    Data_TIV_BIV_1(a9,:)=detemp(TR_a9(a9):TR_a9(a9)+7,x,y,z);
                            end
                        end
                        %%  对上述9个条件下的不同trail求平均，得到平均下的8个TR里的BOLD信号
                        Bold_TR8_TV_BV_1 = mean(Data_TV_BV_1);
                        Bold_TR8_TV_BN_1 = mean(Data_TV_BN_1);
                        Bold_TR8_TV_BIV_1 = mean(Data_TV_BIV_1);
                        Bold_TR8_TN_BV_1 = mean(Data_TN_BV_1);
                        Bold_TR8_TN_BN_1 = mean(Data_TN_BN_1);
                        Bold_TR8_TN_BIV_1 = mean(Data_TN_BIV_1);
                        Bold_TR8_TIV_BV_1 = mean(Data_TIV_BV_1);
                        Bold_TR8_TIV_BN_1 = mean(Data_TIV_BN_1);
                        Bold_TR8_TIV_BIV_1 = mean(Data_TIV_BIV_1);
                        %% 在8个TR里计算BOLD信号变化
                        for j=1:8
                            Bold_TR8_Change_TV_BV_1(j) = (Bold_TR8_TV_BV_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                            Bold_TR8_Change_TV_BN_1(j) = (Bold_TR8_TV_BN_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                            Bold_TR8_Change_TV_BIV_1(j) = (Bold_TR8_TV_BIV_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                            Bold_TR8_Change_TN_BV_1(j) = (Bold_TR8_TN_BV_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                            Bold_TR8_Change_TN_BN_1(j) = (Bold_TR8_TN_BN_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                            Bold_TR8_Change_TN_BIV_1(j) = (Bold_TR8_TN_BIV_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                            Bold_TR8_Change_TIV_BV_1(j) = (Bold_TR8_TIV_BV_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                            Bold_TR8_Change_TIV_BN_1(j) = (Bold_TR8_TIV_BN_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                            Bold_TR8_Change_TIV_BIV_1(j) = (Bold_TR8_TIV_BIV_1(j) - Bold_Baseline) / Bold_Baseline * 100;
                        end
                    end
                 end
            end
        end
    end
    
    %%  第二天的数据分析
    if sequence == 2  %进入第二天的数据文件夹进行处理
        filename = ['E:\Watering\test\HeQionghua[arrow only]\arrow\2'];
        eval (['cd ' filename]);
        %  进入第二天不同的run处理
        for run=5:8
            filename = ['TB_RT_MRI_Arrow_HQH_' int2str(run-4) '_30_2.mat'];
            load(filename);
        end
    end