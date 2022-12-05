library(ggplot2)
library(plotly)
library(bslib)
library(dplyr)

pima_indians_diabetes <- read.csv("https://query.data.world/s/2ssuanccxtfm3edsnmrvcmlrzu5vlf")

# Read in Variables For Graph 1
pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "0"] <- "Does Not Have Type 2 Diabetes"
pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "1"] <- "Has Type 2 Diabetes"
pima_indians_diabetes$Glucose <- 0.001 * (pima_indians_diabetes$Glucose)
pima_indians_diabetes$Insulin <- 0.001 * (pima_indians_diabetes$Insulin)
avg_pedigree <- pima_indians_diabetes %>% group_by(Outcome) %>% 
  summarize(Average = mean(DiabetesPedigreeFunction))
avg_glucose <- pima_indians_diabetes %>% group_by(Outcome) %>% summarize(Average = mean(Glucose)) 
avg_insulin <- pima_indians_diabetes %>% group_by(Outcome) %>% summarize(Average = mean(Insulin))
avg_pedigree$VarType <- "DiabetesPedigreeFunction" 
avg_glucose$VarType <- "Glucose"
avg_insulin$VarType <- "Insulin"
merged_table <- rbind(avg_glucose,avg_insulin,avg_pedigree)
Condition <- merged_table$Outcome
Metric <- merged_table$VarType
# Read in Variables For Graph 2
pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "0"] <- "Does Not Have Type 2 Diabetes"
pima_indians_diabetes$Outcome[pima_indians_diabetes$Outcome == "1"] <- "Has Type 2 Diabetes"
blood_pressure_diabetes <- pima_indians_diabetes %>% 
  filter(Outcome == 'Has Type 2 Diabetes') %>%
  group_by(Age) %>% 
  summarize(avg_blood_pressure = mean(BloodPressure))
blood_pressure_no_diabetes <- pima_indians_diabetes %>%
  filter(Outcome == "Does Not Have Type 2 Diabetes") %>%
  group_by(Age) %>%
  summarize(avg_blood_pressure2 = mean(BloodPressure))
avg_blood_pressure <- left_join(blood_pressure_diabetes, blood_pressure_no_diabetes, by = 'Age')
diabetes <- left_join(avg_blood_pressure, pima_indians_diabetes, by = 'Age')

