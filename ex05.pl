#!/usr/bin/perl -w

use strict;

my $arglen = @ARGV;

if ($arglen != 6) {
	printf ("usage: test06.pl InputDir TC TCClass M N K\n");
	printf ("InputDir --- 所需输入文件的文件夹地址\n");
	printf ("TC       --- testcase个数\n");
	printf ("TCClass  --- 测试类型，Up(1) Down(2) Flat(3), 输入时输入数字\n");
	printf ("M        --- BuildModel的训练文件包含的天数\n");
	printf ("N        --- 生成训练文件的起始天数间隔N天\n");
	printf ("K        --- 模型参数的组数\n");
	exit;
}

my $InputDir = $ARGV[0];
my $TC 		 = $ARGV[1];
my $TCClass  = $ARGV[2];
my $M 		 = $ARGV[3];
my $N 		 = $ARGV[4];
my $K 		 = $ARGV[5];

#printf ("|$InputDir|$TC|$TCClass|$M|$N|$K\n");

# 参数合理性检查
if (!-d $InputDir) {
	printf ("$InputDir 不是一个目录\n");
	exit;
}

if ($TCClass != 1 && $TCClass != 2 && $TCClass != 3) {
	printf ("TCClass应该输入数字 Up (1) | Down (2) | Flat (3)\n");
	exit;
}

# ================ 检查程序运行的一些前提条件 ====================
# 检查FeatureSelection是否在可执行路径中，并且权限正确
#my $FeatureSelection = `which FeatureSelection`;
#chomp $FeatureSelection;
#if (!-x $FeatureSelection) { 
#	printf ("FeatureSelection不在可执行路径中，或者没有加可执行权限\n");
#	printf ("请修改环境变量PATH\n");
#	exit;
#}
# 检查合并测试文件是否已经完成，如果完成直接进入特征抽取阶段
#if ($TCClass == 1 && -e $InputDir/) {
#	goto FSelction;
#}


# ===================== 合并测试文件开始 =========================
my $origin_csv_files;
my @origin_csv_array;

if ($TCClass == 1) {
	$origin_csv_files = `echo $InputDir/*ClassUp*.csv`;
	@origin_csv_array = split /\s/, $origin_csv_files;
} elsif ($TCClass == 2) {
	$origin_csv_files = `echo $InputDir/*ClassDown*.csv`;
	@origin_csv_array = split /\s/, $origin_csv_files;
} elsif ($TCClass == 3) {
	$origin_csv_files = `echo $InputDir/*ClassFlat*.csv`;
	@origin_csv_array = split /\s/, $origin_csv_files;
}

# 排序，理论上文件系统已经排过了，这一步可以省略
my @sorted_origin_csv_array = sort @origin_csv_array;

my $csv_count = @sorted_origin_csv_array;
# 进行一下合理性检查，看看是否输入参数超过csv文件个数
if ($TC * $N + $M > $csv_count) {
	printf ("csv文件个数不够\n");
	exit;
}

# 合并后的txt文件放入不同的目录中，方便下一步并行分析数据
`mkdir $InputDir/Up $InputDir/Down $InputDir/Flat 2>/dev/null`;

my $i = 0;
my $j = 0;
my $index_begin = 0;
my $orig_index_begin = $index_begin + 1;
# $TC是testcase个数，即要生成多少组
for ($i = 0; $i < $TC; ++$i) {
	my $first = 0; # 判断是否是一个csv文件，需要保留第一行
	my $outfile;
	my $tmp1 = $orig_index_begin;
	my $tmp2 = $tmp1 + $M;

	$orig_index_begin += $N;

	if ($TCClass == 1) {
		$outfile = "$InputDir/Up/TestCase$TC-$tmp1-$tmp2-Up.txt";
	} elsif ($TCClass == 2) {
		$outfile = "$InputDir/Down/TestCase$TC-$tmp1-$tmp2-Down.txt";
	} else {
		$outfile = "$InputDir/Flat/TestCase$TC-$tmp1-$tmp2-Flat.txt";
	}

	# 先检查是否已经存在，如果存在不用再生成
	#if (-e $outfile && ! -z $outfile) { # 存在并且大于0
	#	printf ("$outfile存在并大于0，不再生成\n");
	#	$index_begin += $N;
	#	next;
	#}

	for ($j = 0; $j < $M; ++$j) { #M 一个测试集的天数
		if ($first == 0) {
			$first = 1;
			# 第一个文件原样拷贝
			`cp $origin_csv_array[$index_begin] $outfile`;
		} else {
			# 只有第一行可能包括Time
			# printf ("grep -v Time $origin_csv_array[$index_begin] >> $outfile\n");
			`grep -v Time $origin_csv_array[$index_begin] >> $outfile`;
		}
		++$index_begin;
	}

	$index_begin -= 50;
	$index_begin += $N;
}
# ===================== 合并测试文件结束 =========================

