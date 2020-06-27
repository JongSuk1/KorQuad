#!/usr/bin/env bash

nsml run \
  -m 'kaist korquad open' \
  -d korquad-open-ldbd \
  -g 1 \
  -c 1 \
  -e submit_ensemble.py \
  -a "--model_type electra
    --model_name_or_path monologg/koelectra-base-v2-discriminator
    --do_train
    --do_eval
    --data_dir train
    --num_train_epochs 5
    --per_gpu_train_batch_size 24
    --per_gpu_eval_batch_size 24
    --output_dir output
    --overwrite_output_dir
    --checkpoint1 electra_gs8000_e1
    --session1 kaist_12/korquad-open-ldbd/451
    --checkpoint2 electra_gs8000_e1
    --session2 kaist_12/korquad-open-ldbd/522
    --checkpoint3 electra_gs12000_e1
    --session3 kaist_12/korquad-open-ldbd/521
    --version_2_with_negative"
