#load packages
import numpy as np
import os
import pandas as pd
import re
import nltk
nltk.download('wordnet')
from bs4 import BeautifulSoup
import string
import joblib
import pickle
import sklearn
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import CountVectorizer, TfidfTransformer, TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import SGDClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn import preprocessing, metrics
from sklearn.model_selection import cross_val_score, RepeatedStratifiedKFold
from sklearn.calibration import CalibratedClassifierCV
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report, f1_score
import keras
from keras.preprocessing import text, sequence
from keras import utils
from keras.models import Sequential
from keras.layers import Dense, Activation, Dropout
import keras.backend as K
import tensorflow as tf
import time

np.random.seed(1) #Set seed
os.chdir("C:/documents/my_classifier") #Set your own working directory

data = pd.read_csv('data.csv', encoding='mac_roman') #Load data
#'text' equals text data and 'tags' equals text categories

#clean data
replace_with_space = re.compile('[/(){}\[\]\|@,;]') #create function to remove special characters
bad_symbols = re.compile('[^0-9a-z #+_]') #create function to remove special characters
stopword = ['i',
 'me',
 'my',
 'myself',
 'we',
 'our',
 'ours',
 'ourselves',
 'you',
 "you're",
 "you've",
 "you'll",
 "you'd",
 'your',
 'yours',
 'yourself',
 'yourselves',
 'he',
 'him',
 'his',
 'himself',
 'she',
 "she's",
 'her',
 'hers',
 'herself',
 'it',
 "it's",
 'its',
 'itself',
 'they',
 'them',
 'their',
 'theirs',
 'themselves',
 'what',
 'which',
 'who',
 'whom',
 'this',
 'that',
 "that'll",
 'these',
 'those',
 'am',
 'is',
 'are',
 'was',
 'were',
 'be',
 'been',
 'being',
 'have',
 'has',
 'had',
 'having',
 'do',
 'does',
 'did',
 'doing',
 'a',
 'an',
 'the',
 'and',
 'but',
 'if',
 'or',
 'because',
 'as',
 'until',
 'while',
 'of',
 'at',
 'by',
 'for',
 'with',
 'about',
 'between',
 'to',
 'from',
 'then',
 'here',
 'there',
 'when',
 'where',
 'so',
 'than'] #Identify stopwords to remove, you can identify your own here
ps = nltk.PorterStemmer() #Load word stemmer
wn = nltk.WordNetLemmatizer() # Load word lemmatizer

def clean(text):
    text = text.lower() # lowercase text
    text = re.sub('[0-9]+', '', text)
    text = BeautifulSoup(text, "html.parser").text # HTML decoding
    text = replace_with_space.sub(' ', text) # replace REPLACE_BY_SPACE_RE symbols by space in text
    text = bad_symbols.sub('', text) # delete symbols which are in BAD_SYMBOLS_RE from text
    return text #Write function to conduct all text cleaning

def contract(text):
    text = [wn.lemmatize(word) for word in text]
    text = [ps.stem(word) for word in text]
    text  = "".join([char for char in text if char not in string.punctuation])
    text = ' '.join(word for word in text.split() if word not in stopword) # delete stopwors from text
    return text  #Write function to conduct all text contraction

data['text'] = data['text'].astype(str) #set text data as a string
data['text'] = data['text'].apply(clean) #use clean function on text
data['text'] = data['text'].apply(lambda x: contract(x)) #use contract function on text
data['text'].apply(lambda x: len(x.split(' '))).sum()

#split data for modelling
train_text_prop = 0.75 #75% of data used for training
train_text = data.sample(frac=train_text_prop)

train_val_prop = 0.05
train_val = train_text.sample(frac=train_val_prop) #5% of training data used for neural network feedback
train_text_trim = train_text.loc[~train_text.index.isin(train_val.index)]

train_prob_prop = 5/7 #5/7 of non-training data used for ensemble modelling
test = data.loc[~data.index.isin(train_text.index)]
train_prob = test.sample(frac=train_prob_prop) #5/7 of non-training data used for ensemble modelling
test = test.loc[~test.index.isin(train_prob.index)] #2/7 of non-training data used for testing accuracy

#Reset row indexes
train_text.reset_index(drop=True, inplace=True) 
train_text_trim.reset_index(drop=True, inplace=True)
train_val.reset_index(drop=True, inplace=True)
train_prob.reset_index(drop=True, inplace=True)
test.reset_index(drop=True, inplace=True)

#Create different vectors for training and test data
x_train_text = train_text['text'] 
y_train_text = train_text["tags"]
x_train_val = train_val['text'] 
y_train_val = train_val["tags"]
x_train_text_trim = train_text_trim['text'] 
y_train_text_trim = train_text_trim["tags"]
x_train_prob = train_prob['text'] 
y_train_prob = train_prob["tags"]
x_test = test['text'] 
y_test = test["tags"]

