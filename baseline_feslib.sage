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

# ============================== STEP 1:reading and handling mq dataset ===================================
ITEMS_MQ = [];ITEMS_MQ_D32 = [];
MAX_USED_VARS = 36;
MAX_NUM_EQ = 32;
DATASET_SAMPLES_NUM = 20;
SAVED_PATH = "./mq_dat_n" + str(MAX_USED_VARS) + "_m" + str(MAX_NUM_EQ);

ITEMS_VARS_USED = ITEMS_Z[0:MAX_USED_VARS];
for INDEX_i in range(len(ITEMS_VARS_USED)):
    for INDEX_j in range(len(ITEMS_VARS_USED)):
        if INDEX_i>=INDEX_j:continue;
        ITEMS_MQ.append(ITEMS_VARS_USED[INDEX_i] * ITEMS_VARS_USED[INDEX_j]);

ITEMS_MQ = ITEMS_MQ + ITEMS_VARS_USED;

ITEMS_VARS_USED_N32 = ITEMS_Z[0:32];
for INDEX_i in range(len(ITEMS_VARS_USED_N32)):
    for INDEX_j in range(len(ITEMS_VARS_USED_N32)):
        if INDEX_i>=INDEX_j:continue;
        ITEMS_MQ_D32.append(ITEMS_VARS_USED_N32[INDEX_i] * ITEMS_VARS_USED_N32[INDEX_j]);

ITEMS_MQ_D32 = ITEMS_MQ_D32 + ITEMS_VARS_USED_N32;

ITEMS_VARS_ERGODIC = [ITEM_VAR for ITEM_VAR in ITEMS_VARS_USED if ITEM_VAR not in ITEMS_VARS_USED_N32];

# ------------ Wu Method Charastic Sets Reduction Deep-First Searching ------------------
EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_"+str(1)+".coeff",ITEMS_MQ + [1]);
#print_equations(EQUATIONS_MQ);exit(1);

"""
NUM_RELATED_SYS = MAX_USED_VARS - 32;
SOLUTIONS_ALL = [];
for INDEX_i in range(2**NUM_RELATED_SYS):
    print("making SOLUTIONs :  --- " + str(float(INDEX_i)/(2**NUM_RELATED_SYS)) + " --- " );
    SOLUTION = {};
    VALUE_LIST = list( str(bin(INDEX_i)).replace('0b','') );
    LEN_TO_ADD = len(ITEMS_VARS_ERGODIC) - len(VALUE_LIST);
    for INDEX_j in range(LEN_TO_ADD):VALUE_LIST.append('0');
    for INDEX_j in range(len(ITEMS_VARS_ERGODIC)):
        SOLUTION[ ITEMS_VARS_ERGODIC[INDEX_j] ] = int( VALUE_LIST[INDEX_j] );
    SOLUTIONS_ALL.append(SOLUTION);
#print(SOLUTIONS_ALL);exit(1);

# --- Solutions to Coeff Matrixes ---
EQUATIONS_MQ_N32_ALL = [];
for INDEX_i in range(len(SOLUTIONS_ALL)):
    print("subs SOLUTIONs :  --- " + str( float(INDEX_i)/len(SOLUTIONS_ALL) ) + " --- " );
    EQUATIONS_MQ_N32 = [POLYNOMIAL.subs(SOLUTIONS_ALL[INDEX_i]) for POLYNOMIAL in EQUATIONS_MQ];
    #with open("__STORAGE__/equations_mq_of_n" + str(MAX_USED_VARS) + "_" + str(INDEX_i) + ".pkl", 'wb') as FILE_EQUATIONSS_MQ:
    #    pkl.dump(EQUATIONS_MQ_N32, FILE_EQUATIONSS_MQ, pkl.HIGHEST_PROTOCOL);
    EQUATIONS_MQ_N32_ALL.append(EQUATIONS_MQ_N32);

COEFFS_MQ_N32_ALL = [];
for INDEX_i in range(len(EQUATIONS_MQ_N32_ALL)):
    print("translated to coeff :  --- " + str( float(INDEX_i)/len(EQUATIONS_MQ_N32_ALL) ) + " --- " );
    COEFF_MQ_N32,VALI_RES = eq_2_co(EQUATIONS_MQ_N32_ALL[INDEX_i],ITEMS_MQ_D32+[1]);
    COEFFS_MQ_N32_ALL.append(COEFF_MQ_N32);

import pickle as pkl;
# --- save COEFFS_MQ_N32_ALL ---
with open("coeffs_of_n" + str(MAX_USED_VARS) + ".pkl", 'wb') as FILE_SOLUTION:
    pkl.dump(COEFFS_MQ_N32_ALL, FILE_SOLUTION, pkl.HIGHEST_PROTOCOL);
"""

import pickle as pkl;
# --- load COEFFS_MQ_N32_ALL ---
with open("coeffs_of_n" + str(MAX_USED_VARS) + ".pkl", 'rb') as FILE_SOLUTION:
  COEFFS_MQ_N32_ALL = pkl.load(FILE_SOLUTION);
# print(len(COEFFS_MQ_N32_ALL));print(len(COEFFS_MQ_N32_ALL[0]));print(len(COEFFS_MQ_N32_ALL[0][0]));

# --- Coeff Matrixes to  ---
DIM_QUATRATIC_TERMS = 496;
DIM_LINEAR_TERMS    =  33;
DIM_EQUATIONS       =  32;
FQ_ARRAY = [];FL_ARRAY = [];
for INDEX_i in range(DIM_QUATRATIC_TERMS):
    BIN_STR = '';
    for INDEX_j in range(DIM_EQUATIONS):
        BIN_STR += str(COEFFS_MQ_N32_ALL[0][INDEX_j][INDEX_i]);
    FQ_NUM = int(BIN_STR,2);print(BIN_STR);print(FQ_NUM);
    FQ_ARRAY.append(FQ_NUM);
#print(FQ_ARRAY);print(len(FQ_ARRAY));
for INDEX_m in range(len(COEFFS_MQ_N32_ALL)):
    for INDEX_i in range(DIM_QUATRATIC_TERMS,DIM_QUATRATIC_TERMS+DIM_LINEAR_TERMS):
        BIN_STR = '';
        for INDEX_j in range(DIM_EQUATIONS):
            BIN_STR += str(COEFFS_MQ_N32_ALL[INDEX_m][INDEX_j][INDEX_i]);
        FL_NUM = int(BIN_STR,2);
        FL_ARRAY.append(FL_NUM);
    TMP_NUM = FL_ARRAY[-1];FL_ARRAY[-1] = FL_ARRAY[-DIM_LINEAR_TERMS];FL_ARRAY[-DIM_LINEAR_TERMS] = TMP_NUM;
#print(FL_ARRAY);print(len(FL_ARRAY));
exit(1);

# --- Write Into File ---
with open('fq_and_fl_array.dat','w') as FILEOUT:
    for FQ_NUM in FQ_ARRAY:
        FILEOUT.write(str(FQ_NUM));FILEOUT.write(',');
    for FL_NUM in FL_ARRAY:
        FILEOUT.write(str(FL_NUM));FILEOUT.write(',');