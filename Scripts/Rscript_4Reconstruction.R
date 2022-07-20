###################################################################################
##                                                                                #
##                          Isolates_PrimaryMAG_MeanDepth.xls                     #
##                                                                                #
###################################################################################
library(ggplot2)
library(reshape2)
library(ggpubr)
d<-read.table("Isolates_PrimaryMAG_MeanDepth.xls",sep="\t",header=T)
d1<-subset(d,Isolate == "FC2")
gg1<- ggplot(d1,aes(x=Isolate,y=Depth))+
  geom_violin()+
  geom_jitter(width=0.4,shape=21,size=1)+
  geom_hline(yintercept=c(20088,491),linetype=2,colour="black")+
  xlab("")+
  ylab("Sequencing coverage")+
  theme_bw()+
  theme(axis.text.y=element_text(angle=90,vjust = 0.5,hjust = 0.5))+
  theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.position="none")

d2<-subset(d,Isolate == "FC3")
d2$Isolate<-as.factor(d2$Isolate)
gg2<-ggplot(d2,aes(x=Isolate,y=Depth))+
  geom_violin()+
  geom_jitter(width=0.4,shape=21,size=1)+
  geom_hline(yintercept=c(1131,236),linetype=2,colour="black")+
  xlab("")+
  ylab("")+
  theme_bw()+
  theme(axis.text.y=element_text(angle=90,vjust = 0.5,hjust = 0.5))+
  theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.position="none")

d3<-subset(d,Isolate == "FC5")
d3$Isolate<-as.factor(d3$Isolate)
gg3<- ggplot(d3,aes(x=Isolate,y=Depth))+
  geom_violin()+
  geom_jitter(width=0.4,shape=21,size=1)+
  geom_hline(yintercept=c(130,48),linetype=2,colour="black")+
  xlab("")+
  ylab("")+
  theme_bw()+
  theme(axis.text.y=element_text(angle=90,vjust = 0.5,hjust = 0.5))+
  theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.position="none")

d4<-subset(d,Isolate == "FC7")
d4$Isolate<-as.factor(d4$Isolate)
gg4<- ggplot(d4,aes(x=Isolate,y=Depth))+
  geom_violin()+
  geom_jitter(width=0.4,shape=21,size=1)+
  geom_hline(yintercept=c(35,4),linetype=2,colour="black")+
  xlab("")+
  ylab("")+
  theme_bw()+
  theme(axis.text.y=element_text(angle=90,vjust = 0.5,hjust = 0.5))+
  theme( panel.grid.major = element_blank(),panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.position="none")

gg<-grid.arrange(gg1,gg2,gg3,gg4,ncol=4)
ggsave("Isolates_FinalMAG_MeanDepth.pdf",gg,width=7,height=4)


###################################################################################
##                                                                                #
##                    Metaspades_RemainScaf_MeanDepth.xls                         #
##                                                                                #
###################################################################################
d<-read.table("Metaspades_RemainScaf_MeanDepth.xls",sep="\t",header=F)
library(tidyverse)
pdf("Metaspades_RemainScaf_MeanDepth.pdf")
hist(d$V2,breaks=seq(floor(min(d$V2)),ceiling(max(d$V2)),by=1),main="",xlab="Sequencing coverage",ylab="Frequency",xaxt="n")
axis(side=1,at=seq(0,13000,by=1000))
box()
dev.off()

###################################################################################
##                                                                                #
##                        SOAP_RemainScaf_MeanDepth.xls                           #
##                                                                                #
###################################################################################
d<-read.table("SOAP_RemainScaf_MeanDepth.xls",sep="\t",header=F)
pdf("SOAP_RemainScaf_MeanDepth.pdf")
layout(matrix(1:2,nrow=2))
hist(d$V2,breaks=seq(floor(min(d$V2)),ceiling(max(d$V2)),by=1),main="",xlab="Sequencing coverage",ylab="Frequency",xaxt="n")
axis(side=1,at=seq(0,6000,by=1000))
abline(v=c(5908,555,502,57),lty=3)
box()

library(tidyverse)
df<-d %>% filter(d$V2<100)
hist(df$V2,breaks=seq(floor(min(df$V2)),ceiling(max(df$V2)),by=1),main="",xlab="Sequencing coverage",ylab="Frequency",xaxt="n")
axis(side=1,at=seq(0,100,by=10))
abline(v=c(57,51,20,22,0),lty=3)
box()

dev.off()

###################################################################################
##                                                                                #
##                      FC8-9_SCGscaffold_classifiedbyFC2_PP.xls                  #
##                                                                                #
###################################################################################
library(ggplot2)
layout(matrix(1:4,nrow=4))
d<-read.table("FC8-9_SCGscaffold_classifiedbyFC2_PP.xls",sep="\t",header=F)
pdf("LowSP_SCG_classifiedbyFC2_PP.pdf")
hist(d$V2,breaks=100,main="",xlab="Posteriori probability based on FC2 MAG",ylab="Frequency")
abline(v=-1350,lty=3)
box()
dev.off()
