#include "GT4CSCRFC2.h"

#include <assert.h>
#include <string>
#include <fstream>
#include <stdlib.h>
//#include "CSVFile.h"
/// #include <boost/numeric/ublas/assignment.hpp>
/// #include <boost/numeric/ublas/matrix_proxy.hpp>  // For row()
#include "boost/numeric/ublas/assignment.hpp"
#include "boost/numeric/ublas/matrix_proxy.hpp"  // For row()

using namespace std;

/// construction
GT4CSCRFC2::GT4CSCRFC2()
{

};

void GT4CSCRFC2::WekaInfoGain(
		char const* strTrainDataFileName,
		char const* strNumOfAttribute,
		char const* strLogName
		)
{
	char CMD[1000];
	sprintf(CMD,"./Modeling WekaInfoGain %s %s %s",strTrainDataFileName,strNumOfAttribute,strLogName);
	system(CMD);
}

void GT4CSCRFC2::WekaClassicRandom(
		)
{
	char CMD[1000];
	sprintf(CMD,"./Modeling WekaClassicRandom"
			);
	system(CMD);
}

void GT4CSCRFC2::WekaSplitData(
		char const* strDataFileName,
		char const* strTrainFileName,
		char const* strValidFileName,
		char const* strSplitPercentage
		)
{
	char CMD[1000];
	sprintf(CMD,"./Modeling WekaSplitData %s %s %s %d",strDataFileName,strTrainFileName,strValidFileName,atoi (strSplitPercentage));
	system(CMD);
}

void GT4CSCRFC2::WekaFeatureSelection(
		char const* strDataFileName,
		char const* strAttributes,
		char const* strAFSFileName
		)
{
	char CMD[1000];
	sprintf(CMD,"./Modeling WekaFeatureSelection %s \"%s\" %s",strDataFileName,strAttributes,strAFSFileName);
	system(CMD);
}

void GT4CSCRFC2::WekaCSCRFBuildModelC2(
		char const* strCost,
		char const* strTrainDataFileName,
		char const* strModelName,
		char const* strLogName,
		char const* strNumberOfTrees,
		char const* strNumberOfFeatures,
		char const* strSeedForRandomNumberGenerator,
		char const* strMaximumDepthOfTrees,
		char const* strNumberOfExecutionSlots
		)
{
	//JavaVM* m_pJavaVM = create_vm();

	if(atof(strCost)>0)
	{
		char CMD[1000];
		sprintf(CMD,"./Modeling WekaCSCRFBuildModelC2 0 %s 1 0 %s %s %s %s %s %s %s %s",
				strCost,
				strTrainDataFileName,
				strModelName,
				strLogName,
				strNumberOfTrees,
				strNumberOfFeatures,
				strSeedForRandomNumberGenerator,
				strMaximumDepthOfTrees,
				strNumberOfExecutionSlots
				);
		system(CMD);
	}
	else
	{
		int iCost = atoi(strCost)*(-1);
		char chCost[100];
		sprintf(chCost,"%d",iCost);
		char CMD[1000];
		sprintf(CMD,"./Modeling WekaCSCRFBuildModelC2 0 1 %s 0 %s %s %s %s %s %s %s %s",
				chCost,
				strTrainDataFileName,
				strModelName,
				strLogName,
				strNumberOfTrees,
				strNumberOfFeatures,
				strSeedForRandomNumberGenerator,
				strMaximumDepthOfTrees,
				strNumberOfExecutionSlots
				);
		system(CMD);
	}
	//delete m_pJavaVM;
}

#if 0
void GT4CSCRFC2::WekaReevaluateC2(
		char const* strOriginalTestDataFileName,
		char const* strTestDataFileName,
		char const* strModelName,
		char const* strLogName
		)
