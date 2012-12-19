args   <- commandArgs(TRUE);
a <- scan(args[1]);
b <- scan(args[2]);
y <- sd(a)
z <- sd(b)
avga <- mean(a)
avgb <- mean(b)
resultS <- cor(a,b, method = "spearman")
resultP <- cor(a,b, method = "pearson") 
cat(format(resultS))
cat("\n") 
cat(format(resultP))
cat("\n") 
cat(format(y))
cat("\n")
cat(format(z))
cat("\n")
cat(format(avga))
cat("\n")
cat(format(avgb))
cat("\n")

