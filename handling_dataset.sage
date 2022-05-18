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
ITEMS_MQ = [];
MAX_USED_VARS = 16;
MAX_NUM_EQ = 32;
DATASET_SAMPLES_NUM = 3;
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

# for INDEX_eq in range(DATASET_SAMPLES_NUM):
#     print("reading EQUATION :"+str(INDEX_eq) + " --- " +str(DATASET_SAMPLES_NUM));
#     EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".coeff",ITEMS_MQ + [1]);
#     SOLV_MQ = mq_solv_reading(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".solv",ITEMS_VARS_USED);
#     print_equations(EQUATIONS_MQ);
#     print_dict(SOLV_MQ);

# # ------------ vali ------------------
# for INDEX_eq in range(DATASET_SAMPLES_NUM):
#     print("reading EQUATION :"+str(INDEX_eq) + " --- " +str(DATASET_SAMPLES_NUM));
#     EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".coeff",ITEMS_MQ + [1]);
#     SOLV_MQ = mq_solv_reading(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".solv",ITEMS_VARS_USED);
#     eqs_obj = Mq_Equations_Obj(EQUATIONS_MQ,ITEMS_MQ+[1]);
#     eqs_obj.subs_part_solv(SOLV_MQ);
#     print_equations(eqs_obj.EQUATIONS_MQ);

# ------------ functions test ------------------
# for INDEX_eq in range(DATASET_SAMPLES_NUM):
#     print("reading EQUATION :"+str(INDEX_eq) + " --- " +str(DATASET_SAMPLES_NUM));
#     EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".coeff",ITEMS_MQ + [1]);
#     SOLV_MQ = mq_solv_reading(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".solv",ITEMS_VARS_USED);
#     eqs_obj = Mq_Equations_Obj(EQUATIONS_MQ,ITEMS_MQ+[1]);
#     eqs_obj.subs_part_solv({ITEMS_VARS_USED[0]:SOLV_MQ[ITEMS_VARS_USED[0]]});
#     print_coeffs_mat(eqs_obj.get_current_coeff());

# # ------------ dataset for model_vae ------------------
# DATASET_FOR_VAE = [];
# if len(ITEMS_MQ+[1])%2==1: ADD_ONE_ZERO = True;
# for INDEX_eq in range(DATASET_SAMPLES_NUM):
#     print("reading EQUATION :"+str(INDEX_eq) + " --- " +str(DATASET_SAMPLES_NUM));
#     EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".coeff",ITEMS_MQ + [1]);
#     SOLV_MQ = mq_solv_reading(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".solv",ITEMS_VARS_USED);
#     eqs_obj = Mq_Equations_Obj(EQUATIONS_MQ,ITEMS_MQ+[1]);
#     for INDEX_i in range(len(ITEMS_VARS_USED)):
#         eqs_obj.subs_part_solv({ITEMS_VARS_USED[INDEX_i]:SOLV_MQ[ITEMS_VARS_USED[INDEX_i]]});
#         COEFFS = eqs_obj.get_current_coeff();
#         if ADD_ONE_ZERO:COEFFS = [COEFF + [0] for COEFF in COEFFS];
#         DATASET_FOR_VAE.append( COEFFS );
# DATASET_FOR_VAE = np.array(DATASET_FOR_VAE,dtype=float);
# print(DATASET_FOR_VAE.shape);
# np.save("DATASET_FOR_VAE", DATASET_FOR_VAE);

