# recode factors
dlong <- dplyr::left_join(dlong,m) %>% 
  dplyr::rename(item = name_new) %>% 
  dplyr::mutate(
    value = ifelse(
      response == "Extremely" ,4, ifelse(
        response == "Very"      ,3, ifelse(
          response == "Moderately",2, ifelse(
            response == "Slightly"  ,1, ifelse(
              response == "Not at all",0, NA
            ))))
    ),
    valueF = factor(value, 
                    levels = c(0,1,2,3,4),
                    labels = c("Not at all",
                               "Slightly",
                               "Moderately",
                               "Very",
                               "Extremely")
    )
  )
