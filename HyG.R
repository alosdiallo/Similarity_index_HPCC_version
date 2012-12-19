args   <- commandArgs(TRUE);
q <- as.numeric(args[1]);
m <- as.numeric(args[2]);
n <- as.numeric(args[3]);
k <- as.numeric(args[4]);
p<- -log10(1- phyper(q,m,n,k,lower.tail = TRUE, log.p = FALSE));
p