#endif
void *WekaReevaluateC2 (void *data)
{
	ARG *pArg = (ARG *)data;

	char CMD[1000];
	snprintf(CMD, 1000, "./Modeling WekaReevaluateC2 %s %s %s %s",
			pArg->arg1, pArg->arg2, pArg->arg3, pArg->arg4);
	printf ("%s\n", CMD);
#if 0
	sprintf(CMD,"./Modeling WekaReevaluateC2 %s %s %s %s",
			strOriginalTestDataFileName,
			strTestDataFileName,
			strModelName,
			strLogName
			);
#endif
	system(CMD);
}

void GT4CSCRFC2::WekaPCA3Files(
		)
{
	char CMD[1000];
	sprintf(CMD,"./Modeling WekaPCA3Files"
			);
	system(CMD);
}

double GT4CSCRFC2::RunSingleTest( const vectord &Xi )
{
	//return 300-(Xi(0)+Xi(1)+Xi(2)+Xi(3)+Xi(4)+Xi(5));

	//system("rm -rf /tmp/*");

	char chModelName[1000];
	char chBuildModelLogName[1000];
	char chValidateLogName[1000];
	char chTest1LogName[1000];
	char chTest2LogName[1000];
	char chTest3LogName[1000];

	char chCost[100];
	char chNumberOfTrees[100];
	char chNumberOfFeatures[100];
	char chSeedForRandomNumberGenerator[100];
	char chMaximumDepthOfTrees[100];
	char chNumberOfExecutionSlots[100];

	int iCost = Xi(0);
	int iNumberOfTrees = Xi(1);
	int iNumberOfFeatures = Xi(2);
	int iSeedForRandomNumberGenerator = Xi(3);
	int iMaximumDepthOfTrees = Xi(4);
	int iNumberOfExecutionSlots = Xi(5);

	sprintf(chCost,"%d",iCost);
	sprintf(chNumberOfTrees,"%d",iNumberOfTrees);
	sprintf(chNumberOfFeatures,"%d",iNumberOfFeatures);
	sprintf(chSeedForRandomNumberGenerator,"%d",iSeedForRandomNumberGenerator);
	sprintf(chMaximumDepthOfTrees,"%d",iMaximumDepthOfTrees);
	sprintf(chNumberOfExecutionSlots,"%d",iNumberOfExecutionSlots);

	sprintf(chModelName,"../log/[%d-%d-%d-%d-%d-%d].model",
			iCost, iNumberOfTrees,iNumberOfFeatures,iSeedForRandomNumberGenerator, iMaximumDepthOfTrees, iNumberOfExecutionSlots);
	sprintf(chBuildModelLogName,"../log/[%d-%d-%d-%d-%d-%d].BuildModel.log",
			iCost, iNumberOfTrees,iNumberOfFeatures,iSeedForRandomNumberGenerator, iMaximumDepthOfTrees, iNumberOfExecutionSlots);
	sprintf(chValidateLogName,"../log/[%d-%d-%d-%d-%d-%d].Validate.log",
			iCost, iNumberOfTrees,iNumberOfFeatures,iSeedForRandomNumberGenerator, iMaximumDepthOfTrees, iNumberOfExecutionSlots);
	sprintf(chTest1LogName,"../log/[%d-%d-%d-%d-%d-%d].Test1.log",
			iCost, iNumberOfTrees,iNumberOfFeatures,iSeedForRandomNumberGenerator, iMaximumDepthOfTrees, iNumberOfExecutionSlots);
	sprintf(chTest2LogName,"../log/[%d-%d-%d-%d-%d-%d].Test2.log",
			iCost, iNumberOfTrees,iNumberOfFeatures,iSeedForRandomNumberGenerator, iMaximumDepthOfTrees, iNumberOfExecutionSlots);
	sprintf(chTest3LogName,"../log/[%d-%d-%d-%d-%d-%d].Test3.log",
			iCost, iNumberOfTrees,iNumberOfFeatures,iSeedForRandomNumberGenerator, iMaximumDepthOfTrees, iNumberOfExecutionSlots);

	assert(Xi.size()==6);
#if 1
	WekaCSCRFBuildModelC2(
			chCost,
			"../data/train.afs.arff",
			chModelName,
			chBuildModelLogName,
			chNumberOfTrees,
			chNumberOfFeatures,
			chSeedForRandomNumberGenerator,
			chMaximumDepthOfTrees,
			chNumberOfExecutionSlots
			);
#endif

	
	pthread_t t1, t2, t3, t4;

	ARG argt1;
	snprintf (argt1.arg1, 1000, "../data/validate.csv");
	snprintf (argt1.arg2, 1000, "../data/validate.afs.arff");
	snprintf (argt1.arg3, 1000, "%s", chModelName);
	snprintf (argt1.arg4, 1000, "%s", chValidateLogName);
	pthread_create (&t1, NULL, WekaReevaluateC2, (void *)&argt1);

	ARG argt2;
	snprintf (argt2.arg1, 1000, "../data/test1.csv");
	snprintf (argt2.arg2, 1000, "../data/test1.afs.arff");
	snprintf (argt2.arg3, 1000, "%s", chModelName);
	snprintf (argt2.arg4, 1000, "%s", chTest1LogName);
	pthread_create (&t2, NULL, WekaReevaluateC2, (void *)&argt2);

	ARG argt3;
	snprintf (argt3.arg1, 1000, "../data/test2.csv");
	snprintf (argt3.arg2, 1000, "../data/test2.afs.arff");
	snprintf (argt3.arg3, 1000, "%s", chModelName);
	snprintf (argt3.arg4, 1000, "%s", chTest2LogName);
	pthread_create (&t3, NULL, WekaReevaluateC2, (void *)&argt3);

	ARG argt4;
	snprintf (argt4.arg1, 1000, "../data/test3.csv");
	snprintf (argt4.arg2, 1000, "../data/test3.afs.arff");
	snprintf (argt4.arg3, 1000, "%s", chModelName);
	snprintf (argt4.arg4, 1000, "%s", chTest3LogName);
	pthread_create (&t4, NULL, WekaReevaluateC2, (void *)&argt4);

	pthread_join (t1, NULL);
	pthread_join (t2, NULL);
	pthread_join (t3, NULL);
	pthread_join (t4, NULL);

	// model完成Reevaluate后就没有什么用处了，删除
	char tmp[1024];
	snprintf(tmp, 1024, "rm -f %s", chModelName);
	system (tmp);
	// 临时文件也没有人再使用了，删除
	system ("rm -f /tmp/0*.tmp");


#if 0
	WekaReevaluateC2(
			"../data/validate.csv",
			"../data/validate.afs.arff",
			chModelName,
			chValidateLogName
			);

	WekaReevaluateC2(
			"../data/test1.csv",
			"../data/test1.afs.arff",
			chModelName,
			chTest1LogName
			);
	WekaReevaluateC2(
			"../data/test2.csv",
			"../data/test2.afs.arff",
			chModelName,
			chTest2LogName
			);
	WekaReevaluateC2(
			"../data/test3.csv",
			"../data/test3.afs.arff",
			chModelName,
			chTest3LogName
			);
#endif
	return 0;

};


