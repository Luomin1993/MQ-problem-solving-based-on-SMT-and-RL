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
		
from sage.sat.converters.polybori import CNFEncoder
from sage.sat.solvers.dimacs import DIMACS

BOOLEAN_RING.<p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39,p40> = BooleanPolynomialRing()
ITEMS_BOOLEAN = [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,p32,p33,p34,p35,p36,p37,p38,p39,p40];

# ============================== STEP 1:reading and handling mq dataset ===================================
ITEMS_MQ = [];
MAX_USED_VARS = 16;
MAX_NUM_EQ = 32;
DATASET_SAMPLES_NUM = 20;
SAVED_PATH = "./mq_dat_n" + str(MAX_USED_VARS) + "_m" + str(MAX_NUM_EQ);

ITEMS_VARS_USED = ITEMS_BOOLEAN[0:MAX_USED_VARS];
for INDEX_i in range(len(ITEMS_VARS_USED)):
    for INDEX_j in range(len(ITEMS_VARS_USED)):
        if INDEX_i>=INDEX_j:continue;
        ITEMS_MQ.append(ITEMS_VARS_USED[INDEX_i] * ITEMS_VARS_USED[INDEX_j]);

ITEMS_MQ = ITEMS_MQ + ITEMS_VARS_USED;

EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_"+str(1)+".coeff",ITEMS_MQ + [1]);

IDEAL_MAIN = ideal(EQUATIONS_MQ);
GB_MAIN = IDEAL_MAIN.groebner_basis();
print_equations(GB_MAIN);