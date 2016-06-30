
## Data Collection

### [```0_collect_studies.R```](https://github.com/IALSA/IALSA-2015-Portland/blob/master/scripts/0_collect_studies.R) 
Uses the functions defined in the script [0a_collection_functions.R](https://github.com/IALSA/IALSA-2015-Portland/blob/master/scripts/0a_functions_that_collect.R) to extract model results from Mplus output files. 


### [0a_collection_functions.R](https://github.com/IALSA/IALSA-2015-Portland/blob/master/scripts/0a_collection_functions.R)
 Defines functions that conduct primary extraction of model results from the model output files.  
- <code>find.Conflicts()</code> checks for issues associated with GitHub conflicts, usually marked by "<<<<" sign.  
- <code>find.CI()</code> checks for and removes CIs from the model output because it breaks MplusAutomation performance.  
- Other functions extract specific elements from the raw model output files. If you need to extract additional elements this function will have to be adjusted.  
Executing 
```
study <- "eas"
source("./scripts/0a_collection_functions.R")
```
will  collect all models located in [./studies/elsa](./studies/elsa) (i.e. process all *.out files resulted from fitting models in Mplus), and save a  *.csv file "study_automation_results.csv" which will contain all model information extracted from the output files. 

###[0b_functions_that_test.R](https://github.com/IALSA/IALSA-2015-Portland/blob/master/scripts/0b_functions_that_test.R) 
Uses some basic ```dplyr::count()``` to inspect the names of the element used in the filenames of the model outputs. Used as a stand-aside: not sourced by ```0_collect_studies.R```  

###[```0c_combine_model_outputs.R```](https://github.com/IALSA/IALSA-2015-Portland/blob/master/scripts/1_combine_model_outputs.R) 
Combines all ```study_automation_results.csv``` files, each of which contains extracted model descriptors from the corresponding study.  The resulting datastate is **ds0.rds**.




## Specialized transformation

### [```./reports/rename_collapse/Track_renaming.R```](https://github.com/IALSA/IALSA-2015-Portland/blob/master/reports/rename_collapse/Track_renaming.R)  
Records the list of corrections made to the output filenames of the submitted models after they have been read in. The resulting object is ```./data/shared/ds1a.rds``` which is the starting point for all analyses.   
**ds0.rds**   >>>   **ds1.rds**   
Takes ```./data/shared/ds0.rds```(which contains all raw model results in the collective),  corrects for typoes, misnomers, and misclassifications, and  produces ```./data/shared/ds1.rds```



### [```./reports/extend/standardize_ISR.R```](https://github.com/IALSA/IALSA-2015-Portland/blob/master/reports/extend/standardize_ISR.R)
Transforms covariances of random terms of the bivariate models into correlations and computes confidence intervals for them.  
**ds1.rds**   >>>   **ds2.rds**    
The script takes ```./data/shared/ds1.rds```(which contains results of all models corrects for typoes, misnomers, and misclassifications) and augments the data with specialty tranformations (covariance into correlation, compute 95%CI,  producing ```./data/shared/ds2.rds```

   

## General

### [```thesaurus.R```](https://github.com/IALSA/IALSA-2015-Portland/blob/master/scripts/thesaurus.r) 
 Lists the titbits of learning in this project.  
