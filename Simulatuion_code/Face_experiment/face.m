function [energy, tp, tn, fp, fn, num_mal, std_norm, mean_norm, std_mal, mean_mal,t]=face(dispMode)
    %% Simulation Parameters
    mu=0.25;                                 %mean arrival time (min)
    num_users=100;                          %number of users
    p_malicious=10;                         %percentage of malicious users
    sim_time=15000;                         %simulation time (sec)

    nd_energy=0;                            %energy consumption
    energy_cnt=0;                           %how many energy is set
    energy_track=[];                        %for plotting energy
    time_track=[];                          %for plotting time
    time_used=1;                            %time 

    %% FACE  
    fn_face=28.8;                           %false negative
    fp_face=27.7;                           %false positive
    e_face_rec=2.54;                        %energy face
    t_face_rec=3.25;                        %time face


    %% FINGERPRINT 
    fn_finger=18.20;                        %false negative
    fp_finger=21.50;                        %false positive
    e_finger_hit=0.34;                      %energy fingerprint hit
    e_finger_miss=0.31;                     %energy fingerprint miss
    t_finger_hit=2.22;                      %time  fingerprint hit
    t_finger_miss=2.18;                     %time  fingerprint miss



    %% CONSTANTS
    nd_type=1;                              %node type; normal or malicious
    nd_trust=2;                             %column 2 is the trust value
    
    nd_fp_cnt=3;                            %number of false positives
    nd_fn_cnt=4;                            %number of false negatives
    nd_tp_cnt=5;                            %number of true positives
    nd_tn_cnt=6;                            %number of true negatives
    
    nd_arrival_time=7;                      %when the user is coming for access

    nd_normal=0;                            %honest node
    nd_malicious=1;                         %mal node


    %% Initializations
    fn_face=fn_face/100;                	%false negative
    fp_face=fp_face/100;                   	%false positive


    mu=mu*60;                               %convert minutes to seconds
    pd=makedist('exponential', 'mu',mu);    %creat exponential dist object
    users=zeros(num_users,6);               %initializing the users record


    users(:,nd_arrival_time)=random(pd, num_users, 1);  %initial arrival time


    amount_mal=round(num_users*p_malicious/100);        %number of mal nodes
    id_mal_nodes=randperm(num_users,amount_mal);        %nodes selected to be malicious
    users(id_mal_nodes,nd_type)=nd_malicious;           %nodes are noted

    num_mis=inf;                                        %number of normal nodes misclassified

    %% MAIN
    chk_fc_tp=0;                                                     %same as above
    chk_fc_fp=0;
    chk_fc_fn=0;
    chk_fc_tn=0;
    
    switch_fp=1;                                                    %0-off, 1-on 
    switch_fc=1;                                                    %use this varaible with the threshold

    
    giveUp=1e+6;                                                    %when there is no change I give up
    
    t=0;                                                            %Synchronize time
    while ( t<giveUp)
        for i=1:num_users                                           %for each user
            if(users(i,nd_arrival_time)<=t)                         %if user arrives
                users(i,nd_arrival_time)=t+random(pd);              %when next he is coming
    

                                
                %%
                %Face Modalities :-)
                
                    if(true)                                            %If trust has reached the values
                        coin_toss=rand();                               %toss a coin to get stochastic results
                        if(users(i,nd_type)==nd_normal)                 %if user is non-malicious
                            if(coin_toss>fn_face)
                                chk_fc_tp=chk_fc_tp+1;                  %normal node passed face test
                                face_flag=1;                         	%face is true      
                                time_used=max(time_used, t_face_rec);	%the times overlapped
                                nd_energy=nd_energy+e_face_rec;     	%so we take the max
                            else
                                chk_fc_fn=chk_fc_fn+1;                  %normal node failed test
                                face_flag=0;                         	%face is not detected      
                                time_used=max(time_used, t_face_rec);	%the times overlapped
                                nd_energy=nd_energy+e_face_rec;     	%so we take the max
                            end
                        else
                            if(coin_toss>fp_face)
                                chk_fc_tn=chk_fc_tn+1;                  %normal node passed face test
                                face_flag=0;                         	%face is truely not his     
                                time_used=max(time_used, t_face_rec);	%the times overlapped
                                nd_energy=nd_energy+e_face_rec;     	%so we take the max
                            else
                                chk_fc_fp=chk_fc_fp+1;                  %normal node failed test
                                face_flag=1;                         	%face is thought to be right      
                                time_used=max(time_used, t_face_rec);	%the times overlapped
                                nd_energy=nd_energy+e_face_rec;     	%so we take the max
                            end
                        end
                    end    
                 
                    




                if(face_flag==1)                  
                    if(users(i, nd_type)==nd_normal)                    %count truth
                       users(i, nd_tp_cnt)=users(i, nd_tp_cnt)+1;       %true positive
                    else
                       users(i, nd_fp_cnt)=users(i, nd_fp_cnt)+1;       %false positive since he is given acces
                    end

                else
                    if(users(i, nd_type)==nd_normal)                    %count truth
                       users(i, nd_fn_cnt)=users(i, nd_fn_cnt)+1;       %false negative, good user no access
                    else
                       users(i, nd_tn_cnt)=users(i, nd_tn_cnt)+1;       %true negative, since he is not given acces
                    end

                end

            end       
        end


        t=t+time_used;                                        %update the clock
        time_used=1;                                          %re-initialize time used to login to min.

        energy_cnt=energy_cnt+1;                              %energy count fro record
        energy_track(energy_cnt)=nd_energy;             
        time_track(energy_cnt)=t;
        

        
%         if(num_mis==last_num_mis)                           %if we are having the same number of miss classified users
%             failCount=failCount+1;                          %keep track
%         else
%             failCount=0;                                    %else we are making progress so initialize
%             last_num_mis=num_mis;                           %make updates
%         end
    end

    energy=energy_track(end);
    
    
    %% RESULTS
    tn=sum(users(:,nd_tn_cnt));
    tp=sum(users(:,nd_tp_cnt));
    fn=sum(users(:,nd_fn_cnt));
    fp=sum(users(:,nd_fp_cnt));
    sum_access=tn+tp+fn+fp;



    p_fp=fp/(tn+fp)*100;
    p_fn=fn/(tp+fn)*100;
    p_tp=(1-p_fn/100)*100;
    p_tn=(1-(p_fp)/100)*100;
    
   
    
    if (dispMode==1)
        figure(1);
        hold on
        plot (time_track, energy_track, 'linewidth', 2);        % '--r',
        xlabel('Time (s)');
        ylabel('Energy (J)');
        title('Time vs Energy Consumed');
        xlim([0 sim_time+sim_time/5])
        grid on;
        hold off;




        fprintf('True +ve %0.2f => %0.2f%%\n', tp,p_tp);
        fprintf('True -ve %0.2f => %0.2f%%\n', tn,p_tn);
        fprintf('False +ve %0.2f => %0.2f%%\n', fp,p_fp);
        fprintf('False -ve %0.2f => %0.2f%%\n', fn,p_fn);

        fprintf('Debugging:\n');

        if(switch_fc==1)
            fprintf('\nFace:\n');
            sum_dbg=chk_fc_tp+chk_fc_fp+chk_fc_fn;
            fprintf('Trues %0.2f\n', chk_fc_tp/sum_dbg*100);
            fprintf('False +ve %0.2f\n', chk_fc_fp/sum_dbg*100);
            fprintf('False -ve %0.2f\n', chk_fc_fn/sum_dbg*100);
        end
    end
end