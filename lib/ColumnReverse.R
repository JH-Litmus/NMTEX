
a=matrix(1:12,ncol=4)
as.character(a)
a <- read.table(file = "clipboard", sep = "\t")
V5 <-  c('TSH', 'Tg', 'ATA')
a <- cbind(a,V5) 
a <- a[,c("V5","V4", "V3", "V2", "V1")]
write.table(a,file="clipboard", append = FALSE, quote = FALSE , col.names = FALSE, row.names = FALSE, sep="\t")


