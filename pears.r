args   <- commandArgs(TRUE);
a <- scan(args[1]);
b <- scan(args[2]);
result <- cor(a,b, method = "pearson") 
result