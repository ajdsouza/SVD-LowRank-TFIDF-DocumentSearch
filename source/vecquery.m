clear all;
clear;

%--------------------------------------------------------
%  Query
%--------------------------------------------------------

prompt = 'Enter the string to search (e.g. tripoli peopl hide gadhafi ) :\n';
QueryString = input(prompt,'s');

% load the save the svd
projDir='E:\\wk\\aptha\\ajdsouza_local\\Google Drive\\education\\gatech\\course\\cse6643q_numerical_linear_algebra\\project\\datafiles';
filename=sprintf('%s\\termIndex.txt',projDir);
fid=fopen(filename);
termIdx=textscan(fid,'%s%d');
fclose(fid);

filename=sprintf('%s\\documentIndex.txt',projDir);
fid=fopen(filename);
docIdx=textscan(fid,'%s%d','delimiter',',');
fclose(fid);


clear U V D docIndexNew Dinv;
filename=sprintf('%s\\docsearchmat.mat',projDir);
load(filename,'U','docIndexNew','Dinv');

% transform the query vector
m=length(termIdx{1});
queryVector=zeros(m,1);
queryTerms=textscan(QueryString,'%s');
ql=length(queryTerms{1});
for k=1:m
    val=termIdx{1}{k};    
    fd=strfind(QueryString,val);  
    queryVector(k)=size(fd,2);
end
if ( norm(queryVector,2) )
    queryVector=queryVector/norm(queryVector,2);
end

fprintf('Searching documents fro query string %s\n',QueryString);

%determine the query vector
threshTheta=.6;
for cnt=1:5

    clear rApprox;
    clear r;
    
    filename=sprintf('%s\\rankApprox_%d.mat',projDir,cnt);
    load(filename,'rApprox','colnorm','r');

    fprintf('===================================================\n');
    fprintf('Searching through term doc matrix with rank %d\n',r);

    %Transform the query vector
    %queryVectorT=Dinv(1:r,1:r)*U(:,1:r)'*queryVector;
    queryVectorT=queryVector;

    if ( norm(queryVectorT,2) )
        queryVectorT=queryVectorT/norm(queryVectorT,2);
    end
    
    %find the cosine of vector with the matrix
    costheta=abs(queryVectorT'*rApprox);
    costheta=costheta./colnorm;

    [val,idx]=max(costheta);
    
    docNo=docIndexNew(idx);
    fprintf('Closest matching DocNo=%d %s \n',docNo,docIdx{1}{docNo});
 
end
