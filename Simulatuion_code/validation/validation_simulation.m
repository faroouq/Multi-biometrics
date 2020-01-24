clear;

fn_f=18.2/100;
fp_f=21.5/100;

fn_fc=28.8/100;
fp_fc=27.7/100;

rho=fn_f+fn_fc-(fn_f*fn_fc);
phi=fp_f*fp_fc;

sim_t=50;
track_trust=zeros(1,sim_t);
track_math=zeros(1,sim_t);

tm=zeros(1,sim_t);
tt=zeros(1,sim_t);

trust=0;
cnt=1;

gamma=0.8;
reward=0.1;

punishment=0.1;
is_node_mal=0;

pass=0;
fail=0;

pass_finger=0;
pass_face=0;

n_trust=0;
n_trust_prime=0;

trials=1;

for j=1:trials
   for i=1:sim_t                               %for every arrival
        x=rand();                               %toss a coin

        %% None malicious user
        if(is_node_mal==0)                      %is node is non-malicious, then we use FNR
            if(and(x<=(1-fn_fc),trust<gamma))   %if less than threshold the face through face detector
                pass_face=1;
            elseif(trust>=gamma)                %else if user is trusted, 
                pass_face=1;                    %then we assume he passes face detection
            end

            x=rand();                           %less check for finger printing
            if(x<=(1-fn_f))                     %the finger through finger detector
                pass_finger=1;
            end

            if(and(pass_face==1, pass_finger==1))
                trust=trust+reward;             %Reward successful login
                trust=min(1, trust);            %bound it to the upper boundary
            else
                trust=trust-punishment;         %punish loosers
                trust=max(-1, trust);           %ensure it is within the boundary
            end
           
            
            

           %% Gathering data to the mathematical model
            if(trust>=gamma)                    %counting
                n_trust=n_trust+1;
            else
                n_trust_prime=n_trust_prime+1;
            end


            if(is_node_mal==0)
                N=n_trust + n_trust_prime;
                track_math(cnt)=reward*N - (reward+punishment)*(rho*n_trust_prime + fn_f*n_trust);
                track_math(cnt)=max(-1,min(1,track_math(cnt)));
            else
                N=n_trust + n_trust_prime;
                track_math(cnt)=-punishment*N + (reward+punishment)*(phi*n_trust_prime + fp_f*n_trust);
                track_math(cnt)=max(-1,min(1,track_math(cnt)));
            end
            
            
            
            
                
        else
        %% Malicous user
            if(and(x<=(fp_fc),trust<gamma))   %if less than threshold the face through face detector
                pass_face=1;
            elseif(trust>=gamma)                %else if user is trusted, 
                pass_face=1;                    %then we assume he passes face detection
            end

            x=rand();                           %less check for finger printing
            if(x<=(fp_f))                       %the finger through finger detector
                pass_finger=1;
            end

            if(and(pass_face==1, pass_finger==1))
                trust=trust+reward;             %Reward successful login
                trust=min(1, trust);            %bound it to the upper boundary
            else
                trust=trust-punishment;         %punish loosers
                trust=max(-1, trust);           %ensure it is within the boundary
            end
           
            
            

           %% Gathering data to the mathematical model
            if(trust>=gamma)                    %counting
                n_trust=n_trust+1;
            else
                n_trust_prime=n_trust_prime+1;
            end

            if(is_node_mal==0)
                N=n_trust + n_trust_prime;
                track_math(cnt)=reward*N - (reward+punishment)*(rho*n_trust_prime + fn_f*n_trust);
                track_math(cnt)=max(-1,min(1,track_math(cnt)));
            else
                N=n_trust + n_trust_prime;
                track_math(cnt)=-punishment*N + (reward+punishment)*(phi*n_trust_prime + fp_f*n_trust);
                track_math(cnt)=max(-1,min(1,track_math(cnt)));
            end
        
        
        
        
        end

        %% End of one test
        pass_face=0;
        pass_finger=0;
        track_trust(cnt)=trust;
        cnt=cnt+1;
   end 
    
   
   
   %% Trying the experiment to improve the confidence interval
   tt=tt+(track_trust/trials);
   tm=tm+(track_math/trials);
   cnt=1;
   trust=0;
   n_trust_prime=0;
   n_trust=0;
end


figure;
plot(tt, '-b', 'linewidth',2);
hold on;
plot(tm, '-.r', 'linewidth',2);
legend('Experiment', 'Model');
xlabel('No. of Login attempts');
ylabel('Trust');
my_title=sprintf('Trust against Trials\n(\\phi=%0.2f, \\phi_{finger}=%0.2f, \\rho=%0.2f and \\rho_{finger}=%0.2f)', phi, fp_f, rho, fn_f);
title(my_title);
grid on;
hold off
