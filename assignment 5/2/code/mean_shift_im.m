function im2 = mean_shift_im(A,delta)
% disp(A);
C = [144 0 0 0 0; 0 144 0 0 0;0 0 400 0 0 ; 0 0 0 400 0; 0 0 0 0 400];
C1 = inv(C);
[x,y,z] = size(A);
im2 = zeros(x,y,z);
    for i = 1:x
       for j = 1:y    
           disp(strcat(num2str(i),' ',num2str(j)));
         xmin = max(1,i-11);
         ymin = max(1,j-11);
         xmax = min(x,i+11);
         ymax = min(y,j+11); 
         xn = [i,j,A(i,j,1),A(i,j,2),A(i,j,3)];
%           disp(xn);
         while (true)
            num =0;
            den =0;
            for a= xmin:xmax
                for b = ymin:ymax
                    xp=[a,b,A(a,b,1),A(a,b,2),A(a,b,3)];
                    xp1 = double(xp)-double(xn);
                    h = exp(-0.5*xp1*C1*transpose(xp1));
                    den = den+ h;
                    num = num +(double(xp)*h);
%                     disp(num);
%                     disp(den);
                end
            end
%             disp('oneloop');
            xxn = num/den;
            xxn1 = double(xxn) - double(xn);
            xxn1 = xxn1.^2;
            xxn1 = sum(xxn1);
%              disp(xxn1)
            if(xxn1 < delta)
%                 disp(xn);
                break;
            else
                xn = xxn;
            end
         end
        im2(i,j,:) = [ xn(3) ; xn(4) ; xn(5) ];
%          disp(xn);
%         im2(i,j,:) = [ xn(1) ; xn(2) ; xn(3) ];
%         disp(im2(i,j,:));
       end
    end
    
end

% function im1 = mean_image(A,delta)
%     sigma=12;
%     sigmain=2;
%     [x,y,z] = size(A);
%     im1 = zeros(x,y,z);
%     for i = 1:x
%        for j = 1:y
%            im1(i,j,1)=help_im(sigmain,A,delta,i,j,1);
%            im1(i,j,2)=help_im(sigmain,A,delta,i,j,2);
%            im1(i,j,3)=help_im(sigmain,A,delta,i,j,3);
%        end
%     end
% end
% function val = help_im(sigma,A,delta,i,j,k)
%     p1 = 2*sigma*sigma;
%     [x,y,z] = size(A);
%     xn = A(i,j,k) ;
%      xmin = max(1,i-11);
%      ymin = max(1,j-11);
%      xmax = min(x,i+11);
%      ymax = min(y,j+11);
%      while (true)
%             num =0;
%             den =0;
%             for a= xmin:xmax
%                 for b = ymin:ymax
%                     h = exp(double(-(A(a,b,k)-xn)*(A(a,b,k)-xn)/p1));
%                     den = den+ h;
%                     num = num + A(a,b,k)*h;
%                 end
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