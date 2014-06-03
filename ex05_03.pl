#!/usr/bin/perl -w

# 特征值选择，我们假设程序已经在可执行路径中，不做检查 

use strict;

my $arglen = @ARGV;

if ($arglen != 1) {
	printf ("usage: test06.pl InputDir\n");
	printf ("InputDir --- 所需输入文件的文件夹地址\n");
	exit;
}

# 设置参数，数组中的参数使用逗号分隔，跟C语言一样
my @CostMetrix11 = ();
my @CostMetrix12 = ();
my @CostMetrix21 = ();
my @CostMetrix22 = ();
my @NumberOfTrees = ();
my @NumberOfFeatures = ();
my @SeedForRandomNumberGenerator = ();
my @MaximumDepthOfTrees = ();
my @NumberOfExecutionSlots = ();

my $CostMetrix11_len = @CostMetrix11;
my $CostMetrix12_len = @CostMetrix12;
my $CostMetrix21_len = @CostMetrix21;
my $CostMetrix22_len = @CostMetrix22;
my $NumberOfTrees_len = @NumberOfTrees;
my $NumberOfFeatures_len = @NumberOfFeatures;
my $SeedForRandomNumberGenerator_len = @SeedForRandomNumberGenerator;
my $MaximumDepthOfTrees_len = @MaximumDepthOfTrees;
my $NumberOfExecutionSlots_len = @NumberOfExecutionSlots;


my $TrainDataFileName;
my $ModelName;
my $LogName;


my $InputDir = $ARGV[0];

my $txtfiles = `echo $InputDir/*.arff`;
my @txtfile_array = split $txtfiles;

foreach (@txtfile_array) {
	$TrainDataFileName = $_;
	$ModelName = $TrainDataFileName . ".model";
	$LogName   = $TrainDataFileName . ".log";
	#printf ("Modeling WekaCSCRFBuildModel $_ \n");

	my ($i1, $i2, $i3, $i4, $i5, $i6, $i7, $i8, $i9);

	for ($i1 = 0; $i1 < $CostMetrix11_len; ++$i1) {
		for ($i2 = 0; $i2 < $CostMetrix12_len; ++$i2) {
			for ($i3 = 0; $i3 < $CostMetrix21_len; ++$i3) {
				for ($i4 = 0; $i4 < $CostMetrix22_len; ++$i4) {
					for ($i5 = 0; $i5 < $NumberOfTrees_len; ++$i5) {
						for ($i6 = 0; $i6 < $NumberOfFeatures_len; ++$i6) {
							for ($i7 = 0; $i7 < $SeedForRandomNumberGenerator_len; ++$i7) {
								for ($i8 = 0; $i8 < $MaximumDepthOfTrees_len; ++$i8) {
									for ($i9 = 0; $i9 < $NumberOfExecutionSlots_len; ++$i9) {
										`Modeling WekaCSCRFBuildModel $CostMetrix11[$i1] $CostMetrix12[$i2] $CostMetrix21[$i3] $CostMetrix22[$i4] $NumberOfTrees[$i5] $NumberOfFeatures[$i6] $SeedForRandomNumberGenerator[$i7] $MaximumDepthOfTrees[$i8] $NumberOfExecutionSlots[$i9]`;
									}
								}
							}
						}
					}
				}
			}
		}
	}

}
