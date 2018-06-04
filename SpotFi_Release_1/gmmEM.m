 function  model = gmmEM(data,Kk,option)  
%  
% K Ϊmodel����Ϊ��������  
% Reference: PRML p438-439  
tic   
if nargin < 3  
    option.eps = 1e-5;%��������  
    option.maxiter = 100;%  
      
end  
global num_data K;  
K=Kk;  
X = data';  %XΪD*N�����ݣ���PRML���������������෴  
[dim,num_data] = size(X);  
%Initialize  
%-------------------------------  
%K = numel(unique(data.y));  
[inx, C,~] = kmeans(data,K);%[inx, C,~] = kmeans(X',K);�Ѷ����ΪK������  
mu = C';%������ֵת��  
%inx D��������ľ�����  
pai = zeros(1,K);%��Ȩϵ������  
E = zeros(dim,dim,K);  
  
for k=1:K  
    pai(k) = sum(inx==k); %inx==index  ͳһ����ĸ���ͳ��  
    E(:,:,k) = eye(dim);%E��λ���� ��ʼ��Э�������   
end   
pai = pai/num_data;%��������ļ�Ȩϵ��  
iter = 0;%�αꡢͳ�Ƶ�������  
log_val = logGMM(X,mu,E,pai);  
try  
    iter  
while   iter<option.maxiter       
    iter = iter+1;   
    % E step   
    Yz = compu_Yz(X,mu,E,pai);%����k��һ����Ķ�ά������̬����   
    %ǰ��ʹ�������ݵ�ʹ��k�����һ���������һ�����������û�к����һ��  
    % M step ��˹�����������һ����Ҫ���о�ֵ��Э���������£�  
    NK = sum(Yz);%ÿ�����౻ʹ�õı����ܺʹ��1Xk, ���ں���ĺ����һ��  
    for k = 1:K  
         mu(:,k) = 1/NK(k)*X*Yz(:,k);  %��ֵ������� DXN NXK  
        %��ֵ=������Pi*���ݵ�ĳһ����Xi�������ﻹ���˸��������Nk    
        Ek = zeros(dim,dim);%Э�����������  
        %n=1:num_data;  
        for n=1:num_data  
            Ek = Ek+Yz(n,k)*(X(:,n)-mu(:,k))*(X(:,n)-mu(:,k))';  
        end  
        E(:,:,k) = 1/NK(k)*Ek;   
          
         %��i���������= ��(X-��i)ת��*����Pi*(X-��i)*��i���������         
    end  
    pai = NK/num_data;  
    %����Ƿ�����    
    log_val_new = logGMM(X,mu,E,pai);  
    if abs(log_val_new-log_val) < option.eps          
        model.Yz = Yz;  
        model.mu = mu;  
        model.E = E;  
        model.iter = iter;  
       return;  
    end  
    log_val = log_val_new;  
    if mod(iter,10)==0  
        disp(['-----���е�' num2str(iter) '����...'])  
    end  
end  
catch  
    fprintf('����!!\n�Ѿ���������:%d\n����������\n',iter,option.maxiter);  
    model.Yz = Yz;  
    model.mu = mu;  
    model.E = E;  
    model.iter = iter;  
    %return;  
end      
if iter==option.maxiter  
    %fprintf('�ﵽ����������%d',maxiter)  
    model.Yz = Yz;  
    model.mu = mu;  
    model.E = E;  
    model.iter = iter;  
end  
toc  
%model.usedTime = toc-tic;  
end  
  
%------------------------------------  
function val = logGMM(X,mu,E,pai)  
%��������X��������������ԣ�����ֵ����Э������󣨷��󣬶ԽǶԳƣ�����Ȩϵ��  
global num_data K  
val = 0;  
%N = size(X,2);  
%K = size(mu,2);  
for n=1:num_data  
    tmp = 0;  
    for k=1:K          
        p = mvnpdf(X(:,n),mu(:,k),E(:,:,k));  
        tmp = tmp+pai(k)*p;  
    end  
    val = val + log(tmp);  
end  
end  
  
%---------------------------------------------------------------  
function Yz = compu_Yz(X,mu,E,pai)  
%��������X��������������ԣ�����ֵ����Э������󡣼�Ȩϵ��  
    global num_data K  
    Yz = zeros(num_data,K);%����  
    for n = 1:num_data  
        Y_nK = zeros(1,K);%���� ��k�������  
        for k=1:K  
            Y_nK(k) = pai(k)*mvnpdf(X(:,n),mu(:,k),E(:,:,k));  
            %����mvnpdf ����DX1����Y_nk   (DX1;DX1;DXD)  
            %mvnpdf ����һ��Nά��̬�ֲ����������ĸ����ܶȣ���ɢ�˴�ֵ�����ܶȣ�  
            %pai(k)*��̬�����ܶ�=���������ܶȣ���ʹ��ĳ�������ǰ���£�  
        end  
        Yz(n,:) = Y_nK/sum(Y_nK);%���ʹ�һ�� ��һ������ʹ��k������ı�����  
        %���n�����ݷֱ��ھ����еĵ���һ��Nά��̬�ֲ����������ĸ��ʣ��ܶȣ�  
    end  
end  