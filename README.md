# Lanugage Models Are Specialists: Rethinking Fine-tuning Language Models from Diverse Sources
This repository is an implementation of the NLP task project conducted in KAIST School of Computing, CS492(H): Special Topics in Computer Science<Deep Learning for Real-world Problems>: with NAVER

We used KorQuad-open dataset collected from NAVER wiki, blog, web, kin, news. Throughout this task, we implemented it using only NSML resources and want to say thank you to [NSML](https://ai.nsml.navercorp.com/) for providing GPU resourses.

## Customize open_squad and open_squad_metric
### Multiple Paragraph
In general SQuAD dataset, QA and paragraph are one-to-one. However, this dataset have **multiple paragraphs for one QA**, so we should make multiple squad example for a QA. It is implemented by modifying the existing [official code](https://github.com/huggingface/transformers/blob/master/src/transformers/data). And too many squad example were created, limiting the number of squad example created per QA.

### Use Only Majority Class
We found minority class is mostly not useful, and it prevents the model from well optimized when included in the training step. So we have the option that you can choose source to use for the train. If you activate the **--only_wiki** option in run_nsml shell file, you can train using only the wiki source. And we reached the best accuracy with this option.

### Number of paragraphs on inference
The number of paragraphs on inference affects significantly with the performance as below. The highest accuracy appears when using 5 paragraphs, so the default set to use 5 when inference.
|  <center>Model</center> |  <center>1</center> |  <center>2</center> | <center>3</center> | <center>4</center> | <center>5</center> | <center>6</center> | <center>7</center> |
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|Electra with Wiki| <center> 62.82 </center> |<center> 67.44 </center>|<center> 69.47 </center>|<center> 70.31 </center>|<center> **70.98** </center>|<center> 50.29 </center>|<center> 50.37 </center>|


### Final Results
The final result applied up to the Ensemble method is as follows.
|  <center>Model</center> |  <center>Single Model</center> |  <center>Ensemble</center> |
|:--------:|:--------:|:--------:|
|Full | <center> 68.40(±0.91) </center> |<center> 70.48 </center>|
|Wiki | <center> **70.54(±0.36)** </center> |<center> **72.16** </center> |

## Dataset
### Distribution
<img src="https://drive.google.com/uc?export=view&id=1qTRQXdrRF8Itg7vEyIc5Wj0T8aV71_x4" width="700">

Distribution of paragraphs per sources. Different colors indicate the position of paragraphs and it is very imbalanced. Also, there are  **'No Answer'** questions much more than **'Has Answer'** questions.

### Example
```bash
Question: 에버그린이 왕관을 사용하기 전 실험실을 엉망으로 만든 괴물은?
Answer: 마그마
“kdc”: 하지만 왕관을 사용하기 전, 코끼리 같이 생긴 마그마 괴물이 들어닥치고 실험실을 엉망으로 만든다. 
건물이 무너지고 잔해에 깔린 에버그린은 자신이 왕관을 쓸 수 없게 되자, 건터에게 왕관을 쓴 뒤 마음 깊은 
속에 있던 소원(에버그린에게는 ‘혜성을 파괴하는 것’)을 빌라고...

“kin”: 러이트 노벨에 대해선 거의 매니아지만 더 다양한것이 읽고싶네요. 지금까지 읽은건 데어라 내청코 
내여귀 에망선 주문토끼 냐루코 사쿠라장 중2코이 중고코이 나에게 천사 귀여우면 변태라도 간단하게 이정도입니다 
러브코미디.하렘물을 좋아하고 되도록이면 그런쪽으로 추천 받으면 좋겠네요. 최근 나오고 있는것이면 더 좋고 
옛날것도 좋습니다... 이능을 사용하며 평범한 일상을 보내는 모습을 그린 일상물 작품이지요...
```

## Train and Inference in NSML
### Train Model
In this project, we tested two types of models: **run_squad.py, run_squad_multihead.py**. You can choose either use a single head or multi-head for each source.
Single head model show better results and all of the above results are from single-head.
If you want to use multi-head model, modify run_nsml.sh file run_squad.py to run_squad_multihead.py and delete only_wiki option.

```bash
> sh run_nsml.sh

> nsml submit {SESSION NAME} {CHECKPOINT} #submit directly
```
### Inference 

#### Ensemble
You can infer your model by ensemble method. You should choose three trained model in NSML, and set *checkpoint{i} and session{i}* (i= 1,2,3) of them in submit_ensemble.sh

```bash
> sh submit_ensemble.sh

> nsml submit {SESSION NAME} total_best 
```

#### Single Model
Also you can infer with one model.

```bash
> sh submit.sh

> nsml submit {SESSION NAME} best 
```

When you want to control the number of paragraphs when inference on a trained model, edit (line 607) in open_squad.py and use submit shell



## Original Author
Seonhoon Kim (Naver)
