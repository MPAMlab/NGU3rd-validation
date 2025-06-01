clc
clear
%本脚本用于计算NGU3rd赛场结果与用时
%目前为8队对轰，1队有3人
%以打到死为每轮（除决赛）

%一首歌用时，以分钟计
Song_Time = 3;
%扫码用时，以分钟计
Wait_Time = 1;
%每队初始血量
Blood =100;
%复活后血量
ReBlood = 20;

%每队各职业各一个
%矩盾手：
%绝剑士：
%炼星师：
RPG = ["绝剑士","矩盾手","炼星师"];
%Skill = [Attack_Plus,Defense,Restore];
%样本数量
battle_number = 1;%4
n = 1;
Number_pc = battle_number * n;
fprintf('打算进行%d次两队死斗\n',Number_pc)
%一些解释，T表临时
%T_Song_Score = randi([0,9],2,4);%双方一首歌的后四位数随机
%T_Team_Score = sum(T_Round_Score,2); %双方一首歌的后四位数相加
pc = 0;
%所有的小局数储存
Date_Small = zeros(1,Number_pc);
%所有的中局数储存
Date_Middle = zeros(1,Number_pc);
%所有的时间储存
Date_Time = zeros(1,Number_pc);

while 1
    pc = pc + 1;
    if pc > Number_pc
        break
    end
    fprintf('这里是第%d组两队的死斗\n',pc)
    %镜子次数
    A_M = 1;%初始化镜子次数
    B_M = 1;
    AM_flag = 0;%初始化标志
    BM_flag = 0;
    A_Blood = Blood;%A队的血量
    B_Blood = Blood;
    flag_end = 0;%最初的判断游戏结束逻辑
    Round_Middle = 0;
    disp('游戏开始')
    rpg_flag = 0;
    while 1
        Round_Middle = Round_Middle + 1;
        fprintf('\n')
        fprintf('\n')
        fprintf('现在是第%d中局\n',Round_Middle)
        Date_Middle(1,pc) = Round_Middle;%记录数据
        Round_Small = 0;
        if rpg_flag == 0
            A_RPG = randperm(3);%A队的上场顺序
            B_RPG = randperm(3);
            rpg_flag = 1;
        end

        
        disp('双方决定了上场顺序')
        fprintf('A队为')
        %fprintf('%d',A_RPG)
        fprintf('%s、%s、%s',RPG(A_RPG(1)),RPG(A_RPG(2)),RPG(A_RPG(3)))
        fprintf('\n')
        fprintf('B队为')
        %fprintf('%d',B_RPG)
        fprintf('%s、%s、%s',RPG(B_RPG(1)),RPG(B_RPG(2)),RPG(B_RPG(3)))
        fprintf('\n')
        while 1
            Round_Small = Round_Small + 1;
            Date_Small(1,pc) = Date_Small(1,pc) + 1;%记录数据
            fprintf('\n')
            fprintf('现在是第%d首歌(小局)\n',Round_Small)
            T_Song_Score = randi([1,10],2,4);%双方一首歌的后四位数随机
            T_Team_Score = sum(T_Song_Score,2);%双方一首歌的后四位数相加
            fprintf('A队本轮上场的为%s\n',RPG(A_RPG(Round_Small)))
            fprintf('B队本轮上场的为%s\n',RPG(B_RPG(Round_Small)))
            fprintf('A队的乐曲后四位为')
            fprintf('%d',T_Song_Score(1,:))
            fprintf('\n')
            %fprintf('A队的成绩为')
            %fprintf('%d',T_Team_Score(1))
            %fprintf('\n')
            fprintf('B队的乐曲后四位为')
            fprintf('%d',T_Song_Score(2,:))
            fprintf('\n')
            %fprintf('B队的成绩为')
            %fprintf('%d',T_Team_Score(2))
            %fprintf('\n')
            if A_RPG(Round_Small) == 1
                AP_Score = max(T_Song_Score(1,:));
                fprintf('A队绝剑士发动技能，追加最高的%d伤害\n',AP_Score)
                B_Blood = B_Blood - AP_Score;
            end
            if B_RPG(Round_Small) == 1
                BP_Score = max(T_Song_Score(2,:));
                fprintf('B队绝剑士发动技能，追加最高的%d伤害\n',BP_Score)
                A_Blood = A_Blood -BP_Score;
            end
            if A_RPG(Round_Small) == 2
                if B_RPG(Round_Small) == 1%若对面为绝剑士，则考虑追加伤害
                    AD_Score_t = randi([1,5],1,1);
                    if AD_Score_t == 5
                        AD_Score = BP_Score;
                    else
                        AD_Score = T_Song_Score(2,AD_Score_t);
                    end
                else%不考虑追加伤害
                    AD_Score_t = randi([1,4],1,1);
                    AD_Score = T_Song_Score(2,AD_Score_t);
                end
                fprintf('A队矩盾手发动技能，无效化第%d段的%d伤害\n',AD_Score_t,AD_Score)
                A_Blood = A_Blood + AD_Score;%直接提前回血相当于无效化
            end
            if B_RPG(Round_Small) == 2
                if A_RPG(Round_Small) == 1%若对面为绝剑士，则考虑追加伤害
                    BD_Score_t = randi([1,5],1,1);
                    if BD_Score_t == 5
                        BD_Score = AP_Score;
                    else
                        BD_Score = T_Song_Score(1,BD_Score_t);
                    end
                else%不考虑追加伤害
                    BD_Score_t = randi([1,4],1,1);
                    BD_Score = T_Song_Score(1,BD_Score_t);
                end
                fprintf('B队矩盾手发动技能，无效化第%d段的%d伤害\n',BD_Score_t,BD_Score)
                B_Blood = B_Blood + BD_Score;%直接提前回血相当于无效化
            end
            if A_RPG(Round_Small) == 3
                AR_Score = max(T_Song_Score(1,:));
                fprintf('A队炼星师发动技能，将己方输出的最高伤害无效化，储存%d的恢复血量，待最后回血\n',AR_Score)
                B_Blood = B_Blood + AR_Score;%直接提前回血相当于无效化
            end
            if B_RPG(Round_Small) == 3
                BR_Score = max(T_Song_Score(2,:));
                fprintf('B队炼星师发动技能，将己方的输出最高伤害无效化，储存%d的恢复血量，待最后回血\n',BR_Score)
                A_Blood = A_Blood + BR_Score;%直接提前回血相当于无效化
            end
            fprintf('开始计算血量')
            A_Blood = A_Blood - T_Team_Score(2);
            B_Blood = B_Blood - T_Team_Score(1);
            disp('当前双方血量')
            fprintf('A队有%d血\n',A_Blood)
            fprintf('B队有%d血\n',B_Blood)

            %计算完非回血后的血量后，开始判断是否触发折镜
            %在一方发动伤害折镜后，另一方需再判断是否触发，后者触发无需再判断对方是否触发
            fprintf('判断折镜\n')
            if A_Blood <=0 
                if A_M == 1
                    fprintf('A队触发折镜\n')
                    A_M=0;%棱镜被消耗
                    AM_flag = 1;%标志棱镜待触发
                end
            end
            if B_Blood <=0
                if B_M == 1
                    fprintf('B队触发折镜\n')
                    B_M=0;%棱镜被消耗
                    BM_flag = 1;%标志棱镜待触发
                end
            end
            if ((A_Blood > 0) && (B_Blood > 0))
                fprintf('无队伍触发折镜\n')
            end
            %三种触发折镜情况
            if ((AM_flag == 1)&&(BM_flag == 1))
                fprintf('本次双方同时触发折镜效果，战斗结算在死亡状态，故双方都直接重置为%d血。（后续会有炼星师阶段）',ReBlood)
                A_Blood = ReBlood;
                B_Blood = ReBlood;
                AM_flag = 0;%折镜已触发
                BM_flag = 0;%折镜已触发
            end

            if (AM_flag == 1)&&(BM_flag == 0)
                fprintf('本次A队单独触发折镜效果')
                AM_flag = 0;
                if A_RPG(Round_Small) == 1
                   fprintf('A队绝剑士发动折镜，额外增加死仇%d伤害\n',AP_Score)
                   B_Blood = B_Blood - AP_Score;
                   %AP_flag = 1;%本意是为了解决触发扳机问题，但是现在应该不需要了
                elseif A_RPG(Round_Small) == 2
                    APP_Score = abs(A_Blood);
                    fprintf('A队矩盾手发动折镜，反弹溢出的%d伤害\n',APP_Score)
                    B_Blood = B_Blood - APP_Score;
                elseif A_RPG(Round_Small) == 3
                    AR_Score = AR_Score + AR_Score;%多储存一次
                    fprintf('A队炼星师发动折镜，现在共储存%d的恢复血量，待最后回血\n',AR_Score)
                end
                fprintf('本次A队折镜效果计算完毕，血量恢复至固定值%d',ReBlood)
                A_Blood = ReBlood;
                if B_Blood <=0
                    if B_M == 1
                        fprintf('B队在受到A队折镜伤害后，后触发折镜效果')
                        B_M = 0;
                        if B_RPG(Round_Small) == 1
                           fprintf('B队绝剑士发动折镜，额外增加死仇%d伤害\n',BP_Score)
                           A_Blood = A_Blood - BP_Score;
                        elseif B_RPG(Round_Small) == 2
                            BPP_Score = abs(B_Blood);
                            fprintf('B队矩盾手发动折镜，反弹溢出的%d伤害\n',BPP_Score)
                            A_Blood = A_Blood - BPP_Score;
                        elseif B_RPG(Round_Small) == 3
                            BR_Score = BR_Score + BR_Score;
                            fprintf('B队炼星师发动折镜，现在共储存%d的恢复血量，待最后回血\n',BR_Score)
                        end
                        fprintf('本次B队折镜效果计算完毕，血量恢复至固定值%d',ReBlood)
                        B_Blood = ReBlood;
                        if A_Blood <= 0
                            fprintf('A队在受到B队折镜伤害后，血量降至濒死，且无折镜使用')
                        end
                    elseif B_M == 0
                        fprintf('B队在受到A队折镜伤害后，血量降至濒死，且无折镜使用')
                    end
                end
            end
            if (AM_flag == 0)&&(BM_flag == 1)
                fprintf('本次B队单独触发折镜效果')
                BM_flag = 0;
                if B_RPG(Round_Small) == 1
                   fprintf('B队绝剑士发动折镜，额外增加死仇%d伤害\n',BP_Score)
                   A_Blood = A_Blood - BP_Score;
                elseif B_RPG(Round_Small) == 2
                    BPP_Score = abs(B_Blood);
                    fprintf('B队矩盾手发动折镜，反弹溢出的%d伤害\n',BPP_Score)
                    A_Blood = A_Blood - BPP_Score;
                elseif B_RPG(Round_Small) == 3
                    BR_Score = BR_Score + BR_Score;%多储存一次
                    fprintf('B队炼星师发动折镜，现在共储存%d的恢复血量，待最后回血\n',BR_Score)
                end
                fprintf('本次B队折镜效果计算完毕，血量恢复至固定值%d',ReBlood)
                B_Blood = ReBlood;
                if A_Blood <=0
                    if A_M == 1
                        fprintf('A队在受到B队折镜伤害后，后触发折镜效果')
                        A_M = 0;
                        if A_RPG(Round_Small) == 1
                           fprintf('A队绝剑士发动折镜，额外增加死仇%d伤害\n',AP_Score)
                           B_Blood = B_Blood - AP_Score;
                        elseif A_RPG(Round_Small) == 2
                            APP_Score = abs(A_Blood);
                            fprintf('A队矩盾手发动折镜，反弹溢出的%d伤害\n',APP_Score)
                            B_Blood = B_Blood - APP_Score;
                        elseif A_RPG(Round_Small) == 3
                            AR_Score = AR_Score + AR_Score;
                            fprintf('A队炼星师发动折镜，现在共储存%d的恢复血量，待最后回血\n',AR_Score)
                        end
                        fprintf('本次A队折镜效果计算完毕，血量恢复至固定值%d',ReBlood)
                        A_Blood = ReBlood;
                        if B_Blood <= 0
                            fprintf('B队在受到A队折镜伤害后，血量降至濒死，且无折镜使用')
                        end
                    elseif A_M == 0
                        fprintf('A队在受到B队折镜伤害后，血量降至濒死，且无折镜使用')
                    end
                end
            end
           
            if A_RPG(Round_Small) == 3
                fprintf('A队炼星师发动技能，回血%d\n',AR_Score)
                A_Blood = A_Blood + AR_Score;
                %若发动折镜，则再写一个回血，不写了，因为上面写过了
            end
            if B_RPG(Round_Small) == 3
                fprintf('B队炼星师发动技能，回血%d\n',BR_Score)
                B_Blood = B_Blood + BR_Score;
            end
            
            disp('当前双方血量')
            fprintf('A队有%d血\n',A_Blood)
            fprintf('B队有%d血\n',B_Blood)
            if A_Blood<=0 || B_Blood<=0
                flag_end = 1; %有队死了
                disp('有队死了')
                break
            end
            if Round_Small == 3
                disp('双方都存活，进入下一中轮')
                break
            end
        end
        disp('当前双方血量')
        fprintf('A队有%d血\n',A_Blood)
        fprintf('B队有%d血\n',B_Blood)
        if flag_end == 1%如果有队死了
            if A_Blood<=0 && B_Blood<=0
                if A_Blood>B_Blood
                    A_Blood = ReBlood;
                    disp('两队血量都濒死，但A队血量更多，被系统复活')
                end
                if A_Blood<B_Blood
                    B_Blood = ReBlood;
                    disp('两队血量都濒死，但B队血量更多，被系统复活')
                end
                if A_Blood == B_Blood
                    A_Blood = ReBlood;%若出现双方血量都小于0且相等的情况，这里默认判A队胜，实际则采取剪刀石头布或其他方式判断胜利，不进行重赛。
                    disp('两队血量都濒死，双方血量一致，优先A队复活（实际由剪刀石头布决定）')
                end
            end
            if A_Blood>0
                disp('A队获胜')
                break
            end
            if B_Blood>0
                disp('B队获胜')
                break
            end
            if A_Blood<=0 && B_Blood<=0
                disp('有BUG！！！！')
                break
            end
        end

    end
    disp('结算双方血量')
    fprintf('A队有%d血\n',A_Blood)
    fprintf('B队有%d血\n',B_Blood)
    fprintf('\n')
    fprintf('\n')
    fprintf('分割线')
    fprintf('\n')
    fprintf('\n')
    
   
end
% %%下面为临时统计学数字，并没有做直接的画柱状图，因为直接在matlab工作区就可以简易做出柱状图
% Date_Time = Date_Small * Song_Time + Date_Middle * Wait_Time;
% i = 0;
% battle4_time = zeros(1,n);
% while 1
%     fprintf('%d\n',i)
%     if i == n
%         break
%     end
%     j = 1+i*4;
%     i = i + 1;
%     battle4_time(i) = Date_Time(j) + Date_Time(j+1) + Date_Time(j+2) + Date_Time(j+3);
% end