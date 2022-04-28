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
#import tensorflow as tf;
#tf.compat.v1.disable_eager_execution();

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
input_code = layers.Input(shape=[LATENT_DIM])
x = layers.Dense(np.prod(inter_shape[1:]),activation='relu')(input_code)
x = layers.Reshape(target_shape=inter_shape[1:])(x)
x = layers.Conv2DTranspose(32,3,padding='same',activation='relu',strides=2)(x)
x = layers.Conv2D(1,3,padding='same',activation='sigmoid')(x)

decoder = Model(input_code,x,name = 'decoder')

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

# Reading Dataset
COEFF_TRAIN = np.load('DATASET_FOR_VAE.npy');

COEFF_TRAIN = COEFF_TRAIN[:,:,:,np.newaxis];
MODEL_VAE.fit(COEFF_TRAIN, batch_size=12,epochs=10, validation_data=(COEFF_TRAIN[:2],None));
# MODEL_VAE.save('MODEL_VAE.h5');
MODEL_VAE.save_weights('MODEL_VAE_weights.h5');

"""
# Testing
from scipy.stats import norm
import numpy as np
import matplotlib.pyplot as plt
n = 20
x = y = norm.ppf(np.linspace(0.01,0.99,n))  # 生成标准正态分布数
X,Y = np.meshgrid(x,y)                      # 形成网格
X = X.reshape([-1,1])                       # 数组展平
Y = Y.reshape([-1,1]) 
input_points = np.concatenate([X,Y],axis=-1) # 连接为输入
for i in input_points:
  plt.scatter(i[0],i[1])
plt.show()

img_size = 28
predict_img = decoder.predict(input_points)
pic = np.empty([img_size*n,img_size*n,1])
for i in range(n):
  for j in range(n):
    pic[img_size*i:img_size*(i+1), img_size*j:img_size*(j+1)] = predict_img[i*n+j]
plt.figure(figsize=(10,10))
plt.axis('off')
pic = np.squeeze(pic)
plt.imshow(pic,cmap='bone')
plt.show();
"""