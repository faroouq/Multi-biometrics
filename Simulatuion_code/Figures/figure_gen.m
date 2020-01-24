load('sim_results.mat');


% for i=1:(numPunishment*numThreshold):(numReward*numPunishment*numThreshold)
%     figure
%     x=reshape(results(i:i+(numPunishment*numThreshold)-1,4), [numPunishment,numThreshold]);
%     surf(myPunish,myThreshold,x)
%     tt=sprintf('Energy consumption of System at Reward (\\alpha)=%0.1f',results(i,1));
%     title(tt);
%     xlabel('Punishment (\beta)');
%     ylabel('Threshold (\gamma)');
%     zlabel('Energy (J)');
%     set(gca, 'ZScale', 'log');
% end

fnr=results(:,fns)./(results(:,fns)+results(:,tps))*100;
fpr=results(:,fps)./(results(:,fps)+results(:,tns))*100;

for i=1:numThreshold
    ee=zeros(1,(numPunishment*numReward));
    t=zeros(1,(numPunishment*numReward));
    fnrs=zeros(1,(numPunishment*numReward));
    fprs=zeros(1,(numPunishment*numReward));
    
    cnt=1;
    for j=i:numThreshold:(numReward*numPunishment*numThreshold)
        ee(cnt)=results(j,energys);
        ts(cnt)=results(j,time);
        fnrs(cnt)=fnr(j);
        fprs(cnt)=fpr(j);
        
        cnt=cnt+1;
    end
    
    figure
    ee=reshape(ee, [numPunishment,numReward]);
    surf(myReward,myPunish,ee)
    tt=sprintf('Energy consumption of System at Threshold (\\gamma)=%0.1f',results(i,3));
    title(tt);
    xlabel('Reward (\alpha)');
    ylabel('Punishment (\beta)');
    zlabel('Energy (J)');
    set(gca, 'ZScale', 'log');
    
    
    figure
    ts=reshape(ts, [numPunishment,numReward]);
    surf(myReward,myPunish,ts)
    tt=sprintf('Time vs Threshold (\\gamma)=%0.1f',results(i,3));
    title(tt);
    xlabel('Reward (\alpha)');
    ylabel('Punishment (\beta)');
    zlabel('Time (s)');
    set(gca, 'ZScale', 'log');
    
    
    figure
    fnrs=reshape(fnrs, [numPunishment,numReward]);
    surf(myReward,myPunish,fnrs)
    tt=sprintf('False Negative Rate of System at Threshold (\\gamma)=%0.1f',results(i,3));
    title(tt);
    xlabel('Reward (\alpha)');
    ylabel('Punishment (\beta)');
    zlabel('False Negative Rate (%)');
    %set(gca, 'ZScale', 'log');
    
    figure
    fprs=reshape(fprs, [numPunishment,numReward]);
    surf(myReward,myPunish,fprs)
    tt=sprintf('False Positive Rate of System at Threshold (\\gamma)=%0.1f',results(i,3));
    title(tt);
    xlabel('Reward (\alpha)');
    ylabel('Punishment (\beta)');
    zlabel('False Positive Rate (%)');
    %set(gca, 'ZScale', 'log');
end