intro_tab <- tabPanel(
  "Introduction",
  fluidPage(theme = bs_theme(bootswatch = "sandstone")),
  h2("Introduction"),
  p(a(href = "https://www.cdc.gov/diabetes/basicstype2.html#:~:text=More%20than%2037%20million%20Americans,adults%20are%20also%20developing%20it", "Type 2 Diabetes"), 
  "is a disease that affects hundreds of millions of people in the United States
  and globally. It occurs when there is an impairment in the body
  that makes it more difficult for the pancreas to produce insulin, which is a
  hormone that regulates the movement of sugar into your cells so that it can be
  transformed into energy. As a result, this excess sugar builds up in the blood
  and causes different complications. Some symptoms of type 2 diabetes are
  increased thirst, frequent urination, unintended weight loss, numbness, and
  tingling in the hands or feet."),
  h2("Main Questions & Project Purpose"),
  p("In this project, our research questions concerning type 2 diabetes
  are: How do the glucose, insulin levels, and the diabetes pedigree function
  values compare for patients with and without type 2 diabetes? What is the 
  relationship between a patient's BMI and whether or not they have type 2 
  diabetes? What is the relationship between average blood pressure for each age
  and whether or not they have type 2 diabtes? The motivation for these questions
  is that type 2 diabetes is the most common type of diabetes experienced by 
  patients, and has become even more prevalent over the past few decades. It can
  cause", a(href = "https://www.mayoclinic.org/diseases-conditions/type-2-diabetes/symptoms-causes/syc-20351193", 
  "chronically high blood glucose levels"), "which can further lead to disorders 
  of the circulatory, nervous and immune systems if not treated properly, however
  it can be prevented if it is detected at an early stage. Being able to find 
  concrete data trends can help those who suffer from type 2 diabetes better 
  manage the disease and prevent many high-risk individuals from developing type
  2 diabetes by making lifestyle changes that improve these metrics."),
  h2("The Data Used & Implications"),
  p("To answer our research questions we examined data from", a(href = "https://data.world/data-society/pima-indians-diabetes-database/workspace/file?filename=diabetes.csv", "data.world.com."), 
  "The data was originally collected by the National Institute of Diabetes and
  Digestive and Kidney Disease. Researchers randomly selected 768 women of Pima
  Indian heritage from a population near Phoenix, Arizona and administered surveys
  and performed different medical tests on them in order to identify those that had
  type 2 diabetes. The National Institute of Diabetes and Digestive and Kidney
  Disease has been collecting and adding more data to the table since 1965 as they
  continue to study the Pima population, thus making it very accurate and
  appropriate to use for our analysis project. The data was collected as a way to
  predict whether or not a patient has type 2 diabetes based on certain medical
  information. One possible problem with this data is that it is solely taken from
  females who are at least 21 years old of Pima Indian heritage, thus causing our
  findings to only be applicable to this certain group rather than to all patients
  in the world. Although there are no missing values, some of the measurements in
  the dataset contain values of 0, which is not possible for humans to have.
  Additionally, the data lacks underlying helpful information such as if the data
  was collected in a similar environment for each participant, why the scientists
  consider “number of pregnancies”, and how they calculated the “diabetes pedigree
  function” variable. When working with this data, many ethical questions arise.
  For example, what protocols did these scientists make this group of women follow
  when taking data and observations from them, and why did they choose to focus on
  this particular type of subject? As for questions of power, it is important for
  us to acknowledge that the data collected from this underrepresented minority
  population was most likely performed by those in power, so how did the
  researchers protect the safety, well-being, and privacy of the women involved?"),
  img(src = "https://cdn.britannica.com/42/93542-050-E2B32DAB/women-Pima-shinny-game-field-hockey.jpg", 
  height = 500, width = 700, style="display: block; margin-left: auto; margin-right: auto;")
)

plot_sidebar_first <- sidebarPanel(
  h2("Display Options"),
  checkboxGroupInput(
    inputId = "metric_displayed",
    label = "Metric Type:",
    choices = unique(merged_table$VarType),
    selected = c("Insulin", "DiabetesPedigreeFunction", "Glucose")),
  checkboxGroupInput(
    inputId = "patient_displayed",
    label = "Condition Type:",
    choices = unique(merged_table$Outcome),
    selected = c("Has Type 2 Diabetes", "Does Not Have Type 2 Diabetes"))
)

plot_sidebar_second <- sidebarPanel(
  h2("Patient Type"),
  radioButtons(
    inputId = "patient_type",
    label = "Select the type of patient:",
    choices = list("Does not have type 2 diabetes" = 1, "Has type 2 diabetes" = 2, "Both" = 3),
    selected = 3)
)

plot_sidebar_third <- sidebarPanel(
  h2("Age Range"),
  sliderInput(
    inputId = "Age",
    label = "Select the age range of the patients:",
    min = min(pima_indians_diabetes$Age),
    max = max(pima_indians_diabetes$Age),
    value = c(25,50),
    step = 1)
)

plot_one <- mainPanel(
  plotlyOutput(outputId = "barGraph"),
  br(),
  h3("Summary & Purpose"),
  p("This bar graph shows the average amount of glucose, insulin, and the diabetes
  pedigree function for people with type 2 diabetes and those without type 2 
  diabetes. The diabetes pedigree function metric is the likeliness of someone 
  developing type 2 diabetes based on their genetics and if someone in their family 
  has or had type 2 diabetes. This pedigree function is unitless, and is calculated
  by looking at one's diabetes diagnostic history across generations and using 
  this gathered information to estimate the likelihood of an individual having 
  type 2 Diabetes. The greater the diabetes pedigree function number, the greater
  one's chance of having type 2 diabetes is. Additionally, the glucose metric is
  the amount of glucose in a patient's bloodstream, and the units are in grams 
  per deciliter (g/dL), and the insulin metric is the amount of insulin in a patient's 
  bloodstream, and the units are also in grams per deciliter (g/dL). All three 
  of these metrics are used by medical professionals to determine whether or not
  someone should be diagnosed with type 2 diabetes. On this bar graph, you are 
  able to click on what specific metrics you want to be displayed and if you 
  want to see the average value for people with type 2 diabetes or those who do 
  not have type 2 diabetes, or you can choose to see both. This graph provides 
  insight into how insulin, glucose, and pedigree function impact whether or not
  someone has type 2 diabetes. It specifically shows that on average, people 
  with type 2 diabetes have a higher amount of insulin and glucose in their 
  bloodstream and they have a higher pedigree function. This is helpful for 
  patients who get blood work done and can find out what their insulin and 
  glucose levels are because they are able to see if they are in danger of 
  developing type 2 diabetes or already have this medical condition. This is 
  also helpful for those who have a higher pedigree function because they are 
  able to be aware of genetic predispositions they have and make better 
  decisions to help diminish their chances of developing type 2 diabetes.")
)

plot_two <- mainPanel(
  plotlyOutput(outputId = "histogram"),
  br(),
  h3("Summary & Purpose"),
  p("This histogram studies the relationship between a patient's BMI and whether
  or not they have type 2 diabetes. BMI, which stands for body mass index, refers
  to how much body fat a person has and helps determines one's overall health. If 
  a patient has a BMI above 30, then they are deemed as obese. Users can select 
  to see the BMI distribution for either people with type 2 diabetes, people 
  without type 2 diabetes, or both groups together. This function shows that
  the BMI that the greatest number of patients with type 2 diabetes have is
  approximately 45, whereas the BMI that the greatest number of patients without
  type 2 diabetes have is approximately 72. Additionally, about three-fourths of
  these patients with type 2 diabetes are obese, as they have a BMI above 30, but
  only about half of the patients without type 2 diabetes are obese. Obesity is
  the leading risk factor for Type 2 Diabetes, and the higher one's BMI, the
  higher their risk of being obese is. As a result, this chart seeks to
  display the major effect that BMI has on a patient developing type 2 diabetes.
  This chart reveals that the majority of patients diagnosed with type 2 diabetes
  had a BMI over 30. BMI is very easy to calculate using a patient's mass and
  height, and is one of the main diagnostic measures that helps individuals detect
  the risk of type 2 diabetes. Therefore, this chart can be used to show medical
  professionals that there is a strong relationship between a patient's BMI and
  developing type 2 diabetes, and they should work with patients to try to lower
  their BMI to not only prevent them from becoming obese, but in turn, prevent
  them from becoming type 2 diabetic. This chart is also helpful for patients because 
  they are able to monitor their BMI and know if they are getting closer to 
  developing type 2 diabetes and need to make appropriate changes to improve
  their health.")
)

plot_three <- mainPanel(
  plotlyOutput(outputId = "dotPlot"),
  br(),
  h3("Summary & Purpose"),
  p("This scatterplot shows the average blood pressure for those who have 
    type 2 diabetes and those who do not have type 2 Diabetes across different ages.
    Blood pressure is when there is pressure around the outer walls of blood 
    cells, usually in the circulatory system. This high blood pressure can lead 
    to many health problems such as a heart attack or diabetes. High blood pressure
    can be caused by many things such as a poor diet, stress, and genetics. Through 
    this chart, users are able to see the average blood pressure of people with 
    type 2 diabetes and those who do not have type 2 diabetes for each age. The
    average blood pressure for patients who have type 2 diabetes is higher than
    patients who do not have type 2 diabetes. Users are also able to change the 
    age range they want to see and can click on the two different colored dots 
    if they only want to see the data for those with type 2 diabetes or without
    type 2 diabetes. From this feature, it is apparent that the average blood
    pressure is particularly higher for older patients who have type 2 diabetes
    compared to those who don't have this condition. It is important for people 
    to be aware of this chart because when people take their blood pressure, they
    should be able to see the average blood pressure that a person with type 2 
    diabetes has and those who do not have it for their age. If a person looks 
    at the chart and they are close to the type 2 diabetes blood pressure for 
    their age, they should consult with a doctor and take appropriate steps to 
    reduce their blood pressures. This chart allows people to see where they 
    fall on the chart so they can be proactive with their health and reduce 
    their risk of developing type 2 diabetes.")
)

plot_tab_1 <- tabPanel(
  "Diagnostic Metrics",
  h2("Categorization of Type 2 Diabetes Diagnostic Metrics", align = "left"),
  sidebarLayout(
    plot_sidebar_first,
    plot_one,
  )
)

plot_tab_2 <- tabPanel(
  "BMI Distribution",
  h2("Distribution of Body Mass Index", align = "left"),
  sidebarLayout(
    plot_sidebar_second,
    plot_two,
  )
)

plot_tab_3 <- tabPanel(
  "Blood Pressure Trends",
  h2("Blood Pressure Levels Across Different Ages", align = "left"),
  sidebarLayout(
    plot_sidebar_third,
    plot_three,
  )
)

conclusion_tab <- tabPanel(
  "Conclusion",
  h2("Conclusion"),
  p("In our project, we set out to find how different medical factors can be 
    used to determine if someone will develop type 2 diabetes or not. Type 2 
    diabetes occurs when an impairment in the body causes the pancreas to have 
    difficulty producing insulin. We created three charts that showed how these 
    health components impact whether or not a person has type 2 diabetes."),
  p("The first chart we created was one that showed how insulin, glucose, 
    and the diabetes pedigree function impacted whether or not a person was 
    more likely to develop diabetes or not. This bar graph showed that people 
    with a higher average pedigree function, glucose level, and insulin level
    all had type 2 diabetes, whereas people with a lower average of these three
    diagnostic metrics did not. Those without type 2 diabetes had an average 
    pedigree function of appromimately 0.43, whereas those with type 2 diabetes 
    had an average pedigree function of appromimately 0.55. Those with type 2 
    diabetes therefore had an average pedigree function that was approximately 
    0.12 higher than those without. A similar trend occurred with insulin, in 
    which those without type 2 diabetes had an average insulin level of 
    approximately 0.07 g/dL, and those with type 2 diabetes had an average of 
    approximately 0.10 g/dL. For glucose, those without type 2 diabetes had an 
    average glucose level of 0.11 g/dL, and those with type 2 diabetes had an 
    average of approximately 0.14 g/dL. There is a difference of 0.03 g/dL between
    the insulin and glucose levels of patients with and without type 2 diabetes.
    This graph and values show that these three main diagnostic metrics influence
    whether or not someone will develop type 2 diabetes. If someone has a higher
    diabetes pedigree function and glucose and insulin levels, then they are
    likely more susceptible to developing type 2 diabetes than those with lower
    values."),
  p("The next chart we created is a histogram that shows the distribution of 
    body mass index (BMI) among patients with type 2 diabetes and patients who 
    do not have this condition, and how many of both groups have each BMI value. 
    BMI stands for body mass index and it shows how much body fat a person has. 
    If someone has a BMI of over 30, then they are considered obese. This graph 
    shows that most people who do not have type 2 diabetes have a BMI of 
    approximately 25, and are therefore not considered obese. However, most 
    people who have type 2 diabetes have a BMI of approximately 35, and are 
    considered obese. That is a difference of 10 between both groups. This shows
    how BMI can greatly impact whether or not a person has type 2 diabetes, and 
    the higher it is, the more likely someone has this disease or will soon 
    develop it."),
  p("The third chart we created was a scatterplot that displays the average blood 
    pressure for people with type 2 diabetes and those without type 2 diabetes 
    at each age between 21 and 81. For example, this graph shows that at age 43, 
    people without type 2 diabetes had an average blood pressure of approximately
    66 mmHg, but those with type 2 diabetes had an average blood pressure of 
    approximately 80 mmHg, which is a difference of 14 mmHg. Additionally, the
    average blood pressure of people with type 2 diabetes aged 25 to 35 is 
    approximately 76 mmHg, whereas the average blood pressure of people with
    type 2 diabetes aged 70 to 80 is approximately 82. This shows that 
    blood pressure and age can impact a person developing type 2 diabetes.
    Specifically, the higher a person's blood pressure is and the older they are
    in age, the more likely they are to have type 2 diabetes."),
  p("The most important insight we learned from our analysis is that biomedical
    metrics, age, and genetics are the main health factors that determine the 
    likelihood of someone developing type 2 diabetes. This is important 
    information for patients to know about so they can take the appropriate 
    measures to maintain good health and prevent themselves from developing type
    2 diabetes. It is also helpful for medical professionals, as they can focus
    more closely on the aspects that contribute most significantly to type 2
    diabetes diagnosis, rather than wasting time assessing other parts."),
  img(src = "https://images.everydayhealth.com/images/how-to-manage-ulcerative-colitis-and-diabetes-1440x810.jpg?sfvrsn=2c5211d8_1", 
      height = 400, width = 800, style="display: block; margin-left: auto; margin-right: auto;")
)

ui <- navbarPage(
  "Type 2 Diabetes Biomedical Research Analysis",
  intro_tab,
  plot_tab_1,
  plot_tab_2,
  plot_tab_3,
  conclusion_tab,
)
