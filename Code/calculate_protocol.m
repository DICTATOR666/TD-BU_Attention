%%
%   此为计算protocol的代码
%   作者：陆新泉

%   更新时间：2022.4.20
%   运行环境：R2021a
%%
clc
clear
%%
filename = 'E:\TD & BU attention\face_analysis_data';
cd (filename)
sub = dir (filename);
N_sub = length(sub) - 2;
%%
for i=1:N_sub
    Behav1 = dir([filename,'\',sub(i+2).name,'\1\','*.mat']);
    Behav2 = dir([filename,'\',sub(i+2).name,'\2\','*.mat']);
    run1 = length(Behav1);
    run2 = length(Behav2);
    RUN = run1+run2;
    
    for run=1:run1
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
        
        load([filename,'\',sub(i+2).name,'\1\',Behav1(run).name]);
        
        for trail=1:72
            switch result(2,trail)
                case 1   %  TD有效，BU有效
                    if result(6,trail) == 1  %  剔除错误试次
                        a1=a1+1;
                        TR_a1(a1)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                    
                case 2  %  TD有效，BU中性
                    if result(6,trail) == 1
                        a2=a2+1;
                        TR_a2(a2)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 3  %  TD有效，BU无效
                    if result(6,trail) == 1
                        a3=a3+1;
                        TR_a3(a3)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 4  %  TD中性，BU有效
                    if result(6,trail) == 1
                        a4=a4+1;
                        TR_a4(a4)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 5  %  TD中性，BU中性
                    if result(6,trail) == 1
                        a5=a5+1;
                        TR_a5(a5)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 6  %  TD中性，BU无效
                    if result(6,trail) == 1
                        a6=a6+1;
                        TR_a6(a6)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 7  %  TD无效，BU有效
                    if result(6,trail) == 1
                        a7=a7+1;
                        TR_a7(a7)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 8  %  TD无效，BU中性
                    if result(6,trail) == 1
                        a8=a8+1;
                        TR_a8(a8)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 9  %  TD无效，BU无效
                    if result(6,trail) == 1
                        a9=a9+1;
                        TR_a9(a9)=trail+sum(result(8,1:trail-1),2)+2;
                    end
            end
        end
        cd('E:\TD & BU attention\face_protocol');
        protocol = BVQXfile('sample_protocol.prt');
        
        protocol.Cond(1).NrOfOnOffsets = 1;
        protocol.Cond(1).OnOffsets=[1, 2];
        
        protocol.Cond(2).NrOfOnOffsets = a1;
        protocol.Cond(2).OnOffsets=[TR_a1', TR_a1'];
        
        protocol.Cond(3).NrOfOnOffsets = a2;
        protocol.Cond(3).OnOffsets=[TR_a2', TR_a2'];
        
        protocol.Cond(4).NrOfOnOffsets = a3;
        protocol.Cond(4).OnOffsets=[TR_a3', TR_a3'];
        
        protocol.Cond(5).NrOfOnOffsets = a4;
        protocol.Cond(5).OnOffsets=[TR_a4', TR_a4'];
        
        protocol.Cond(6).NrOfOnOffsets = a5;
        protocol.Cond(6).OnOffsets=[TR_a5', TR_a5'];
        
        protocol.Cond(7).NrOfOnOffsets = a6;
        protocol.Cond(7).OnOffsets=[TR_a6', TR_a6'];
        
        protocol.Cond(8).NrOfOnOffsets = a7;
        protocol.Cond(8).OnOffsets=[TR_a7', TR_a7'];
        
        protocol.Cond(9).NrOfOnOffsets = a8;
        protocol.Cond(9).OnOffsets=[TR_a8', TR_a8'];
        
        protocol.Cond(10).NrOfOnOffsets = a9;
        protocol.Cond(10).OnOffsets=[TR_a9', TR_a9'];
        
        cd(['E:\TD & BU attention\face_protocol\', sub(i+2).name]);
        protocol.SaveAs([int2str(run), '.prt'], protocol);
        
        clear TR_a1
        clear TR_a2
        clear TR_a3
        clear TR_a4
        clear TR_a5
        clear TR_a6
        clear TR_a7
        clear TR_a8
        clear TR_a9
    end
    
    for run=run1+1:RUN
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
        
        load([filename,'\',sub(i+2).name,'\2\',Behav2(run-run1).name]);
        
        for trail=1:72
            switch result(2,trail)
                case 1   %  TD有效，BU有效
                    if result(6,trail) == 1  %  剔除错误试次
                        a1=a1+1;
                        TR_a1(a1)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                    
                case 2  %  TD有效，BU中性
                    if result(6,trail) == 1
                        a2=a2+1;
                        TR_a2(a2)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 3  %  TD有效，BU无效
                    if result(6,trail) == 1
                        a3=a3+1;
                        TR_a3(a3)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 4  %  TD中性，BU有效
                    if result(6,trail) == 1
                        a4=a4+1;
                        TR_a4(a4)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 5  %  TD中性，BU中性
                    if result(6,trail) == 1
                        a5=a5+1;
                        TR_a5(a5)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 6  %  TD中性，BU无效
                    if result(6,trail) == 1
                        a6=a6+1;
                        TR_a6(a6)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 7  %  TD无效，BU有效
                    if result(6,trail) == 1
                        a7=a7+1;
                        TR_a7(a7)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 8  %  TD无效，BU中性
                    if result(6,trail) == 1
                        a8=a8+1;
                        TR_a8(a8)=trail+sum(result(8,1:trail-1),2)+2;
                    end
                case 9  %  TD无效，BU无效
                    if result(6,trail) == 1
                        a9=a9+1;
                        TR_a9(a9)=trail+sum(result(8,1:trail-1),2)+2;
                    end
            end
        end
        cd('E:\TD & BU attention\face_protocol');
        protocol = BVQXfile('sample_protocol.prt');
        
        protocol.Cond(1).NrOfOnOffsets = 1;
        protocol.Cond(1).OnOffsets=[1, 2];
        
        protocol.Cond(2).NrOfOnOffsets = a1;
        protocol.Cond(2).OnOffsets=[TR_a1', TR_a1'];
        
        protocol.Cond(3).NrOfOnOffsets = a2;
        protocol.Cond(3).OnOffsets=[TR_a2', TR_a2'];
        
        protocol.Cond(4).NrOfOnOffsets = a3;
        protocol.Cond(4).OnOffsets=[TR_a3', TR_a3'];
        
        protocol.Cond(5).NrOfOnOffsets = a4;
        protocol.Cond(5).OnOffsets=[TR_a4', TR_a4'];
        
        protocol.Cond(6).NrOfOnOffsets = a5;
        protocol.Cond(6).OnOffsets=[TR_a5', TR_a5'];
        
        protocol.Cond(7).NrOfOnOffsets = a6;
        protocol.Cond(7).OnOffsets=[TR_a6', TR_a6'];
        
        protocol.Cond(8).NrOfOnOffsets = a7;
        protocol.Cond(8).OnOffsets=[TR_a7', TR_a7'];
        
        protocol.Cond(9).NrOfOnOffsets = a8;
        protocol.Cond(9).OnOffsets=[TR_a8', TR_a8'];
        
        protocol.Cond(10).NrOfOnOffsets = a9;
        protocol.Cond(10).OnOffsets=[TR_a9', TR_a9'];
        
        cd(['E:\TD & BU attention\face_protocol\', sub(i+2).name]);
        protocol.SaveAs([int2str(run), '.prt'], protocol);
        
        clear TR_a1
        clear TR_a2
        clear TR_a3
        clear TR_a4
        clear TR_a5
        clear TR_a6
        clear TR_a7
        clear TR_a8
        clear TR_a9
    end
end
