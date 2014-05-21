#!/usr/bin/perl -w 

use strict;

while (<>) {
	if (!/^b/) {
		next;
	}

	#print $_;
	my @a = split /,|;/;

	my $last = pop @a;
	pop @a;
	shift @a;

	my $line;
	foreach (@a) {
		$line .= $_ . ",";
	}

	#print $line . $last;

#交易日期,合约号, 事务编号, 合约名称, 最新价, 5最高价, 最低价, 最新成交量, 成交量, 成交额, 10初始持仓量, 持仓量, 持仓量变化, 今结算价, 历史最低价, 15历史最高价, 涨停板, 跌停板, 上日结算价, 上日收盘价, 20最高买, 申买量, 申买推导量, 最低卖, 申卖量, 25申卖推导量, 当日均价, 生成时间, 开盘价, 29收盘价;      30 价格,委托量,推导量,买卖标志,生成时间|价格,委托量,推导量,买卖标志, 生成时间|……|价格,委托量,推导量,买卖标志,生成时间;;本地时间戳

	@a = split  /,/, $line;
	#print @a;
	#print "\n";
	#next;

	#print $a[1] . ", ". $last . ", " . 

	my $ContractID = $a[1];

	if (!($ContractID =~ /j\d{4}/)) {
		next;
	}	

	if ($ContractID ne "j1305" && $ContractID ne "j1309" && 
		$ContractID ne "j1401" && $ContractID ne "j1405") {
		next;
	}

	chomp $last;
	my $GenTime = $last;
	
	my ($secs, $msec) = split /\./, $GenTime;
	
	my $sec_left = $secs % 86400;
	my $hour = int ($sec_left / 3600) + 8;
	my $min  = int (($sec_left - ($hour - 8) * 3600) / 60);
	my $sec =  int ($sec_left - ($hour - 8) * 3600 - $min * 60);

	if ($hour < 1) {
		$hour = "00";
	}
	if ($hour < 10) {
		$hour = "0" . $hour;
	}

	if ($min < 10) {
		$min = "0" . $min;
	}

	if ($sec < 10) {
		$sec = "0" . $sec;
	}
	#printf ("$GenTime, $hour, $min, $sec, $msec\n");

	my $LastPrice = $a[4];
	my $MatchTotQty = $a[8];
	my $OpenInterest = $a[11];
	my $BidPrice  = $a[20];
	my $BidQty    = $a[21];
	my $AskPrice  = $a[23];
	my $AskQty    = $a[24];

	my $Buy1OrderPrice = $a[30];
	my $Buy1OrderQty = $a[31];
	my $Buy2OrderPrice = $a[34];
	my $Buy2OrderQty = $a[35];
	my $Buy3OrderPrice = $a[38];
	my $Buy3OrderQty = $a[39];
	my $Buy4OrderPrice = $a[42];
	my $Buy4OrderQty = $a[43];
	my $Buy5OrderPrice = $a[46];
	my $Buy5OrderQty = $a[47];
	
	my $Sell1OrderPrice = $a[50];
	my $Sell1OrderQty = $a[51];
	my $Sell2OrderPrice = $a[54];
	my $Sell2OrderQty = $a[55];
	my $Sell3OrderPrice = $a[58];
	my $Sell3OrderQty = $a[59];
	my $Sell4OrderPrice = $a[62];
	my $Sell4OrderQty = $a[63];
	my $Sell5OrderPrice = $a[66];
	my $Sell5OrderQty = $a[67];

	if (!defined ($Buy1OrderPrice)) {
		$Buy1OrderPrice = 0;
	}
	if (!defined ($Buy1OrderQty)) {
		$Buy1OrderQty = 0;
	}

	if (!defined ($Buy2OrderPrice)) {
		$Buy2OrderPrice = 0;
	}
	if (!defined ($Buy2OrderQty)) {
		$Buy2OrderQty = 0;
	}

	if (!defined ($Buy3OrderPrice)) {
		$Buy3OrderPrice = 0;
	}
	if (!defined ($Buy3OrderQty)) {
		$Buy3OrderQty = 0;
	}

	if (!defined ($Buy4OrderPrice)) {
		$Buy4OrderPrice = 0;
	}
	if (!defined ($Buy4OrderQty)) {
		$Buy4OrderQty = 0;
	}

	if (!defined ($Buy5OrderPrice)) {
		$Buy5OrderPrice = 0;
	}
	if (!defined ($Buy5OrderQty)) {
		$Buy5OrderQty = 0;
	}

	if (!defined ($Sell1OrderPrice)) {
		$Sell1OrderPrice = 0;
	}
	if (!defined ($Sell1OrderQty)) {
		$Sell1OrderQty = 0;
	}

	if (!defined ($Sell2OrderPrice)) {
		$Sell2OrderPrice = 0;
	}
	if (!defined ($Sell2OrderQty)) {
		$Sell2OrderQty = 0;
	}

	if (!defined ($Sell3OrderPrice)) {
		$Sell3OrderPrice = 0;
	}
	if (!defined ($Sell3OrderQty)) {
		$Sell3OrderQty = 0;
	}

	if (!defined ($Sell4OrderPrice)) {
		$Sell4OrderPrice = 0;
	}
	if (!defined ($Sell4OrderQty)) {
		$Sell4OrderQty = 0;
	}

	if (!defined ($Sell5OrderPrice)) {
		$Sell5OrderPrice = 0;
	}
	if (!defined ($Sell5OrderQty)) {
		$Sell5OrderQty = 0;
	}

	$Buy2OrderPrice =~ s/\|//;
	$Buy3OrderPrice =~ s/\|//;
	$Buy4OrderPrice =~ s/\|//;
	$Buy5OrderPrice =~ s/\|//;

	$Sell1OrderPrice =~ s/\|//;
	$Sell2OrderPrice =~ s/\|//;
	$Sell3OrderPrice =~ s/\|//;
	$Sell4OrderPrice =~ s/\|//;
	$Sell5OrderPrice =~ s/\|//;

	printf ("$ContractID,$hour:$min:$sec.$msec,$LastPrice,$MatchTotQty,$OpenInterest,$Buy5OrderPrice,$Buy5OrderQty,$Buy4OrderPrice,$Buy4OrderQty,$Buy3OrderPrice,$Buy3OrderQty,$Buy2OrderPrice,$Buy2OrderQty,$Buy1OrderPrice,$Buy1OrderQty,$Sell1OrderPrice,$Sell1OrderQty,$Sell2OrderPrice,$Sell2OrderQty,$Sell3OrderPrice,$Sell3OrderQty,$Sell4OrderPrice,$Sell4OrderQty,$Sell5OrderPrice,$Sell5OrderQty\n"); 
}