#RUN MODELS
#naive bayes
nb = Pipeline([('vect', CountVectorizer()), # count work frequencies
       ('tfidf', TfidfTransformer()), #count term-freuqnecy as the inverse of document frequency
       ('clf', MultinomialNB()), #run the model
      ])
nb.fit(x_train_text, y_train_text) #x equals text and y equals tags
joblib.dump(nb, 'nb_model.sav') #save model so it can be ran at a later date
x_train_pred_nb = nb.predict_proba(x_train_prob) #extract predciction probabiltiies for an additional piece of text

#support vector machines
svm = Pipeline([('vect', CountVectorizer()),
        ('tfidf', TfidfTransformer()),
        ('clf', SGDClassifier()),
       ])
svm.fit(x_train_text, y_train_text)
joblib.dump(svm, 'svm_model.sav')
x_train_pred_svm = svm.decision_function(x_train_prob)


#random forest
rf = Pipeline([('vect', CountVectorizer()),
       ('tfidf', TfidfTransformer()),
       ('clf', RandomForestClassifier(random_state = 1)),
      ])
rf.fit(x_train_text, y_train_text)
joblib.dump(rf, 'rf_model.sav')
x_train_pred_rf = rf.predict_proba(x_train_prob)


#logistic regression
lr = Pipeline([('vect', CountVectorizer()),
       ('tfidf', TfidfTransformer()),
       ('clf', LogisticRegression()),
      ])
lr.fit(x_train_text, y_train_text)
joblib.dump(lr, 'lr_model.sav')
x_train_pred_lr = lr.predict_proba(x_train_prob)


#nearest neighbours
nn = Pipeline([('vect', CountVectorizer()),
       ('tfidf', TfidfTransformer()),
       ('clf', KNeighborsClassifier()),
      ])
nn.fit(x_train_text, y_train_text)
joblib.dump(nn, 'nn_model.sav')
x_train_pred_nn = nn.predict_proba(x_train_prob)


#neurel network

#tokenize data
tokenize = TfidfVectorizer(max_features=1000) #trim training data to 1000 most frequent words
tokenize.fit(x_train_text_trim)
with open('dnn_tokenize', 'wb') as handle:
    pickle.dump(tokenize, handle, protocol=pickle.HIGHEST_PROTOCOL)
x_train_text_trim_tok = tokenize.transform(x_train_text_trim) 
x_train_val_tok = tokenize.transform(x_train_val).toarray()
x_train_prob_tok = tokenize.transform(x_train_prob).toarray()
norm = preprocessing.Normalizer().fit(x_train_text_trim_tok)
#nomralize tokenized data
with open('dnn_norm', 'wb') as handle:
    pickle.dump(norm, handle, protocol=pickle.HIGHEST_PROTOCOL)
x_train_text_trim_tok_norm = norm.transform(x_train_text_trim_tok) 
x_train_val_tok_norm = norm.transform(x_train_val_tok)
x_train_prob_tok_norm = norm.transform(x_train_prob_tok)


#Encode normalized data
encoder = preprocessing.LabelEncoder()
encoder.fit(y_train_text_trim)
y_train_text_trim_enc = encoder.transform(y_train_text_trim)
y_train_val_enc = encoder.transform(y_train_val)

num_classes = np.max(y_train_text_trim_enc) + 1 
y_train_text_trim_enc = utils.to_categorical(y_train_text_trim_enc, num_classes)
y_train_val_enc = utils.to_categorical(y_train_val_enc, num_classes)

#Set number of epochs and batches to run the network through. These can be adjusted at a later date
epochs_n = 30 
batch_n = 256

#build the model
model = Sequential() #Model works left to right i.e. there is no feedback loop as in concurrent or recurssive models
model.add(Dense(x_train_text_trim_tok_norm.shape[1], input_shape=(x_train_text_trim_tok_norm.shape[1],), activation='relu')) #1st layer loads encoded text data
model.add(Dense(512, activation='relu')) #2nd is a hidden layer with 512 nodes
model.add(Dropout(0.3)) #30% of nodes dropout to reduce overfitting
model.add(Dense(128, activation='relu')) #3rd is a hidden layer with 128 nodes
model.add(Dropout(0.3)) #30% of nodes dropout to reduce overfitting
model.add(Dense(num_classes, activation= "softmax")) #final layer matches the number of text categories
model.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy']) # record accuracy

#run the model
with tf.Session() as session:
    K.set_session(session)
    session.run(tf.global_variables_initializer())
    session.run(tf.tables_initializer())
    history = model.fit(x_train_text_trim_tok_norm, y_train_text_trim_enc, validation_data = (x_train_val_tok_norm, y_train_val_enc), epochs=epochs_n, batch_size=batch_n)
    model.save_weights('dnn.h5') 

