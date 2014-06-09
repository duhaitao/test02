#!/usr/bin/perl -w

# 建立模型

use strict;

my $arglen = @ARGV;

if ($arglen != 3) {
	printf ("usage: test06.pl InputDir MatrixType ThreadCount\n");
	printf ("InputDir --- 所需输入文件的文件夹地址\n");
	printf ("MatrixType --- C11 | C12 | C21 | C22, \
	C11进行变化 C12进行变化 C21进行变化 C22进行变化\n");
	printf ("ThreadCount -- 需要多少线程来计算");
	exit;
}

my $MatrixType = $ARGV[1];
my $ThreadCount = $ARGV[2];

# 设置参数，数组中的参数使用逗号分隔，跟C语言一样
my @CostMetrix11 = ();
my @CostMetrix12 = ();
my @CostMetrix21 = ();
my @CostMetrix22 = ();
if ($MatrixType eq "C12") {
	@CostMetrix11 = (0);
	@CostMetrix12 = (2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 100, 150, 200);
	@CostMetrix21 = (1);
	@CostMetrix22 = (0);
} elsif ($MatrixType eq "C21") {
	@CostMetrix11 = (0);
	@CostMetrix12 = (1);
	@CostMetrix21 = (2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 40, 50, 100, 150, 200);
	@CostMetrix22 = (0);
} else {
	printf ("CSCRFBuildModel 只有C12, C21两种类型\n");
	exit;
}

#my @NumberOfTrees = (10, 50, 100, 150, 200, 250, 300);
my @NumberOfTrees = (50);
my @NumberOfFeatures = (0);
my @SeedForRandomNumberGenerator = (1);
my @MaximumDepthOfTrees = (0);
my @NumberOfExecutionSlots = ($ThreadCount);

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
my $BaseTrainDataFileName;
my $ModelName;
my $LogName;


my $InputDir = $ARGV[0];

my $txtfiles = `echo $InputDir/*.arff`;
my @txtfile_array = split /\s+/, $txtfiles;

foreach (@txtfile_array) {
	$TrainDataFileName = $_;
	$BaseTrainDataFileName = `basename $TrainDataFileName`;
	chomp $BaseTrainDataFileName;
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
										$ModelName = "../log/" . $BaseTrainDataFileName . "-$CostMetrix11[$i1]" . "-$CostMetrix12[$i2]" . "-$CostMetrix21[$i3]" . "-$CostMetrix22[$i4]" . "-$NumberOfTrees[$i5]" . "-$NumberOfFeatures[$i6]" . "-$SeedForRandomNumberGenerator[$i7]" . "-$MaximumDepthOfTrees[$i8]" . "-$NumberOfExecutionSlots[$i9]" . "-$MatrixType" . ".model";
										$LogName   = "../log/" . $BaseTrainDataFileName . "-$CostMetrix11[$i1]" . "-$CostMetrix12[$i2]" . "-$CostMetrix21[$i3]" . "-$CostMetrix22[$i4]" . "-$NumberOfTrees[$i5]" . "-$NumberOfFeatures[$i6]" . "-$SeedForRandomNumberGenerator[$i7]" . "-$MaximumDepthOfTrees[$i8]" . "-$NumberOfExecutionSlots[$i9]" . "-$MatrixType" . ".log";
										printf ("Modeling WekaCSCRFBuildModel $CostMetrix11[$i1] $CostMetrix12[$i2] $CostMetrix21[$i3] $CostMetrix22[$i4] $TrainDataFileName $ModelName $LogName $NumberOfTrees[$i5] $NumberOfFeatures[$i6] $SeedForRandomNumberGenerator[$i7] $MaximumDepthOfTrees[$i8] $NumberOfExecutionSlots[$i9]\n");
										`./Modeling WekaCSCRFBuildModel $CostMetrix11[$i1] $CostMetrix12[$i2] $CostMetrix21[$i3] $CostMetrix22[$i4] $TrainDataFileName $ModelName $LogName $NumberOfTrees[$i5] $NumberOfFeatures[$i6] $SeedForRandomNumberGenerator[$i7] $MaximumDepthOfTrees[$i8] $NumberOfExecutionSlots[$i9]`;
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
