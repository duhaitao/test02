/*
-------------------------------------------------------------------------
   This file is part of BayesOpt, an efficient C++ library for
   Bayesian optimization.

   Copyright (C) 2011-2013 Ruben Martinez-Cantin <rmcantin@unizar.es>

   BayesOpt is free software: you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   BayesOpt is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with BayesOpt.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------
*/

#ifndef _GT4CSCRFC2_H_
#define _GT4CSCRFC2_H_

#include <boost/numeric/ublas/vector.hpp>

struct ARG {
	char arg1[1000];
        char arg2[1000];
        char arg3[1000];
        char arg4[1000];
};

typedef boost::numeric::ublas::vector<double>                   vectord;

class GT4CSCRFC2
{
 public:

	///construction
	GT4CSCRFC2();

public:

	void WekaInfoGain(
			char const* strTrainDataFileName,
			char const* strNumOfAttribute,
			char const* strLogName
			);
	void WekaClassicRandom(
			);

	void WekaSplitData(
			char const* strDataFileName,
			char const* strTrainFileName,
			char const* strValidFileName,
			char const* strSplitPercentage
			);

	void WekaFeatureSelection(
			char const* strDataFileName,
			char const* strAttributes,
			char const* strAFSFileName
			);

	void WekaCSCRFBuildModelC2(
			char const* strCost,
			char const* strTrainDataFileName,
			char const* strModelName,
			char const* strLogName,
			char const* strNumberOfTrees,
			char const* strNumberOfFeatures,
			char const* strSeedForRandomNumberGenerator,
			char const* strMaximumDepthOfTrees,
			char const* strNumberOfExecutionSlots
			);

#if 0
	void WekaReevaluateC2(
			char const* strOriginalTestDataFileName,
			char const* strTestDataFileName,
			char const* strModelName,
			char const* strLogName
			);
#endif

	void WekaPCA3Files(
			);

	double RunSingleTest( const vectord &Xi );

};

int RunGT4CSCRFC2(int argc, char * argv[]);

#endif //_GT4CSCRFC2_H_
