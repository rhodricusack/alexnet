# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#
#!/bin/bash

DATA="/imagenet"

PYTHON="/home/ubuntu/anaconda3/envs/pytorch_p36/bin/python"

CHECKPOINTBUCKET="neurana-imaging"
CHECKPOINTPATH="rhodricusack/alexnet/checkpoints"
LINEARCLASSBUCKET="neurana-imaging"
LINEARCLASSPATH="rhodricusack/alexnet/linearclass"

SQSURL="https://sqs.eu-west-1.amazonaws.com/807820536621/alexnet-linearclass.fifo"
EXP="${HOME}/linearclass"
echo "${EXP}"

# This will only work for NVIDIA GPUs
NGPUS=`lspci|grep 'NVIDIA'| wc -l`

# For testing
NGPUS=4

for ((tp=0;tp<NGPUS;tp++)); do 
    mkdir -p ${EXP}_${tp}
    (CUDA_VISIBLE_DEVICES=${tp}; ${PYTHON}  eval_linear_spot_aoa.py --data ${DATA} --epochs 2 --lr 0.01 --wd -7 --verbose --exp ${EXP}_${tp} --workers 32  --checkpointbucket ${CHECKPOINTBUCKET} --checkpointpath ${CHECKPOINTPATH} --sqsurl ${SQSURL} --linearclassbucket ${LINEARCLASSBUCKET} --linearclasspath ${LINEARCLASSPATH} --aoaval) &
done
