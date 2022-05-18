#!/usr/bin/env python
# -*- coding: utf-8 -*-

__ENV__  =  'sage';
__author__ =  'hanss401';

import os;
from sage.misc.python import Python;

#  ---- Hack to import my own sage scripts; ----
def Import_Sage_File(module_name, func_name='*'):
    os.system('sage --preparse ' + module_name + '.sage');
    os.system('mv ' + module_name+'.sage.py ' + module_name+'.py');
    python = Python();
    python.eval('from ' + module_name + ' import ' + func_name, globals());

Import_Sage_File('handling_dataset_functions');

class Mq_Local_Search(object):
    """Using SMT-DPLL to solve MQ problem"""
    def __init__(self, MQ_PROBLEM_OBJ, ITEMS_VARS_USED):
        super(Mq_Local_Search, self).__init__();
        self.MQ_PROBLEM_OBJ  =  MQ_PROBLEM_OBJ;
        self.INIT_EQUATIONS_MQ  = self.MQ_PROBLEM_OBJ.EQUATIONS_MQ;
        self.ITEMS_VARS_USED = ITEMS_VARS_USED;
        self.SOLUTION = self.mq_random_solv();
        self.SOLUTION_TRY = self.SOLUTION;
        self.STATUS = 'NOT_SAT';
        self.RUNNING_TIMES = 0;
    
    def mq_random_solv(self):
        SOLUTION_TRY = {};
        for NEXT_VAR in self.ITEMS_VARS_USED:
            SOLUTION_TRY[NEXT_VAR] = np.random.randint(50)%2;
        return SOLUTION_TRY;    
    
    def mq_sat_eqs_num(self,SOLUTION_TRY):
        SAT_EQS_NUM = 0;
        for POLYNOMIAL in self.MQ_PROBLEM_OBJ.EQUATIONS_MQ:
            if POLYNOMIAL.subs(SOLUTION_TRY)==0:SAT_EQS_NUM+=1;
        return SAT_EQS_NUM;    

    def mq_local_search_main(self):
        self.SAT_EQS_NUM_MAX = self.mq_sat_eqs_num(self.SOLUTION_TRY);
        INDEX_i = 0;
        while(True):
            self.RUNNING_TIMES +=1;
            # --------- Local Searching -----------------
            self.SOLUTION_TRY[self.ITEMS_VARS_USED[INDEX_i]] = (self.SOLUTION_TRY[self.ITEMS_VARS_USED[INDEX_i]] +1 )%2;
            SAT_EQS_NUM = self.mq_sat_eqs_num(self.SOLUTION_TRY);
            # --------- updating ----------
            if SAT_EQS_NUM > self.SAT_EQS_NUM_MAX:
                self.SOLUTION = self.SOLUTION_TRY;
                self.SAT_EQS_NUM_MAX = SAT_EQS_NUM;
                INDEX_i = 0;continue;
            self.SOLUTION_TRY = self.SOLUTION; # updating or backtracing;
            INDEX_i += 1;
            # --------- solved ------------
            if self.SAT_EQS_NUM_MAX == len(self.MQ_PROBLEM_OBJ.EQUATIONS_MQ):
                self.STATUS = 'SAT';
                print('SOLUTION Found!!!!!!!!!!');
                print(self.SOLUTION);
                print('Cost Steps:' + str(self.RUNNING_TIMES));
                break;
            # --------- shifting ------------
            if INDEX_i == len(self.ITEMS_VARS_USED):
                INDEX_i = 0;
                self.SOLUTION = self.mq_random_solv();
                self.SOLUTION_TRY = self.SOLUTION;
                SAT_EQS_NUM = self.mq_sat_eqs_num(self.SOLUTION_TRY);
                self.SAT_EQS_NUM_MAX = SAT_EQS_NUM;
            # --------- printing ... ------------
            print('SAT_EQS_NUM_MAX = ' + str(self.SAT_EQS_NUM_MAX));
            print('SAT_EQS_NUM = ' + str(SAT_EQS_NUM));
            print('SOLUTION = ' + str(self.SOLUTION));

# ======== TEST LS-Solver ========
ITEMS_MQ = [];
MAX_USED_VARS = 8;
MAX_NUM_EQ = 16;
DATASET_SAMPLES_NUM = 5;
SAVED_PATH = "./mq_dat_n" + str(MAX_USED_VARS) + "_m" + str(MAX_NUM_EQ);

ITEMS_VARS_USED = ITEMS_T[0:MAX_USED_VARS];
for INDEX_i in range(len(ITEMS_VARS_USED)):
    for INDEX_j in range(len(ITEMS_VARS_USED)):
        if INDEX_i>=INDEX_j:continue;
        ITEMS_MQ.append(ITEMS_VARS_USED[INDEX_i] * ITEMS_VARS_USED[INDEX_j]);
# --------- make 2-rd dummy item --------------
DUMMY_2rd_TAB = {};
for INDEX_i in range(len(ITEMS_MQ)):DUMMY_2rd_TAB[ITEMS_MQ[INDEX_i]] = ITEMS_C[INDEX_i];

ITEMS_MQ = ITEMS_MQ + ITEMS_VARS_USED;
EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_0.coeff",ITEMS_MQ + [1]);
MQ_PROBLEM_OBJ = Mq_Equations_Obj(EQUATIONS_MQ,ITEMS_MQ+[1]);
MQ_LS_OBJ = Mq_Local_Search(MQ_PROBLEM_OBJ, ITEMS_VARS_USED);
MQ_LS_OBJ.mq_local_search_main();
