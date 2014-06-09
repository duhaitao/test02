#!/usr/bin/perl -w

# 对测试集的文件进行特征值选择，我们假设程序已经在可执行路径中，不做检查 

use strict;

my $arglen = @ARGV;

if ($arglen != 2) {
	printf ("usage: test06.pl InputDir TCClass\n");
	printf ("InputDir --- 所需输入文件的文件夹地址\n");
	printf ("TCClass  --- Up | Down | Flat\n");
	exit;
}

my $InputDir = $ARGV[0];
my $TCClass = $ARGV[1];

my $csvfiles = `echo $InputDir/*$TCClass*.csv`;
my @csvfile_array = split /\s+/, $csvfiles;

# 按照文件名中的日期排序，而不是文件名称
my @sorted_origin_csv_array;
my %csv_hash;
my @date_array;
foreach (@csvfile_array) {
        if (/_(\d{8})\./) {
                $csv_hash{$1} = $_;
                push @date_array, $1;
        }
}

my @sorted_date_array = sort @date_array;
foreach (@sorted_date_array) {
        push @sorted_origin_csv_array, $csv_hash{$_};
}

# 验证集我们只需要100个文件
while (@sorted_origin_csv_array > 100) {
	pop @sorted_origin_csv_array;
}

# 验证集进行特征值选取后的输出，放入此目录
`mkdir $InputDir/TestSet$TCClass 2>/dev/null`;

foreach (@sorted_origin_csv_array) {
	#printf ("Modeling WekaFeatureSelection $_ $_.AFS.arff\n");
	my $basename = `basename $_`;
	chomp $basename;
	printf ("./Modeling WekaFeatureSelection $_ $InputDir/TestSet$TCClass/$basename.AFS.arff\n");
	`./Modeling WekaFeatureSelection $_ $InputDir/TestSet$TCClass/$basename.AFS.arff`;
	# 清除临时文件
	my $tmpfiles = `echo /tmp/0.*.tmp`;
	my @tmpfile_array = split /\s+/, $tmpfiles;

	foreach (@tmpfile_array) {
		# fuser 如果检测到没有进程正在使用tmp文件，将失败，因此可以删除
		`fuser $_ || (echo "rm -f $_"; rm -f $_)`; 
	}
}
