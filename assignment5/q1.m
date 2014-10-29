u1 = [0,0];
u2 = [5,5];
C1 = [2,0;0,2];
C2 = [2,1;1,2];
x1 = mvnrnd(u1,C1,300);
x2 = mvnrnd(u2,C2,300);
a = rand(1);
if (a<=0.4) 
    x = x1 ;
else 
    x = x2 ;
end
scatter(x(:,1) , x(:,2));

function y = mean_shift( a,delta)
    sigmax=2;
    sigmay=2;
    p1 = 2*sigmax * sigmax;
    p2 = 2*sigmay * sigmay;
    y=zeros(300,2);
    for i = 1:300
        xn = a(i,1) ;
        yn = a(i,2) ;
        while (true) do
            num =0;
            den =0;
            for j = 1:300
                h = exp(-(a(j,1)-xn)(a(j,1)-xn)/p1)
                den = den+ h;
                num = num + a(j,1)*h;
            end
             xxn = num/den;
            if(abs(xxn-xn) < delta) 
                break;
            else
                xn = xxn;
            end
        end_while
        while (true) do
            num =0;
            den =0;
            for j = 1:300
                h = exp(-(a(j,2)-yn)(a(j,2)-yn)/p2);
                den = den+ h;
                num = num + a(j,1)*h;
            end
             yyn = num/den;
            if(abs(yyn-yn) < delta) 
                break;
            else
                yn = yyn;
            end
        end_while
        y(i,1) = xn;
        y(i,2) = yn;
    end
end

