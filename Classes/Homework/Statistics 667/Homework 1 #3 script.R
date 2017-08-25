# initialize M and P_M
M = 0
P_M = 0

# the loop that does all of the work
for (i in 0:4){
  n = 10 - 4 + i
  p = i:n
  p = p/10
  M[i+1] = which.max(dbinom(i,4,p)) - 1 + i
  P_M[i+1] = dbinom(i,4,(3/5))
}