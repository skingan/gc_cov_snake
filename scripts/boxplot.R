#!/usr/bin/env Rscript
require("argparser")

parser <- arg_parser("box plots of coverage by sequence context")
parser <- add_argument(parser, "--infile", type="character", help="win.gc.cov.txt", default="NULL")
parser <- add_argument(parser, "--prefix", type="character", help="prefix", default="NULL")
args   <- parse_args(parser)

d<-read.table(args$infile, header=F)
colnames(d)<-c("contig","start","end","gc.pct","cov")

filename<-paste(args$prefix, "pdf", sep=".")
fullpath<-paste("output", filename, sep="/")

b1<-d[which(d$gc.pct>=0 & d$gc.pct<0.1),]
b2<-d[which(d$gc.pct>=0.10 & d$gc.pct<0.2),]
b3<-d[which(d$gc.pct>=0.20 & d$gc.pct<0.3),]
b4<-d[which(d$gc.pct>=0.30 & d$gc.pct<0.4),]
b5<-d[which(d$gc.pct>=0.40 & d$gc.pct<0.5),]
b6<-d[which(d$gc.pct>=0.50 & d$gc.pct<0.6),]
b7<-d[which(d$gc.pct>=0.60 & d$gc.pct<0.7),]
b8<-d[which(d$gc.pct>=0.70 & d$gc.pct<0.8),]
b9<-d[which(d$gc.pct>=0.80 & d$gc.pct<0.9),]
b10<-d[which(d$gc.pct>=0.90 & d$gc.pct<=1),]

par=(oma=c(3,4,3,2))

pdf(file=fullpath, width=11, height=8.5)
boxplot(b1$cov, b2$cov, b3$cov, b4$cov, b5$cov, b6$cov, b7$cov, b8$cov, b9$cov, b10$cov,
        outline=F, las=1,
        xlab="gc percentage--upper limit", ylab="coverage", main=args$prefix,
        names=c("10%","20%","30%","40%","50%","60%","70%","80%","90%","100%")
)
dev.off()
