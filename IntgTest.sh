#!/bin/bash

## 前提条件检查开始
if [ ! -d ../log ];then
	echo "计算log和model文件都要放到../log目录下，请检查此目录是否存在"
	exit 
fi

if [ ! -d ../data ];then
	echo "csv 文件一定要放入../data目录下"
	exit
fi

ret=0
ls -l ../data/*.csv >/dev/null 2>&1 || ret=1
if [ $ret -eq 1 ];then
	echo "csv 文件一定要放入../data目录下"
	exit
fi

for exe in CSCRFBuildModel.pl CSVMerge.pl FeatureSelection.pl Modeling
do
	if [ ! -x $exe ];then
		echo "$exe 不存在或者不能执行"
		exit
	fi
done

for jar in alternatingDecisionTrees.jar metaCost.jar weka.jar WekaTest.jar
do
	if [ ! -e $jar ];then
		echo "$jar 不存在"
		exit
	fi
done
### 前提条件检查完毕

read -p "输入TestCase个数:" TC
#echo $TC
read -p "训练文件包含天数:" M
read -p "训练文件间隔天数:" N

#while :
#do

echo "如果想并行运行测试的话，可以Up|Down|Flat之一，然后再运行此脚本一次，选择其他的"

	echo "请选择测试类型： "
	select TCClass in "Up" "Down" "Flat" "Up&&Down" "Up&&Flat" "Down&&Flat" "Up&&Down&&Flat" "exit"
	do
		break;
	done

	case $TCClass in
		"Up" )			
			./CSVMerge.pl ../data $TC 1 $M $N 1
			./FeatureSelection.pl ../data/Up/
			./CSCRFBuildModel.pl ../data/Up/;;
		"Down")			
			./CSVMerge.pl ../data $TC 2 $M $N 1
			./FeatureSelection.pl ../data/Down/
			./CSCRFBuildModel.pl ../data/Down/;;
		"Flat")			
			./CSVMerge.pl ../data $TC 3 $M $N 1
			./FeatureSelection.pl ../data/Flat/
			./CSCRFBuildModel.pl ../data/Flat/;;
		"Up&&Down")		
			./CSVMerge.pl ../data $TC 1 $M $N 1 
			./CSVMerge.pl ../data $TC 2 $M $N 1
			./FeatureSelection.pl ../data/Up/
			./CSCRFBuildModel.pl ../data/Up/
			./FeatureSelection.pl ../data/Down/
			./CSCRFBuildModel.pl ../data/Down/;;
		"Up&&Flat")		
			./CSVMerge.pl ../data $TC 1 $M $N 1 
			./CSVMerge.pl ../data $TC 3 $M $N 1
			./FeatureSelection.pl ../data/Up/
			./CSCRFBuildModel.pl ../data/Up/
			./FeatureSelection.pl ../data/Flat/
			./CSCRFBuildModel.pl ../data/Flat/;;
		"Down&&Flat")
			./CSVMerge.pl ../data $TC 2 $M $N 1
			./CSVMerge.pl ../data $TC 3 $M $N 1
			./FeatureSelection.pl ../data/Down/
			./CSCRFBuildModel.pl ../data/Down/
			./FeatureSelection.pl ../data/Flat/
			./CSCRFBuildModel.pl ../data/Flat/;;
		"Up&&Down&&Flat")
			./CSVMerge.pl ../data $TC 1 $M $N 1 
			./CSVMerge.pl ../data $TC 2 $M $N 1
			./CSVMerge.pl ../data $TC 3 $M $N 1
			./FeatureSelection.pl ../data/Up/
			./CSCRFBuildModel.pl ../data/Up/
			./FeatureSelection.pl ../data/Down/
			./CSCRFBuildModel.pl ../data/Down/
			./FeatureSelection.pl ../data/Flat/
			./CSCRFBuildModel.pl ../data/Flat/;;
		"exit")
			break
	esac
#done
