#!/usr/bin/perl -w

use strict;

my $arglen = @ARGV;

if ($arglen != 3) {
    printf ("usage: test06.pl InputDir TCClass MatrixType\n");
    printf ("InputDir --- 所需输入文件的文件夹地址\n");
    printf ("TCClass  --- Up | Down | Flat\n");
    printf ("MatrixType --- C11 | C12 | C21 | C22\n");
    exit;
}

my $TCClass = $ARGV[1];
my $MatrixType = $ARGV[2];

my $TestFiles = `echo ../data/TestSet$TCClass/*.arff`;
my @TestFiles_array = split /\s/, $TestFiles;

#my $models = `echo ../log_$MatrixType/*$TCClass*$MatrixType.model`;
my $models = `echo ../log_$MatrixType/*$TCClass*.model`;
my @models_array = split /\s/, $models;


open OUTFILE, ">>log-$MatrixType-$TCClass.eva.sum" || die "create log-$MatrixType-$TCClass.eva.sum error";
# Revaluate结束后，需要把每个model对应的100个eva合并为一个文件.
foreach (@models_array) {
	my $model = $_;
	printf (OUTFILE "$model");
	foreach my $txt (@TestFiles_array) {
		my $model_basename = `basename $model`;
		chomp $model_basename;
		my $LogName = "$txt" . "_$model_basename" . ".eva";

		#printf ("$LogName\n");
		open FILE, "$LogName" || die "open $LogName error\n";
		while (<FILE>) {
			if (/(\d+)\s+(\d+).+a\s+=/) {
				printf (OUTFILE ",$1,$2,");
				next;
			}
			if (/(\d+)\s+(\d+).+b\s+=/) {
				printf (OUTFILE "$1,$2");
				next;
			}
		}
		close FILE;
	}
	printf (OUTFILE "\n");	
}
close OUTFILE;
