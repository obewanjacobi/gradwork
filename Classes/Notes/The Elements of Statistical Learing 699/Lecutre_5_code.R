### Prostate Cancer Example
dataset=read.table("https://web.stanford.edu/~hastie/ElemStatLearn/datasets/prostate.data")
test.data=dataset[!dataset$train,-10]
dim(test.data)
full.training.data=dataset[dataset$train,-10]
dim(full.training.data)
L=function(y,y.hat){(y-y.hat)^2}

### Multiple Linear Regression (Notes1) [p.44//63]
# training.error = 0.4391998
# test.error = 0.521274

### Backward Elimination (Notes2) [p.58//77]
lm.model=lm(lpsa~.,data=full.training.data[,c(1,2,9)])
mean(lm.model$resid^2)
# training.error = 0.5536096
# test.error = 0.4924823

### 5-Fold CV (Notes3) [p.242//261]
lm.model=lm(lpsa~.,data=full.training.data[,c(1,2,5,6,8,9)])
mean(lm.model$resid^2)
# training.error = 0.4808587
# test.error = 0.5098823

### Leave-1-Out CV (Notes3) [p.242//261]
lm.model=lm(lpsa~.,data=full.training.data[,-7])
mean(lm.model$resid^2)
# training.error =  0.4393627
# test.error = 0.5165135

### Nearest Neighbor (KernelKnn::KernelKnn) [p.14//33]:k=9, distance = "euclidean"
require(KernelKnn)
lpsa.fit=KernelKnn(full.training.data[,1:8],full.training.data[,1:8],full.training.data[,9],k=9,method = 'euclidean', regression = TRUE)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.9459682

lpsa.hat=KernelKnn(full.training.data[,1:8],test.data[,1:8],full.training.data[,9],k=9,method = 'euclidean', regression = TRUE)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 1.165273

### Nearest Neighbor (KernelKnn::KernelKnn) [p.14//33]:k=9, distance = "mahalanobis"
require(KernelKnn)
lpsa.fit=KernelKnn(full.training.data[,1:8],full.training.data[,1:8],full.training.data[,9],k=9,method = 'mahalanobis', regression = TRUE)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.5690388

### Ridge Regression (MASS::lm.ridge) [p.63//82]
require(MASS)
lambda=lm.ridge(lpsa~.,data=full.training.data,intercept=TRUE)$kLW
lambda
rr.model=lm.ridge(lpsa~.,data=full.training.data,intercept=TRUE,lambda=lambda)
beta.ridge=coef(rr.model)
beta.ridge

X.training=cbind(1,as.matrix(full.training.data[,1:8]))
lpsa.fit=c(X.training%*%beta.ridge)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4429651

X.test=cbind(1,as.matrix(test.data[,1:8]))
lpsa.hat=c(X.test%*%beta.ridge)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5006713

### LASSO (lars::lars) [p.68//87]: 10-fold CV
require(lars)
cv.lasso.model=cv.lars(as.matrix(full.training.data[,1:8]),full.training.data[,9],K=10,type="lasso")
s=cv.lasso.model$index[which.min(cv.lasso.model$cv)]
s

lasso.model=lars(as.matrix(full.training.data[,1:8]),full.training.data[,9],type="lasso")
coef(lasso.model,mode="frac",s=s)

lpsa.fit=predict(lasso.model,full.training.data[,1:8],type="fit",mode="frac",s=s)$fit
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4405132

lpsa.hat=predict(lasso.model,test.data[,1:8],type="fit",mode="frac",s=s)$fit
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5024794

### Principal Components Regression (pls::pcr) [p.79//98]: choose number of principal components which explains at least 80% of variation in the input space
require(pls)
pcr.model=pcr(lpsa~.,data=full.training.data,scale=TRUE)
summary(pcr.model)

lpsa.fit=predict(pcr.model,4,newdata=full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.5604308

lpsa.hat=predict(pcr.model,4,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5369458

### Partial Least Squares (pls::plsr) [p.80//99]: number of components selected by CV
require(pls)
pls.model=plsr(lpsa~.,data=full.training.data,validation="CV",scale=TRUE)
summary(pls.model)

lpsa.fit=predict(pls.model,6,newdata=full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4392485

lpsa.hat=predict(pls.model,6,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.521222

### Local Linear Regression (np::npregbw and np::npreg) [p.195//214]
#https://cran.r-project.org/web/packages/np/vignettes/np.pdf
require(np)
bw=npregbw(formula=lpsa~lcavol+lweight+age+lbph+svi+lcp+gleason+pgg45,data=full.training.data)
np.model=npreg(bws=bw)

lpsa.fit=predict(np.model)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.01418379

lpsa.hat=predict(np.model,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5842635

### Regression Tree (rpart::rpart) [p.307//326]
require(rpart)
rpart.model=rpart(lpsa~.,data=full.training.data)
summary(rpart.model)

lpsa.fit=predict(rpart.model)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4861264

lpsa.hat=predict(rpart.model,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.6136057

### Tuned Regression Tree (e1071::best.rpart)
require(e1071)
require(rpart)
rpart.model=best.rpart(lpsa~.,data=full.training.data, minsplit=seq(3,15,by=3))
summary(rpart.model)

lpsa.fit=predict(rpart.model)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.3991669

lpsa.hat=predict(rpart.model,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.6923789

### Additive Model (mgcv::gam) [p.297//316]
require(mgcv)
set.seed(34957)
gam.model=gam(lpsa~s(lcavol)+s(lweight),data=full.training.data)
summary(gam.model)

lpsa.fit=predict(gam.model)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4272748

lpsa.hat=predict(gam.model,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5289378

### Neural Network (nnet::nnet) [p.392//411]: 1 hidden layer, 2 units
require(nnet)
set.seed(32347)
nnet.model=nnet(lpsa~.,size=2,linout=TRUE,data=full.training.data)
summary(nnet.model)

lpsa.fit=predict(nnet.model)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4284934

lpsa.hat=predict(nnet.model,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5131959

### Tuned Neural Network (e1071::best.nnet)
require(e1071)
require(nnet)
set.seed(29991)
nnet.model=best.nnet(lpsa~., linout=TRUE, data=full.training.data, size=1:4, decay=seq(.05,.25,by=.05), trace=c("TRUE","FALSE"))
summary(nnet.model)

lpsa.fit=predict(nnet.model)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4401524

lpsa.hat=predict(nnet.model,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5108207

### Support Vector Machine (e1071::best.svm) [p.434//453]
require(e1071)
svm.model=svm(lpsa~.,data=full.training.data)
summary(svm.model)

lpsa.fit=predict(svm.model)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.3045789

lpsa.hat=predict(svm.model,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5522095

### Tuned Support Vector Machine (e1071::svm)
require(e1071)
tuned.svm.model=best.svm(lpsa~.,data=full.training.data,gamma=2^(-5:5), cost=2^(-4:4), epsilon=seq(.05,.5,by=.05))
summary(svm.model)

lpsa.fit=predict(svm.model)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.3045789

lpsa.hat=predict(svm.model,newdata=test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.5522095

##### the "caret" package also does tuning for any models