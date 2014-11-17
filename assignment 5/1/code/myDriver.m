u1 = [0.0 0.0];
u2 = [5.0 5.0];
C1 = [2.0 0.0;0.0 2.0];
C2 = [2.0 1.0;1.0 2.0];
alpha = 0.0001;
sample_points = 3000;
x1 = mvnrnd(u1,C1,sample_points);
x2 = mvnrnd(u2,C2,sample_points);
a = rand(1);
if (a<=0.4)
x = x1 ;
else
x = x2 ;
end
% xmin = min(x(:,1));
% xmax = max(x(:,1));
% ymin = min(x(:,2));
% ymax = max(x(:,2));
% xlim([xmin xmax]);
figure(1);
scatter(x(:,1) , x(:,2));
y=mean_shift(x,alpha);
hold on;
scatter(y(:,1) , y(:,2),'r+');
