#!/usr/bin/perl -w

# 特征值选择，我们假设程序已经在可执行路径中，不做检查 

use strict;

my $arglen = @ARGV;

if ($arglen != 1) {
	printf ("usage: test06.pl TCClass\n");
	printf ("TCClass --- Up | Down | Flat\n");
	exit;
}

my $TCClass = $ARGV[0];
my $InputDir = "../data/$ARGV[0]";

# csv文件合并后，生成文件的扩展名是.txt，需要遍历一下，对
# 每个txt文件进行特征值选择

#printf ("CSV已经准备就绪，开始FeatureSelection前准备参数, 如果不需要此步骤可以CTRL+C停止程序\n");
#`./Modeling WekaInfoGain ../data/$TCClass/TestCase-1-100-Up.txt 30 ../data/$TCClass/TestCase-1-100-$TCClass.txt.log`; 


my $txtfiles = `echo $InputDir/*.txt`;
my @txtfile_array = split /\s+/, $txtfiles;

my $selectedArgs_tmp =`cat $InputDir/TestCase-1-100-$TCClass.txt.log`;
chomp ($selectedArgs_tmp);
my $selectedArgs = "\"" . $selectedArgs_tmp . "\"";

foreach (@txtfile_array) {
	printf ("Modeling WekaFeatureSelection $_ $selectedArgs $_.AFS.arff\n");
	`./Modeling WekaFeatureSelection $_ $selectedArgs $_.AFS.arff`;
	# 清除临时文件
	my $tmpfiles = `echo /tmp/0.*.tmp`;
	my @tmpfile_array = split /\s+/, $tmpfiles;

	foreach (@tmpfile_array) {
		# fuser 如果检测到没有进程正在使用tmp文件，将失败，因此可以删除
		`fuser $_ || (echo "rm -f $_"; rm -f $_)`; 
	}
}
