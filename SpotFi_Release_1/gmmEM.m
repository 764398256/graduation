 function  model = gmmEM(data,Kk,option)  
%  
% K 为model数分为几个聚类  
% Reference: PRML p438-439  
tic   
if nargin < 3  
    option.eps = 1e-5;%收敛设置  
    option.maxiter = 100;%  
      
end  
global num_data K;  
K=Kk;  
X = data';  %X为D*N型数据，跟PRML对样本数据描述相反  
[dim,num_data] = size(X);  
%Initialize  
%-------------------------------  
%K = numel(unique(data.y));  
[inx, C,~] = kmeans(data,K);%[inx, C,~] = kmeans(X',K);把对象分为K个聚类  
mu = C';%聚类点均值转置  
%inx D个数据项的聚类编号  
pai = zeros(1,K);%加权系数清零  
E = zeros(dim,dim,K);  
  
for k=1:K  
    pai(k) = sum(inx==k); %inx==index  统一聚类的个数统计  
    E(:,:,k) = eye(dim);%E单位矩阵 初始化协方差矩阵   
end   
pai = pai/num_data;%各个聚类的加权系数  
iter = 0;%游标、统计迭代次数  
log_val = logGMM(X,mu,E,pai);  
try  
    iter  
while   iter<option.maxiter       
    iter = iter+1;   
    % E step   
    Yz = compu_Yz(X,mu,E,pai);%聚类k归一化后的多维条件正态概率   
    %前面使用了数据点使用k聚类归一化（纵向归一化）而后造成没有横向归一化  
    % M step 高斯迭代（横向归一化需要进行均值，协方差矩阵更新）  
    NK = sum(Yz);%每个聚类被使用的比例总和存放1Xk, 用于后面的横向归一化  
    for k = 1:K  
         mu(:,k) = 1/NK(k)*X*Yz(:,k);  %均值矩阵更新 DXN NXK  
        %均值=Σ概率Pi*数据点某一属性Xi；而这里还多了个聚类概率Nk    
        Ek = zeros(dim,dim);%协方差矩阵清零  
        %n=1:num_data;  
        for n=1:num_data  
            Ek = Ek+Yz(n,k)*(X(:,n)-mu(:,k))*(X(:,n)-mu(:,k))';  
        end  
        E(:,:,k) = 1/NK(k)*Ek;   
          
         %第i个方差矩阵= Σ(X-μi)转置*概率Pi*(X-μi)*第i个聚类概率         
    end  
    pai = NK/num_data;  
    %检查是否收敛    
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
        disp(['-----进行第' num2str(iter) '迭代...'])  
    end  
end  
catch  
    fprintf('出错!!\n已经迭代次数:%d\n最大迭代次数\n',iter,option.maxiter);  
    model.Yz = Yz;  
    model.mu = mu;  
    model.E = E;  
    model.iter = iter;  
    %return;  
end      
if iter==option.maxiter  
    %fprintf('达到最大迭代次数%d',maxiter)  
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
%样本数据X（行数据项，列属性）。均值矩阵。协方差矩阵（方阵，对角对称）。加权系数  
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
%样本数据X（行数据项，列属性）。均值矩阵。协方差矩阵。加权系数  
    global num_data K  
    Yz = zeros(num_data,K);%清零  
    for n = 1:num_data  
        Y_nK = zeros(1,K);%清零 第k个聚类的  
        for k=1:K  
            Y_nK(k) = pai(k)*mvnpdf(X(:,n),mu(:,k),E(:,:,k));  
            %库内mvnpdf 返回DX1数组Y_nk   (DX1;DX1;DXD)  
            %mvnpdf 单独一个N维正态分布生成样本的概率密度（离散此处值当作密度）  
            %pai(k)*正态概率密度=条件概率密度（在使用某个聚类的前提下）  
        end  
        Yz(n,:) = Y_nK/sum(Y_nK);%概率归一化 （一个数据使用k个聚类的比例）  
        %求第n个数据分别在聚类中的单独一个N维正态分布生成样本的概率（密度）  
    end  
end  