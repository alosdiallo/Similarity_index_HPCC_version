args   <- commandArgs(TRUE);
array <- read.table(args[1]);
location <- args[2];
array <- as.matrix(array);
arrayT <- t(array);
r <- array %*% arrayT
setwd(location)
write.table(r, file="result.txt",sep = " \t",col.names = F, row.names = F)
