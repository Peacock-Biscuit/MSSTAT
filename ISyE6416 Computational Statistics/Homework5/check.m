%a
data = load("copper-new.txt");
y=data (: ,1);
x=data (: ,2);
mdl = fitlm(x,y);
plot (mdl)
disp("The coefficient at 400 degree Kelvin: "+predict(mdl,400))
%b
GCVerr = 1000;
for lambda = logspace(-4,10,15)
    [yhat,~,gcv,~,~] = csapsGCV(x,y,lambda, [x;400]);
    if GCVerr > gcv
        GCVerr = gcv; yhat_400 = yhat (60); 
        bestlambda = lambda;
        fittederr = mean((yhat(1:59)-y).^2);
        bestyhat = yhat (1:59); 
    end
end
disp("================Spline Fitting=====================") 
scatter(x,y)
hold on
[ x , idx ]= sort ( x ) ;
plot(x,bestyhat(idx))
hold off
disp(" fitted error : "+ fittederr+" best_lambda:" + bestlambda)
disp("The coefficient at 400 degree Kelvin: "+yhat_400)