# # ------------ pre-dataset for MODEL_ACT ------------------
# DATASET_FOR_ACT_PRE = [];
# if len(ITEMS_MQ+[1])%2==1: ADD_ONE_ZERO = True;
# for INDEX_eq in range(DATASET_SAMPLES_NUM):
#     print("reading EQUATION :"+str(INDEX_eq) + " --- " +str(DATASET_SAMPLES_NUM));
#     EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".coeff",ITEMS_MQ + [1]);
#     SOLV_MQ = mq_solv_reading(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".solv",ITEMS_VARS_USED);
#     eqs_obj = Mq_Equations_Obj(EQUATIONS_MQ,ITEMS_MQ+[1]);
#     for INDEX_i in range(len(ITEMS_VARS_USED)):
#         COEFFS_init = eqs_obj.get_current_coeff();
#         eqs_obj.subs_part_solv({ITEMS_VARS_USED[INDEX_i]:SOLV_MQ[ITEMS_VARS_USED[INDEX_i]]});
#         SOLV_ACT = [0]*len(ITEMS_VARS_USED);
#         if SOLV_MQ[ITEMS_VARS_USED[INDEX_i]]==1:SOLV_ACT[INDEX_i] = 1;
#         if SOLV_MQ[ITEMS_VARS_USED[INDEX_i]]==0:SOLV_ACT[INDEX_i] = -1;
#         COEFFS_subs = eqs_obj.get_current_coeff();
#         if ADD_ONE_ZERO:
#             COEFFS_init = [COEFF + [0] for COEFF in COEFFS_init];
#             COEFFS_subs = [COEFF + [0] for COEFF in COEFFS_subs];
#         DATASET_FOR_ACT_PRE.append( [ np.array(SOLV_ACT,dtype=float), np.array(COEFFS_init,dtype=float), np.array(COEFFS_subs,dtype=float)] );
# DATASET_FOR_ACT_PRE = np.array(DATASET_FOR_ACT_PRE);
# print(DATASET_FOR_ACT_PRE.shape);
# np.save("DATASET_FOR_ACT_PRE", DATASET_FOR_ACT_PRE);

# ------------ dataset for model_est ------------------
DATASET_FOR_EST = [];
if len(ITEMS_MQ+[1])%2==1: ADD_ONE_ZERO = True;
for INDEX_eq in range(DATASET_SAMPLES_NUM):
    print("reading EQUATION :"+str(INDEX_eq) + " --- " +str(DATASET_SAMPLES_NUM));
    EQUATIONS_MQ = mq_coeff_2_poly(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".coeff",ITEMS_MQ + [1]);
    SOLV_MQ = mq_solv_reading(SAVED_PATH + "/mq_eqs_"+str(INDEX_eq)+".solv",ITEMS_VARS_USED);
    eqs_obj = Mq_Equations_Obj(EQUATIONS_MQ,ITEMS_MQ+[1]);
    for INDEX_i in range(len(ITEMS_VARS_USED)):
        # ---------- Right Solv --------------
        eqs_obj_right = copy.copy(eqs_obj);
        eqs_obj_right.subs_part_solv({ITEMS_VARS_USED[INDEX_i]:SOLV_MQ[ITEMS_VARS_USED[INDEX_i]]});
        COEFFS = eqs_obj_right.get_current_coeff();
        if ADD_ONE_ZERO:COEFFS = [COEFF + [0] for COEFF in COEFFS];
        DATASET_FOR_EST.append( [ np.array(COEFFS,dtype=float), np.array([1,0],dtype=float) ] );
        # print(eqs_obj.EQUATIONS_MQ[1]  == eqs_obj_right.EQUATIONS_MQ[1]); # vali not the deepcopy;
        # ---------- Wrong Solv --------------
        eqs_obj_wrong = copy.copy(eqs_obj);
        eqs_obj_wrong.subs_part_solv({ITEMS_VARS_USED[INDEX_i]:1-SOLV_MQ[ITEMS_VARS_USED[INDEX_i]]});
        COEFFS = eqs_obj_wrong.get_current_coeff();
        if ADD_ONE_ZERO:COEFFS = [COEFF + [0] for COEFF in COEFFS];
        DATASET_FOR_EST.append( [ np.array(COEFFS,dtype=float), np.array([0,1],dtype=float) ] );
        # print(eqs_obj.EQUATIONS_MQ[1]  == eqs_obj_wrong.EQUATIONS_MQ[1]); # vali not the deepcopy;
        # ---------- Updating --------------
        eqs_obj.subs_part_solv({ITEMS_VARS_USED[INDEX_i]:SOLV_MQ[ITEMS_VARS_USED[INDEX_i]]});
DATASET_FOR_EST = np.array(DATASET_FOR_EST);
print(DATASET_FOR_EST.shape);
np.save("DATASET_FOR_EST_PRE", DATASET_FOR_EST);