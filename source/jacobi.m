function [ U, D ,V ] = jacobi( R )

%
% perform a jacobi cyclical iteration
%

[m,n]=size(R);

if m ~= n 
    fprintf('This is not a square matrix, %d is different than %d ',m,n);
    exit;
end

U=eye(m);
V=eye(m);

% Givens transform of the matrix
delta=.00000001;
offset=0;
fnorm=0;
diagnorm=0;
iter=0;

for i=1:n
    for j=1:n
        fnorm=fnorm+R(i,j)^2;
        if ( i==j )
            diagnorm=diagnorm+R(i,i)^2;
        end
    end
end
offset = fnorm-diagnorm;

while offset > delta
    
    iter=iter+1;
    if ( iter > 1000 )
        fprintf('No of Jacobi iterations exceed %d',iter);
        break;
    end
    
    %do a cyclic column sweep
    for j=1:n
        for i=n:-1:j+1

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
                  % update the diagnorm change
                  if ( i==k )
                      diagnorm=diagnorm-val_ik^2+R(i,k)^2;
                  end
                  if ( j==k )
                      diagnorm=diagnorm-val_jk^2+R(j,k)^2;
                  end
              end

              %multiply to get the U
              for k=1:m
                  val_jk=U(j,k);
                  val_ik=U(i,k);
                  if ( ( val_ik ~= 0 ) || ( val_jk ~= 0 ) )
                      U(j,k) = c*val_jk+s*val_ik; 
                      U(i,k) = -s*val_jk+c*val_ik;              
                  end
              end

            end

        end
    end
    
    % do a cyclic column sweep
    for i=1:n
        for j=n:-1:i+1

            if (R(i,j) ~= 0 )

              c=R(i,i)/sqrt(R(i,i)^2+R(i,j)^2);
              s=R(i,j)/sqrt(R(i,i)^2+R(i,j)^2);

              for k=1:m
                  val_ki=R(k,i);
                  val_kj=R(k,j);
                  if ( ( val_ki ~= 0 ) || ( val_kj ~= 0 ) )
                    R(k,i) = c*val_ki+s*val_kj; 
                    R(k,j) = -s*val_ki+c*val_kj;    
                  end    
                  % update the diagnorm change
                  if ( i==k )
                      diagnorm=diagnorm-val_ki^2+R(k,i)^2;
                  end
                  if ( j==k )
                      diagnorm=diagnorm-val_kj^2+R(k,j)^2;
                  end
              end

              %multuply to get the V
              for k=1:m
                  val_ki=V(k,i);
                  val_kj=V(k,j);
                  if ( ( val_ki ~= 0 ) || ( val_kj ~= 0 ) )
                      V(k,i) =  c*val_ki+s*val_kj; 
                      V(k,j) = -s*val_ki+c*val_kj;              
                  end
              end

            end

        end
    end
    
    offset=fnorm-diagnorm;

end

U=U';
V=V';
D=R;

end
