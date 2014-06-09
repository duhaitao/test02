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

my $models = `echo ../log/*$TCClass*$MatrixType.model`;
my @models_array = split /\s/, $models;


foreach (@models_array) {
	my $model = $_;
	foreach (@TestFiles_array) {
		my $model_basename = `basename $model`;
		chomp $model_basename;
		my $LogName = "$_" . "_$model_basename" . ".eva";
		printf ("./Modeling WekaReevaluate $_ $model $LogName\n");
		`./Modeling WekaReevaluate $_ $model $LogName`;
	}
}