#find the epoch that miximises validation accuracy
tmp_history = {'loss': history.history['loss'],
        'accuracy': history.history['accuracy'],
        'val_loss': history.history['val_loss'],
        'val_accuracy': history.history['val_accuracy']}
tmp_history = pd.DataFrame(tmp_history, columns = ['loss', 'accuracy', 'val_loss', 'val_accuracy'])
tmp_history
tmp_history.to_csv('dnn_history.csv', index = False, header=True)

#Set the new epoch level
epochs_n = 3
#re-run and save the final the model
with tf.Session() as session:
    K.set_session(session)
    session.run(tf.global_variables_initializer())
    session.run(tf.tables_initializer())
    history = model.fit(x_train_text_trim_tok_norm, y_train_text_trim_enc, validation_data = (x_train_val_tok_norm, y_train_val_enc), epochs=epochs_n, batch_size=batch_n)
    model.save_weights('dnn.h5')  
    model.save("dnn_model.h5")

with tf.Session() as session:
    K.set_session(session)
    session.run(tf.global_variables_initializer())
    session.run(tf.tables_initializer())
    model.load_weights('dnn.h5')
    x_train_pred_dnn = model.predict(x_train_prob_tok_norm, batch_size=batch_n)

#join probabiliy predictions from each of the six models
x_train_pred_comb = np.concatenate([
    x_train_pred_nb, 
    x_train_pred_svm, 
    x_train_pred_rf, 
    x_train_pred_lr, 
    x_train_pred_nn, 
    x_train_pred_dnn], axis=1)
    
#run a logistic regression to combile predictions across models
lr_ensemble = LogisticRegression()
cv = RepeatedStratifiedKFold(n_splits=10, n_repeats=5, random_state=1)
n_scores = cross_val_score(lr_ensemble, x_train_pred_comb, y_train_prob, scoring='accuracy', cv=cv)
lr_ensemble.fit(x_train_pred_comb, y_train_prob)
joblib.dump(lr_ensemble, 'ensemble.sav') #Save model

#produce model and ensemble predictions
pred_nb = nb.predict_proba(x_test)
pred_nb_class = nb.predict(x_test)
pred_svm = svm.decision_function(x_test)
pred_svm_class = svm.predict(x_test)
pred_rf = rf.predict_proba(x_test)
pred_rf_class = rf.predict(x_test)
pred_lr = lr.predict_proba(x_test)
pred_lr_class = lr.predict(x_test)
pred_nn = nn.predict_proba(x_test)
pred_nn_class = nn.predict(x_test)
x_test_tok = tokenize.transform(x_test).toarray()
x_test_tok_norm = norm.transform(x_test_tok)
with tf.Session() as session:
    K.set_session(session)
    session.run(tf.global_variables_initializer())
    session.run(tf.tables_initializer())
    model.load_weights('dnn.h5')
    pred_dnn = model.predict(x_test_tok_norm, batch_size=batch_n)
y_test_enc = encoder.transform(y_test)

pred_comb = np.concatenate([
    pred_nb, 
    pred_svm, 
    pred_rf, 
    pred_lr, 
    pred_nn, 
    pred_dnn], axis=1)

test_pred = lr_ensemble.predict_proba(pred_comb)
test_pred_class = lr_ensemble.predict(pred_comb)

#report accuracy of models
accuracy_data = {
    'model':  [
        'Ensemble', 
        'Naive Bayes',
        'Support vector machines', 
        'Random forest', 
        'Logistic regression', 
        'Nearest neighbour', 
        'Neural network'],
    'f_weighted': [
        f1_score(y_test, test_pred_class, average='weighted'), 
        f1_score(y_test, pred_nb_class, average='weighted'), 
        f1_score(y_test, pred_svm_class, average='weighted'), 
        f1_score(y_test, pred_rf_class, average='weighted'), 
        f1_score(y_test, pred_lr_class, average='weighted'), 
        f1_score(y_test, pred_nn_class, average='weighted'), 
        f1_score(y_test_enc, pred_dnn.argmax(axis=-1), average='weighted')]
    }
accuracy_data = pd.DataFrame(accuracy_data, columns = ['model', 'f_weighted'])
accuracy_data.to_csv('accuracy.csv', index = False, header=True) #save accuracies of eahc model type
text_file = open('class.txt', "w") #category specific accuracy
text_file.write(metrics.classification_report(y_test, test_pred_class))
text_file.close()
con_mat = pd.DataFrame(metrics.confusion_matrix(y_test, test_pred_class))
con_mat.to_csv('con.csv', index = False, header=True)  #save confusion matrix
test_explore = pd.concat([test, pd.DataFrame(test_pred_class, columns = ['pred_tag'])], axis=1)
test_explore.to_csv('explore.csv', index = False, header=True)  #look at predictions relative to classified data to identify cases of misclassification

