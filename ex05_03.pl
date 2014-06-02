#!/usr/bin/perl -w

# 特征值选择，我们假设程序已经在可执行路径中，不做检查 

use strict;

my $arglen = @ARGV;

if ($arglen != 1) {
	printf ("usage: test06.pl InputDir\n");
	printf ("InputDir --- 所需输入文件的文件夹地址\n");
	exit;
}

my $InputDir = $ARGV[0];

# csv文件合并后，生成文件的扩展名是.arff，需要遍历一下，

my $txtfiles = `echo $InputDir/*.arff`;
my @txtfile_array = split $txtfiles;

foreach (@txtfile_array) {
	printf ("Modeling WekaCostSensitiveClassifierAndRandomForest $_ \n");
	`Modeling WekaFeatureSelection $_ $_.arff`;
}
