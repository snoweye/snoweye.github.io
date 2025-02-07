# File name: subsets_2.r

subsets <- function(r, n, v = 1 : n){
  if(r <= 0) NULL else
  if(r >= n) v[1 : n] else
  rbind(cbind(v[1], Recall(r - 1, n - 1, v[-1])),
                    Recall(r,     n - 1, v[-1]))
}
