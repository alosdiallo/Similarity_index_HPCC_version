args   <- commandArgs(TRUE);
array <- read.table(args[1]);
location <- args[2];
array <- as.matrix(array);
place_holder <- lower.tri(array)
setwd(location)
write.table(place_holder, file="triangle.txt",sep = " \t",col.names = F, row.names = F)
