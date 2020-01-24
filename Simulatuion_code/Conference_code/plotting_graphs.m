%load('sim_results.mat');

grid on
plot(results(11:15,3),results(11:15,4),'-+r','linewidth',2);
grid on
title('Energy vs Threshold')
xlabel('Threshold')
ylabel('Energy (J)')

xx=[8637.93 5827.82 4686.37 3483.95 2938.65 2495.87];
th=[0.1 0.25 0.5 0.75 1.0 1.1];
plot(th, xx, '-+r', 'linewidth',2);
th=flip(th);
plot(th, xx, '-+r', 'linewidth',2);
grid on
title('Energy vs Threshold')
xlabel('Threshold')
ylabel('Energy (J)')

tpp=results(11:15,tps)./(results(11:15,tps)+results(11:15,tns)+results(11:15,fns)+results(11:15,fps))*100;
tnn=results(11:15,tns)./(results(11:15,tps)+results(11:15,tns)+results(11:15,fns)+results(11:15,fps))*100;
fnn=results(11:15,fns)./(results(11:15,tps)+results(11:15,tns)+results(11:15,fns)+results(11:15,fps))*100;
fpp=results(11:15,fps)./(results(11:15,tps)+results(11:15,tns)+results(11:15,fns)+results(11:15,fps))*100;

fpr=fpp./(fpp+tnn)*100;
fnr=fnn./(fnn+tpp)*100;


plot(0.1:0.1:0.5, fpr, '-sb', 'linewidth',2);
xlabel('False Positive Rate(%)');
ylabel('Threshold');
title('False Positive Rate vs Threshold');
grid on;

figure;
plot(0.1:0.1:0.5, fnr, '-or', 'linewidth',2);
xlabel('False Negative Rate(%)');
ylabel('Threshold');
title('False Negative Rate vs Threshold');
grid on;
