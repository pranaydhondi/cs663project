% function y = mean_shift(A,delta)
%     sigmax=2;
%     sigmay=2;
%     y=zeros(300,2);
%     z = zeros(300,2);
%     for i = 1:300
%         [y(i,1),z(i,1)] = help(sigmax,A(:,1),delta,i);
%         [y(i,2),z(i,2)] = help(sigmay,A(:,2),delta,i);
%     end
%     z = sum(z,2);
%     disp(strcat('Maximum no.of iterations :',num2str(max(z))));
%     disp(strcat('Manimum no.of iterations :',num2str(min(z))));
%     disp(strcat('Average no.of iterations :',num2str(sum(z)/300)));
% end
function y = mean_shift(A,delta,sample_points)
% disp(A);
C = [4 0;0 4];
C1 = inv(C);
y = zeros(sample_points,2);
iteration_i = zeros(sample_points,1);
    for i = 1:sample_points
        xn = A(i,:);
        iter = 0;
        while(true)
            iter = iter+1;
            den =0 ;
            num = zeros(1,2);
            for j = 1:sample_points
                h = exp(-0.5*(A(j,:)-xn)*C1*transpose((A(j,:)-xn)));
                num = num + h*A(j,:);
                den = den + h;
            end
            xxn = num/den;
            xxn1 = xxn - xn;
            xxn1 = xxn1.^2;
            xxn1 = sum(xxn1);
            if(xxn1 < delta)
                break;
            else
                xn = xxn;
            end
            
        end
        iteration_i(i)=iter;
%         disp(iteration_i(i));
        y(i,:) = xn;
    end
%     disp(size(iteration_i));
    disp(strcat('Maximum no.of iterations :',num2str(max(iteration_i))));
    disp(strcat('Manimum no.of iterations :',num2str(min(iteration_i))));
    disp(strcat('Average no.of iterations :',num2str(sum(iteration_i)/sample_points)));

end

% function [val,iter] = help(sigma,A,delta,i)
%     p1 = 2*sigma*sigma;
%     xn = A(i) ;
%     iter = 0;
%      while (true)
%             iter = iter+1;
%             num =0;
%             den =0;
%             for j = 1:300
%                 h = exp(-(A(j,1)-xn)*(A(j,1)-xn)/p1);
%                 den = den+ h;
%                 num = num + A(j,1)*h;
%             end
%             xxn = num/den;
%             if(abs(xxn-xn) < delta)
%                 break;
%             else
%                 xn = xxn;
%             end
%        end
%     val = xn;    
% end
