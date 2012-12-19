args   <- commandArgs(TRUE);
location <- args[1];
a <- as.numeric(args[2]);
d <- as.numeric(args[3]);
setwd(location)
cc <- scan("list_two.txt");
cc[sample(1:length(cc), a)] <- d
cat(format(cc))
cc