myReward=0.2;
myPunish=0.1;
myThreshold=-1.5:0.5:1.5;            %since everybody is at zero sim will sto immidiately
                                    %so I am avoiding 0.
                                            
dispMode=0;                         %turn off graph with value 0

numReward=size(myReward, 2);        %this will help us when using for loop
numPunishment=size(myPunish, 2);
numThreshold=size(myThreshold, 2);


rewards=1;                          %Constants to help wth readability
punishs=2;
thresholds=3;
energys=4;
tps=5;
tns=6;
fps=7;
fns=8;
num_mal=9;
std_norm=10;
mean_norm=11; 
std_mal=12;
mean_mal=13;
time=14;

results=zeros(numReward*numPunishment*numThreshold, time);
cnt=1;
reps=50;

for i=1:numReward
    for j=1:numPunishment
        for k=1:numThreshold
            for l=1:reps
                [a, b, c, d, e, m, n, o, p, q, r]=multiBiometric_conf(...
                    myReward(i), myPunish(j), myThreshold(k), dispMode);

                results(cnt, energys)=results(cnt, energys)+a/reps; %taking average of reputition
                results(cnt,tps)=results(cnt,tps)+b/reps;
                results(cnt,tns)=results(cnt,tns)+c/reps;
                results(cnt,fps)=results(cnt,fps)+d/reps;
                results(cnt,fns)=results(cnt,fns)+e/reps;
                
               
                results(cnt,num_mal)=results(cnt,num_mal)+m/reps;
                results(cnt,std_norm)=results(cnt,std_norm)+n/reps;
                results(cnt,mean_norm)=results(cnt,mean_norm)+o/reps;
                results(cnt,std_mal)=results(cnt,std_mal)+p/reps;
                results(cnt,mean_mal)=results(cnt,mean_mal)+q/reps;
                
                results(cnt,time)=results(cnt,time)+r/reps;
                
                
%                 if(m>0)                                           %When some nodes are not properly classified
%                     fprintf('\n\n******Steady state not reached******\n\n');
%                     pause('on');
%                 end
            end
            
            results(cnt, rewards)=myReward(i);                      %record the inputs
            results(cnt, punishs)=myPunish(j);
            results(cnt, thresholds)=myThreshold(k);
            
            cnt=cnt+1;                                              %move to next column
        end
    end
end

tpp=results(:,tps)./(results(:,tps)+results(:,tns)+results(:,fns)+results(:,fps))*100;
tnn=results(:,tns)./(results(:,tps)+results(:,tns)+results(:,fns)+results(:,fps))*100;
fnn=results(:,fns)./(results(:,tps)+results(:,tns)+results(:,fns)+results(:,fps))*100;
fpp=results(:,fps)./(results(:,tps)+results(:,tns)+results(:,fns)+results(:,fps))*100;

fpr=fpp./(fpp+tnn)*100;
fnr=fnn./(fnn+tpp)*100;


plot(-1.5:0.5:1.5, fpr, '-sb', 'linewidth',2);
ylabel('False Positive Rate(%)');
xlabel('Threshold');
title('False Positive Rate vs Threshold');
grid on;

figure;
plot(-1.5:0.5:1.5, fnr, '-or', 'linewidth',2);
ylabel('False Negative Rate(%)');
xlabel('Threshold');
title('False Negative Rate vs Threshold');
grid on;
