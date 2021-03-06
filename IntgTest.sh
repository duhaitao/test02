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

read -p "输入TestCase个数: " TC
#echo $TC
read -p "训练文件包含天数: " M
read -p "训练文件间隔天数: " N

read -p "构造模型时线程数量: " ThreadCount

#while :
#do

echo "如果想并行运行测试的话，可以Up|Down|Flat之一，然后再运行此脚本一次，选择其他的"

	echo "请选择测试类型： "
	select TCClass in "Up" "Down" "Flat" "exit"
	do
		break;
	done

	echo "请选择Model类型"
	select ModelType in "CSCRF" "MCRF"
	do
		break;
	done

	echo "选择矩阵类型: C11代表C11进行变化，其他类似"
	select MatrixType in "C11" "C12" "C21" "C22"
	do
		break;
	done

	echo "./CSVMerge.pl ../data $TC $TCClass $M $N 1 && ./FeatureSelection.pl ../data/$TCClass/ && ./${ModelType}BuildModel.pl ../data/$TCClass/ $MatrixType $ThreadCount 将在后台运行"
	./CSVMerge.pl ../data $TC $TCClass $M $N 1 && ./FeatureSelection.pl ../data/$TCClass/ && ./${ModelType}BuildModel.pl ../data/$TCClass/ $MatrixType $ThreadCount &
