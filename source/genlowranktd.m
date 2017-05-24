clear all;
clear;

%----------------------------------------------------------------------
%  Generate the Low Rank Approximation of term doc matrix using SVD
%----------------------------------------------------------------------

projDir='E:\\wk\\aptha\\ajdsouza_local\\Google Drive\\education\\gatech\\course\\cse6643q_numerical_linear_algebra\\project\\datafiles';

filename=sprintf('%s\\termDocumentMatrix.txt',projDir);
termDocMatrix=dlmread(filename);

[Q,R,R1,P]=qrpivotingg(termDocMatrix);
[Ut,D,V]=jacobi(R1);

m=size(Q,1);
n=size(Ut,1);
U=zeros(m,n);

% get the diagonal elements of D, make sure they are sorted descending.
sing_vals=zeros(n,1);
rank=0;
notSorted=0;
for j=1:n
    if ( D(j,j) > 1e-6 )
        rank=rank+1;
    end
    sing_vals(j)=D(j,j);
    if ( j > 1 )
        if ( sing_vals(j) > sing_vals(j-1) )
            notSorted=1;
        end
    end
end

if ( notSorted  == 1 )
    
    [sorted_sing_vals,sorted_index]=sort(sing_vals,1,'descend');
    
    %created the permutation matrix, if the singular values are not sorted
    flagChanged=0;
    for i=1:n
        r=sorted_index(i);
        P(r,i)=1;
        % if there is a change in position of singualr values,
        %  u and v need to have a corresponding change
        Dnew(i,i)=D(r,r);
        
        for j=1:n
            Utnew(i,j)= Ut(r,j);
            Vnew(j,i)= V(j,r);
        end
    end
    
    D=Dnew;
    Ut=Utnew;
    V=Vnew;
    
end

% get back the U for SVD
for j=1:n
    for i=1:m
        U(i,j)=0;
        for l=1:n
            if ( ( Q(i,l) ~= 0 )&& ( Ut(l,j) ~= 0) )
                U(i,j)=U(i,j)+Q(i,l)*Ut(l,j);
            end
        end
    end
end

% Get the V by using the perm matrix, VP
docIndexNew=zeros(n,1);
Vnew=zeros(n,n);
%get Dinv
Dinv=D;

for j=1:n
    
    pcol=0;
    for k=1:n
        if (P(k,j) == 1 )
            pcol= k;
            break;
        end
    end
    
    docIndexNew(j)=k;
    
    if ( Dinv(j,j) ~= 0 )
     Dinv(j,j)=1/Dinv(j,j);
    end
    
    for i=1:n
        Vnew(i,j)= V(i,pcol);
    end
    
end
V=Vnew;


% save the svd
filename=sprintf('%s\\docsearchmat.mat',projDir);
save(filename,'U','V','D','docIndexNew','Dinv');
    
% save different low rank approximation matrix
cnt=0;
for r = [floor(rank/10),floor(rank/8),floor(rank/4),floor(rank/2),rank]    
    rApprox=zeros(m,r);
    for j=1:r
        for i=1:m            
            for k=1:r
                if ( ( U(i,k)~= 0 )&& (V(k,j) ~= 0) )
                    rApprox(i,j)=rApprox(i,j)+D(k,k)*U(i,k)*V(k,j);
                end
            end
        end
    end
    colnorm=sqrt(sum(rApprox.^2,1));
    cnt=cnt+1;
    filename=sprintf('%s\\rankApprox_%d.mat',projDir,cnt);
    save(filename,'rApprox','colnorm','r');
end