int RunGT4CSCRFC2(int argc, char * argv[])
{
	//system("rm -rf /tmp/*");

	string strSplitFileName = "../data/split.csv";
	string strTrainFileName = "../data/train.csv";
	string strValidateFileName = "../data/validate.csv";
	string strTest1FileName = "../data/test1.csv";
	string strTest2FileName = "../data/test2.csv";
	string strTest3FileName = "../data/test3.csv";

    GT4CSCRFC2 * pGT4CSCRFC2 = new GT4CSCRFC2();
    vectord result(6);

	///---=== STEP 1 : InfoGain ===---///
 //   pGT4CSCRFC2->WekaSplitData(strSplitFileName.data(),strTrainFileName.data(),strValidateFileName.data(),"66");
 //   pGT4CSCRFC2->WekaClassicRandom();
 //   pGT4CSCRFC2->WekaInfoGain(strTrainFileName.data(), "30", "../data/attr.txt");
 //   pGT4CSCRFC2->WekaPCA3Files();

	///---=== STEP 2 : FeatureSelection ===---///
#if 0
    char chAttr[10000];
    ifstream AttrInputFile;
    AttrInputFile.open("../data/attr.txt",std::ios_base::in);
    AttrInputFile.getline(chAttr,1000);
    printf("%s\n",chAttr);
    pGT4CSCRFC2->WekaFeatureSelection(strTrainFileName.data(),chAttr,"../data/train.afs.arff");
    pGT4CSCRFC2->WekaFeatureSelection(strValidateFileName.data(),chAttr,"../data/validate.afs.arff");
    pGT4CSCRFC2->WekaFeatureSelection(strTest1FileName.data(),chAttr,"../data/test1.afs.arff");
    pGT4CSCRFC2->WekaFeatureSelection(strTest2FileName.data(),chAttr,"../data/test2.afs.arff");
    pGT4CSCRFC2->WekaFeatureSelection(strTest3FileName.data(),chAttr,"../data/test3.afs.arff");
#endif

    ///---=== STEP 3 : Run ===---///
   // vecOfvec ParameterSet;
    /// para 1
//    vectord Cost(41);
//    Cost <<= -50,-45,-40,-35,-30,-25,-20,-18,-16,-14,-12,-10,-9,-8,-7,-6,-5,-4,-3,-2,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12,14,16,18,20,25,30,35,40,45,50;
//    vectord Cost(19);
//    Cost <<= -10,-9,-8,-7,-6,-5,-4,-3,-2,1, 2, 3, 4, 5, 6, 7, 8, 9, 10;
        //vectord Cost(13);
        vectord Cost(7);
        Cost <<= 1,2,3,4,5,6,7;
    /// para 2
    vectord NumberOfTrees(1);
    NumberOfTrees <<= 250;
    /// para 3
    vectord NumberOfFeatures(1);
    NumberOfFeatures <<= 2;
//    vectord NumberOfFeatures(6);
//    NumberOfFeatures <<= 1, 2, 3, 4, 5, 6;
    ///para 4
    vectord SeedForRandomNumberGenerator(1);
    SeedForRandomNumberGenerator <<= 1;
    /// para 5
//    vectord MaximumDepthOfTrees(12);
//    MaximumDepthOfTrees <<= 5,10,15,20,25,30,35,40,50,60,70,80;
        vectord MaximumDepthOfTrees(1);
        MaximumDepthOfTrees <<= 0;
    /// para 6
    vectord NumberOfExecutionSlots(1);
    NumberOfExecutionSlots <<= 6;

    for(size_t p1=0; p1<Cost.size();p1++)
    {
        for(size_t p2=0; p2<NumberOfTrees.size();p2++)
        {
            for(size_t p3=0; p3<NumberOfFeatures.size();p3++)
            {
                for(size_t p4=0; p4<SeedForRandomNumberGenerator.size();p4++)
                {
                    for(size_t p5=0; p5<MaximumDepthOfTrees.size();p5++)
                    {
                        for(size_t p6=0; p6<NumberOfExecutionSlots.size();p6++)
                        {
                        	vectord para(6);
                        	para <<= Cost(p1), NumberOfTrees(p2), NumberOfFeatures(p3), SeedForRandomNumberGenerator(p4), MaximumDepthOfTrees(p5), NumberOfExecutionSlots(p6);
                        	//ParameterSet.push_back(para);
                        	//std::cout << "para:" << para << std::endl;
                        	pGT4CSCRFC2->RunSingleTest(para);
                        }
                    }
                }
            }
        }
    }

    //delete pGT4CSCRFC2;

    return 0;
}
