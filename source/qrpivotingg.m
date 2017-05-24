function [ Q, R , R1,P ] = qrpivotingg( A )
% Implement the givens trasnformation QR solution for matrix A(m x n)
%
% Return Q
% Return R
%
R=A;
[m,n]=size(R);
R1=zeros(n,n);

if m < n
    fprintf('The matrix length %d is not greater than its width %d ',m,n);
    exit;
end

Q=eye(m);
P=eye(n);

%vector to keep track of norm for column pivot for the largest column norm
anormsq=zeros(n,1);
for k=1:n
    for l=1:m
        anormsq(k)=anormsq(k)+R(l,k)^2;
    end
end

% Givens transform of the matrix
for j=1:n
            
    % remove norm of earlier row
    if j > 1
     for k=j:n
      anormsq(k)=anormsq(k)-R(j,k)^2;        
     end
    end
       
    % perform the column pivoting if required
    [mval,idx]=max(anormsq(j:n));
    idx=idx+j-1;
    if ( idx ~= j )
        anormsq(idx)=anormsq(j);
        anormsq(j)=mval;
        for k=1:m
            tmp = R(k,j);
            R(k,j)=R(k,idx);
            R(k,idx)=tmp;
        end
        for k=1:n
            tmp = P(k,j);
            P(k,j)=P(k,idx);
            P(k,idx)=tmp;
        end
    end

    
    for i=m:-1:j+1
        
        if (R(i,j) ~= 0 )
            
            c=R(j,j)/sqrt(R(j,j)^2+R(i,j)^2);
            s=R(i,j)/sqrt(R(j,j)^2+R(i,j)^2);
            
            for k=1:n
                val_jk=R(j,k);
                val_ik=R(i,k);
                if ( ( val_ik ~= 0 ) || ( val_jk ~= 0 ) )
                    R(j,k) = c*val_jk+s*val_ik;
                    R(i,k) = -s*val_jk+c*val_ik;
                end
                R1(j,k)=R(j,k);
            end
            
            %multuply to get the Q
            for k=1:m
                val_jk=Q(j,k);
                val_ik=Q(i,k);
                if ( ( val_ik ~= 0 ) || ( val_jk ~= 0 ) )
                    Q(j,k) = c*val_jk+s*val_ik;
                    Q(i,k) = -s*val_jk+c*val_ik;
                end
            end
            
        end
        
    end
end

Q=Q';
P=P';

end