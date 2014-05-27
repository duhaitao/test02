#!/usr/bin/perl -w 

use strict;
my $arglen = @ARGV;
if ($arglen != 2) {
	printf ("usage: ./ex02.pl csvdir contract\n");
	printf ("example: ./ex02.pl 2013 j1401\n");
	exit;
}
#printf ("$ARGV[0], length: %d\n", $arglen);

if (! -d $ARGV[0]) {
	printf ("$ARGV[1] must be a directory.\n");
	exit;
}

`mkdir $ARGV[0]/$ARGV[1] 2>/dev/null`;

my $csvfile = `echo $ARGV[0]/*.csv`; 
my @csvfiles = split /\s/, $csvfile;

foreach (@csvfiles) {
	open FILE, $_ || die "open $_ error\n";
	#open OUTFILE, ">$ARGV[0]/$_.$ARGV[1].out" || die "create $_.$ARGV[1].out error\n";
	open OUTFILE, ">$_.$ARGV[1].out" || die "create $_.$ARGV[1].out error\n";
	while (<FILE>) {
		if (!/^b.+$ARGV[1]/) {
			next;
		}

		my @base_array = split /;/;
		my $level2Quot = $base_array[2];
		my @a = split /,|;/;

		my $last = pop @a;
		pop @a;
		shift @a;

		my $line;
		$line = join ",", @a;

	#交易日期,合约号, 事务编号, 合约名称, 最新价, 5最高价, 最低价, 最新成交量, 成交量, 成交额, 10初始持仓量, 持仓量, 持仓量变化, 今结算价, 历史最低价, 15历史最高价, 涨停板, 跌停板, 上日结算价, 上日收盘价, 20最高买, 申买量, 申买推导量, 最低卖, 申卖量, 25申卖推导量, 当日均价, 生成时间, 开盘价, 29收盘价;      30 价格,委托量,推导量,买卖标志,生成时间|价格,委托量,推导量,买卖标志, 生成时间|……|价格,委托量,推导量,买卖标志,生成时间;;本地时间戳

		@a = split  /,/, $line;

		my $ContractID = $a[1];
		my $LastPrice = $a[4];
		my $MatchTotQty = $a[8];
		my $OpenInterest = $a[11];
		my $GenTime = $a[27];

		my @level2Quot_array = split /\|/, $level2Quot;
	
		my %buy_price_hash;
		my @buy_price_array;
		my %sell_price_hash;
		my @sell_price_array;
		foreach (@level2Quot_array) {
				my ($price, $vol, $spread_vol, $bs) = split /,/;

				if ($bs == 1) {
					#$buy_price_hash{$price} = $price . "," . $vol;		
					$buy_price_hash{$price} = $vol;		
					push @buy_price_array, $price;
				} elsif ($bs == 3) {
					#$sell_price_hash{$price} = $price . "," . $vol;		
					$sell_price_hash{$price} = $vol;		
					push @sell_price_array, $price;
				}
		}	

		my $buy_price_array_len = @buy_price_array;
		my $sell_price_array_len = @sell_price_array;

		if ($buy_price_array_len < 5) {
			my $i = 0;
			for ($i = 0; $i < 5 - $buy_price_array_len; ++$i) {
				push @buy_price_array, "0";
			}
		}
	
		if ($sell_price_array_len < 5) {
			my $i = 0;
			for ($i = 0; $i < 5 - $sell_price_array_len; ++$i) {
				push @sell_price_array, "987654321";
			}
		}

		$sell_price_hash{987654321} = 0;
	
		my @sorted_buy_price_array = sort @buy_price_array;
		my @sorted_sell_price_array = sort @sell_price_array;

		my $i = 0;

		my $Buy5OrderPrice = $sorted_buy_price_array[0];
		my $Buy5OrderQty = 0;
		if ($Buy5OrderPrice > 0) {
			$Buy5OrderQty = $buy_price_hash{$Buy5OrderPrice};
		}
		my $Buy4OrderPrice = $sorted_buy_price_array[1];
		my $Buy4OrderQty = 0;
		if ($Buy4OrderPrice > 0) {
			$Buy4OrderQty = $buy_price_hash{$Buy4OrderPrice};
		}
		my $Buy3OrderPrice = $sorted_buy_price_array[2];
		my $Buy3OrderQty = 0;
		if ($Buy3OrderPrice > 0) {
			$Buy3OrderQty = $buy_price_hash{$Buy3OrderPrice};
		}
		my $Buy2OrderPrice = $sorted_buy_price_array[3];
		my $Buy2OrderQty = 0;
		if ($Buy2OrderPrice > 0) {
			$Buy2OrderQty = $buy_price_hash{$Buy2OrderPrice};
		}
		my $Buy1OrderPrice = $sorted_buy_price_array[4];
		my $Buy1OrderQty = 0;
		if ($Buy1OrderPrice > 0) {
			$Buy1OrderQty = $buy_price_hash{$Buy1OrderPrice};
		}
		
		my $Sell1OrderPrice = $sorted_sell_price_array[0];
		my $Sell1OrderQty = 0;
		if ($Sell1OrderPrice > 0) {
			$Sell1OrderQty = $sell_price_hash{$Sell1OrderPrice};
		}
		my $Sell2OrderPrice = $sorted_sell_price_array[1];
		my $Sell2OrderQty = 0;
		if ($Sell2OrderPrice > 0) {
			$Sell2OrderQty = $sell_price_hash{$Sell2OrderPrice};
		}
		my $Sell3OrderPrice = $sorted_sell_price_array[2];
		my $Sell3OrderQty = 0;
		if ($Sell3OrderPrice > 0) {
			$Sell3OrderQty = $sell_price_hash{$Sell3OrderPrice};
		}
		my $Sell4OrderPrice = $sorted_sell_price_array[3];
		my $Sell4OrderQty = 0;
		if ($Sell4OrderPrice > 0) {
			$Sell4OrderQty = $sell_price_hash{$Sell4OrderPrice};
		}
		my $Sell5OrderPrice = $sorted_sell_price_array[4];
		my $Sell5OrderQty = 0;
		if ($Sell5OrderPrice > 0) {
			$Sell5OrderQty = $sell_price_hash{$Sell5OrderPrice};
		}
		
		if ($Sell1OrderPrice == 987654321) {
			$Sell1OrderPrice = 0;
		}
		if ($Sell2OrderPrice == 987654321) {
			$Sell2OrderPrice = 0;
		}
		if ($Sell3OrderPrice == 987654321) {
			$Sell3OrderPrice = 0;
		}
		if ($Sell4OrderPrice == 987654321) {
			$Sell4OrderPrice = 0;
		}
		if ($Sell5OrderPrice == 987654321) {
			$Sell5OrderPrice = 0;
		}

		printf (OUTFILE "$ContractID,$LastPrice,$MatchTotQty,$OpenInterest,$GenTime,$Buy5OrderPrice,$Buy5OrderQty,$Buy4OrderPrice,$Buy4OrderQty,$Buy3OrderPrice,$Buy3OrderQty,$Buy2OrderPrice,$Buy2OrderQty,$Buy1OrderPrice,$Buy1OrderQty,$Sell1OrderPrice,$Sell1OrderQty,$Sell2OrderPrice,$Sell2OrderQty,$Sell3OrderPrice,$Sell3OrderQty,$Sell4OrderPrice,$Sell4OrderQty,$Sell5OrderPrice,$Sell5OrderQty\n"); 
	} #end while

	close OUTFILE;
	close FILE;
}

`mv $ARGV[0]/*$ARGV[1].out $ARGV[0]/$ARGV[1]`;
