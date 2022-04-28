#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Created on Thu Apr 28 09:57:19 2022

@author: Hanss401
"""

__ENV__  =  'py3';
__author__ =  'hanss401';

import numpy as np;
import keras;
from keras import layers,Model,models,utils;
from keras.models import load_model;
from keras import backend as K;
from keras.datasets import mnist;
import sys;

__ENV__  =  'py3';
__author__ =  'hanss401';

import numpy as np;
import keras;
from keras import layers,Model,models,utils;
from keras.models import load_model;
from keras import backend as K;
from keras.datasets import mnist;
import sys;

# ======================= MODEL_VAE =======================  
IMG_SHAPE = (32,138,1); # note that the dim should be even;
LATENT_DIM = 10;

input_img = layers.Input(shape=IMG_SHAPE)
x = layers.Conv2D(32,3,padding='same',activation='relu')(input_img)
x = layers.Conv2D(64,3,padding='same',activation='relu',strides=2)(x)
x = layers.Conv2D(64,3,padding='same',activation='relu')(x)
x = layers.Conv2D(64,3,padding='same',activation='relu')(x)
inter_shape = K.int_shape(x);
x = layers.Flatten()(x);
x = layers.Dense(32,activation='relu')(x);

encode_mean = layers.Dense(LATENT_DIM,name = 'encode_mean')(x); # 分布均值
encode_log_var = layers.Dense(LATENT_DIM,name = 'encode_logvar')(x); # 分布对数方差

encoder = Model(input_img,[encode_mean,encode_log_var],name = 'encoder')

# Decoder
input_code = layers.Input(shape=[LATENT_DIM]);
x = layers.Dense(np.prod(inter_shape[1:]),activation='relu')(input_code);
x = layers.Reshape(target_shape=inter_shape[1:])(x);
x = layers.Conv2DTranspose(32,3,padding='same',activation='relu',strides=2)(x);
x = layers.Conv2D(1,3,padding='same',activation='sigmoid')(x);

decoder = Model(input_code,x,name = 'decoder');

# Training
def sampling(arg):
    mean = arg[0];
    logvar = arg[1];
    epsilon = K.random_normal(shape=K.shape(mean),mean=0.,stddev=1.); # 从标准正态分布中抽样
    return mean + K.exp(0.5*logvar) * epsilon; # 获取生成分布的抽样

input_img = layers.Input(shape=IMG_SHAPE,name = 'img_input');
code_mean, code_log_var = encoder(input_img); # 获取生成分布的均值与方差
x = layers.Lambda(sampling,name = 'sampling')([code_mean, code_log_var]);
x = decoder(x);
MODEL_VAE = Model(input_img,x,name = 'MODEL_VAE');
 
decode_loss = keras.metrics.binary_crossentropy(K.flatten(input_img), K.flatten(x));
kl_loss = -5e-4*K.mean(1+code_log_var-K.square(code_mean)-K.exp(code_log_var));
MODEL_VAE.add_loss(K.mean(decode_loss+kl_loss)); # 新出的方法,方便得很;
MODEL_VAE.compile(optimizer='rmsprop');

COEFF_TRAIN = np.load('DATASET_FOR_VAE.npy');
COEFF_TRAIN = COEFF_TRAIN[:,:,:,np.newaxis];

MODEL_VAE.load_weights('MODEL_VAE_weights.h5');
# print(MODEL_VAE.predict(COEFF_TRAIN[7:9]).shape); # (2, 32, 138, 1);

# print(MODEL_VAE.input.name);print(MODEL_VAE.layers[3].name);sys.exit(1);


MODEL_VAE_ENCODE = Model(inputs=MODEL_VAE.layers[1].input, outputs=MODEL_VAE.layers[1].output);
# COEFF_init_encoded = MODEL_VAE_ENCODE.predict(COEFF_TRAIN[11:19])[0]; 

MODEL_VAE_DECODE = Model(inputs=MODEL_VAE.layers[3].input, outputs=MODEL_VAE.layers[3].output);
# print( MODEL_VAE_DECODE.predict([COEFF_init_encoded]) );

# ==== processing the data for MODEL_ACT ====
DATASET_FOR_ACT_PRE = np.load('DATASET_FOR_ACT_PRE.npy',allow_pickle=True);
DATASET_FOR_ACT = [];
for INDEX_i in range(DATASET_FOR_ACT_PRE.shape[0]):
    COEFF_init_encoded = MODEL_VAE_ENCODE.predict(np.array([ DATASET_FOR_ACT_PRE[INDEX_i][1] ]))[0][0];
    COEFF_subs_encoded = MODEL_VAE_ENCODE.predict(np.array([ DATASET_FOR_ACT_PRE[INDEX_i][2] ]))[0][0];
    DATASET_FOR_ACT.append([ DATASET_FOR_ACT_PRE[INDEX_i][0], COEFF_init_encoded, COEFF_subs_encoded]);
DATASET_FOR_ACT = np.array(DATASET_FOR_ACT);
np.save("DATASET_FOR_ACT", DATASET_FOR_ACT);