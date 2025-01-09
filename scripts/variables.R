

# List of variables
out_vars <- c("Date" = "starttime", "Supervisor" = "cs_supervname_name", 
              "Enumerator" = "cs_enumname_name", "HHID" = "hhid", "KEY")

# List of numeric variables
var_list <- c("af_age", "af_year", "fm_agefirstbirth", "fm_girlnum", "fm_boynum", "fm_girlalive", 
              "fm_boyalive", "fm_numwives", "fm_agemarry", "fm_brmarryage", "fm_sismarryage", 
              "fm_sbage", "p1_ageearn_a", "p1_agearn_b", "p1_ageend_a", "p1_ageend_b", "p1_agefina", 
              "p1_ageindep", "p1_agepartner", "p1_agechild", "p1_sb_ageearn_a", "p1_sb_agearn_b", 
              "p1_sb_ageend_a", "p1_sb_ageend_b", "p1_sb_agefina_a", "p1_sb_agefina_b", 
              "p1_sb_ageindep_a", "p1_sb_ageindep_b", "p1_sb_agepartner_a", "p1_sb_agepartner_b", 
              "p1_sb_agechild_a", "p1_sb_agechild_b", "pw_numactiv", "pw_income", "pw_7dayhrs", 
              "pw_7daypayment", "hn_scale", "vi_crcircage")

# Labels to be included in the issue description
var_labels <- c("af_age" = "af_age. How old are you?", 
                "af_year" = "af_year. Year", 
                "fm_agefirstbirth" = "fm_agefirstbirth. How old were you when you had your first child?", 
                "fm_girlnum" = "fm_girlnum. How many total girl children have been born to you?", 
                "fm_boynum" = "fm_boynum. How many total boy children have been born to you?", 
                "fm_girlalive" = "fm_girlalive. How many living girl children do you have?", 
                "fm_boyalive" = "fm_boyalive. How many living boy children do you have?", 
                "fm_numwives" = "fm_numwives. How many wives did your current husband have at the time when you g", 
                "fm_agemarry" = "fm_agemarry. At what age did you first get married?", 
                "fm_brmarryage" = "fm_brmarryage. What is the youngest age at which one of ${list_crname}'s brothe", 
                "fm_sismarryage" = "fm_sismarryage. What is the youngest age at which one of ${list_crname}'s siste", 
                "fm_sbage" = "fm_sbage. How old is ${fm_sb_name}?", 
                "p1_ageearn_a" = "p1_ageearn_a. At what age do you expect ${list_crname} to Start earning money t", 
                "p1_agearn_b" = "p1_agearn_b. At what age did you expect ${list_crname} to Start earning money t", 
                "p1_ageend_a" = "p1_ageend_a. At what age do you expect ${list_crname} to Leave full-time educat", 
                "p1_ageend_b" = "p1_ageend_b. At what age did you expect ${list_crname} to Leave full-time educa", 
                "p1_agefina" = "p1_agefina. At what age do you expect ${list_crname} to be financially independ", 
                "p1_ageindep" = "p1_ageindep. At what age do you expect ${list_crname} to Leave this household?", 
                "p1_agepartner" = "p1_agepartner. At what age do you expect ${list_crname} to get married or start", 
                "p1_agechild" = "p1_agechild. At what age do you expect ${list_crname} to have a child?", 
                "p1_sb_ageearn_a" = "p1_sb_ageearn_a. At what age do you expect ${p1_sb_name_calc} to Start earning ", 
                "p1_sb_agearn_b" = "p1_sb_agearn_b. At what age did you expect ${p1_sb_name_calc} to Start earning ", 
                "p1_sb_ageend_a" = "p1_sb_ageend_a. At what age do you expect ${p1_sb_name_calc} to Leave full-time", 
                "p1_sb_ageend_b" = "p1_sb_ageend_b. At what age did you expect ${p1_sb_name_calc} to Leave full-tim", 
                "p1_sb_agefina_a" = "p1_sb_agefina_a. At what age do you expect ${p1_sb_name_calc} to be financially", 
                "p1_sb_agefina_b" = "p1_sb_agefina_b. At what age did you expect ${p1_sb_name_calc} to be financiall", 
                "p1_sb_ageindep_a" = "p1_sb_ageindep_a. At what age do you expect ${p1_sb_name_calc} to Leave this ho", 
                "p1_sb_ageindep_b" = "p1_sb_ageindep_b. At what age did you expect ${p1_sb_name_calc} to Leave this h", 
                "p1_sb_agepartner_a" = "p1_sb_agepartner_a. At what age do you expect ${p1_sb_name_calc} to get married", 
                "p1_sb_agepartner_b" = "p1_sb_agepartner_b. At what age did you expect ${p1_sb_name_calc} to get marrie", 
                "p1_sb_agechild_a" = "p1_sb_agechild_a. At what age do you expect ${p1_sb_name_calc} to have a child?", 
                "p1_sb_agechild_b" = "p1_sb_agechild_b. At what age did you expect ${p1_sb_name_calc} to have a child", 
                "pw_numactiv" = "pw_numactiv. How many activities have you done in the last 12 months to get mone", 
                "pw_income" = "pw_income. Across all of these activities, how much did you earn in TOTAL in the", 
                "pw_7dayhrs" = "pw_7dayhrs. During the 7 days prior to today, how many hours did you spend doing", 
                "pw_7daypayment" = "pw_7daypayment. In the 7 days prior to today, how much did you earn TOTAL for ${", 
                "hn_scale" = "hn_scale. Some people feel that they have a great deal of control over their own", 
                "vi_crcircage" = "vi_crcircage.How old were you when this occurred?")



# Enumerators


# Example data for enum_id and enum_name

enum_name = c("Bayou Zeleke", "Nardos Asfawu", "Kidist Belay", "Meskerem Yismaw", 
              "Behailu Kebede", "Hawi Abera", "Ferenbon Habtamu", "Tsige Getachew", 
              "Endalkachew Gezahegn", "Meseret Kebede", "Fozia Mohammed", "Meti Getachow", 
              "Jalel Kitesa", "Mujib Eshetu", "Eyerus Tadesse", "Hana Meskel", "Abdi Kidanu", 
              "Semira Jemal", "Kebebush Geta", "Muna Abdulsamed", "Tena Sirata", "Helen Gugsa", 
              "Chaltu Abera", "Yesirba Neima", "Ekram Awole", "Daritu Dawid", "Ambachew Manasibo", 
              "Ziyad Abdulkadir", "Fatuma Hasan", "Firehiwot Luelseged", "Kedir Ahmed", 
              "Eyob Birhanu", "Fatuma Ali", "Meaza Abebe", "PetrosTsegaye", "Fikadu Yadessa", 
              "Fre Tesfaye", "Dina Hassan", "Tagay Taddese", "Kedir Mohammed", "Daniel Tesfaye", 
              "Misael Arega", "Ephrem Melese", "Gebru Mesele", "Akilil Zeru", "Birhan Habtu", 
              "Zimare Worku", "Yabsira Ayele", "Meaza Boku", "Beza Girma", "Genet Dejene", 
              "Yordanos Bezu", "Sewalem Bishaw", "Rediet Getinet", "Frehiwot Mulugeta", 
              "Eden Fikadu", "Eyerusalem Teka", "Makda Shimelis", "Mahlet Tesfaye", 
              "Mergitu Ephrem")






