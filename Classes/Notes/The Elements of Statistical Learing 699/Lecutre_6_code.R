### Prostate Cancer Example
dataset=read.table("https://web.stanford.edu/~hastie/ElemStatLearn/datasets/prostate.data")
test.data=dataset[!dataset$train,-10]
dim(test.data)
full.training.data=dataset[dataset$train,-10]
dim(full.training.data)
L=function(y,y.hat){(y-y.hat)^2}

### Random Forest (randomForest::randomForest) [p.588//607]
## defaults
require(randomForest)
set.seed(34985)
rf.model=randomForest(lpsa~.,data=full.training.data)
lpsa.fit=predict(rf.model,full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.1849909
lpsa.hat=predict(rf.model,test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.529034

## use caret package to choose mtry
require(caret)
set.seed(213874)
ctrl=trainControl(method="boot632")
rf.model=train(lpsa~., data=full.training.data, method="rf",
               ntree=5000, trControl=ctrl, tuneGrid=data.frame(mtry = 1:8))
rf.model
lpsa.fit=predict(rf.model,full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.152598
lpsa.hat=predict(rf.model,test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.4982294

## use mtry=8
require(randomForest)
set.seed(34985)
rf.model=randomForest(lpsa~.,data=full.training.data,ntree=5000,mtry=8)
lpsa.fit=predict(rf.model,full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.1331699
lpsa.hat=predict(rf.model,test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.4046961

## Manually do Leave-One-Out CV
require(randomForest)
set.seed(34985)
all.models=data.frame(m=1:8,CV=0)
for (j in 1:67){
  validation.data=full.training.data[j,]
  training.data=full.training.data[-j,]
  for (i in 1:nrow(all.models)){
    rf.model=randomForest(lpsa~., data=training.data, ntree=5000, mtry=all.models$m[i])
    lpsa.hat=predict(rf.model,validation.data)
    all.models$CV[i]=all.models$CV[i]+L(validation.data$lpsa,lpsa.hat)
  }
  cat("Sample ",j,": ",all.models$CV/j,"\n")
}
all.models$CV=all.models$CV/67
all.models$m[which.min(all.models$CV)]
#m=2

## Manually do Leave-30-Out CV
R=100
require(randomForest)
set.seed(34985)
all.models=data.frame(m=1:8,CV=0)
for (j in 1:R){
  validation.indices=sample(1:67,30)
  training.indices=setdiff(1:67,validation.indices) 
  validation.data=full.training.data[validation.indices,]
  training.data=full.training.data[training.indices,]
  for (i in 1:nrow(all.models)){
    rf.model=randomForest(lpsa~., data=training.data, ntree=5000, mtry=all.models$m[i])
    lpsa.hat=predict(rf.model,validation.data)
    all.models$CV[i]=all.models$CV[i]+mean(L(validation.data$lpsa,lpsa.hat))
  }
  cat("Sample ",j,": ",all.models$CV/j,"\n")
}
all.models$CV=all.models$CV/R
all.models$m[which.min(all.models$CV)]
#m=2

## use SuperLearner package to choose mtry in RandomForest
require(SuperLearner)
set.seed(213874)
mtry.seq=1:7
learners = create.Learner("SL.randomForest", tune=list(mtry = mtry.seq))
cv.sl = CV.SuperLearner(Y=full.training.data[,9], X=full.training.data[,1:8], family=gaussian(), V=10, SL.library = c(learners$names, "SL.randomForest"))
summary(cv.sl)

### Gradient Tree Boosting (gbm::gbm) [p.361//380]
require(gbm)
set.seed(62534)
gbm.model=gbm(lpsa~., data=full.training.data, distribution="gaussian", n.trees=100, interaction.depth=10, n.minobsinnode=5, shrinkage=0.1, bag.fraction=0.75, cv.folds=10, verbose=FALSE)
best.iter=gbm.perf(gbm.model, method="cv")
best.iter
lpsa.fit=predict(gbm.model,full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.1708413
lpsa.hat=predict(gbm.model,test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.4531908

## use caret package to choose parameters
require(caret)
set.seed(213874)
caret.grid=expand.grid(interaction.depth=1:5,n.trees=20*(1:50), shrinkage=10^(-3:-1), n.minobsinnode=c(5,10))
metric="RMSE"
ctrl=trainControl(method="boot632")
gbm.caret=train(lpsa~., data=full.training.data, distribution="gaussian", method="gbm", trControl=ctrl, tuneGrid=caret.grid, metric=metric, bag.fraction=.75)
gbm.caret
#RMSE was used to select the optimal model using the smallest value.
#The final values used for the model were n.trees = 1000, #interaction.depth = 5, shrinkage = 0.1 and n.minobsinnode = 5.
lpsa.fit=predict(gbm.caret,full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 7.640899e-09
lpsa.hat=predict(gbm.caret,test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.4983728

### Gradient Boosting with Linear Models (mboost::glmboost)
set.seed(639823)
require(mboost)
glmboost.model=glmboost(lpsa~., data=full.training.data)

lpsa.fit=predict(glmboost.model,full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4671374
lpsa.hat=predict(glmboost.model,test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.463634

### Ensemble (caretEnsemble::caretEnsemble)
set.seed(13947)
require(caretEnsemble)
require(elasticnet)
ctrl=trainControl(method="cv",number=5)
caret.models=caretList(lpsa~.,full.training.data,methodList=c("lm","lasso","rpart","nnet"),trControl=ctrl)
ensemble.model=caretEnsemble(caret.models)
summary(ensemble.model)

lpsa.fit=predict(ensemble.model,full.training.data)
mean(L(full.training.data$lpsa,lpsa.fit))
# training.error = 0.4847826
lpsa.hat=predict(ensemble.model,test.data)
mean(L(test.data$lpsa,lpsa.hat))
# test.error = 0.4404502