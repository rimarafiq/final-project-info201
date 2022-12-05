# Type 2 Diabetes Biomedical Research Analysis
## INFO 201 "Foundational Skills for Data Science" — Winter 2022

Authors: Rima Rafiq, Lily Jeffs, Madeleine Martin, Daria Markewych

Link: https://lilyjeffs.shinyapps.io/final-project-lilyjeffs/

# Introduction
[Type 2 Diabetes](https://www.cdc.gov/diabetes/basicstype2.html#:~:text=More%20than%2037%20million%20Americans,adults%20are%20also%20developing%20it) is a disease that affects hundreds of millions of people in the 
United States and globally. It occurs when there is an impairment in the body
that makes it more difficult for the pancreas to produce insulin, which is a
hormone that regulates the movement of sugar into your cells so that it can be
transformed into energy. As a result, this excess sugar builds up in the blood
and causes different complications. Some symptoms of type 2 diabetes are
increased thirst, frequent urination, unintended weight loss, numbness, and
tingling in the hands or feet.

In this project, our research questions concerning type 2 diabetes
are: How do the glucose, insulin levels, and the diabetes pedigree function
values compare for patients with and without type 2 diabetes? What is the 
relationship between a patient's BMI and whether or not they have type 2 
diabetes? What is the relationship between average blood pressure for each age
and whether or not they have type 2 diabtes? The motivation for these questions
is that type 2 diabetes is the most common type of diabetes experienced by 
patients, and has become even more prevalent over the past few decades. It can
cause [chronically high blood glucose levels](https://www.mayoclinic.org/diseases-conditions/type-2-diabetes/symptoms-causes/syc-20351193), 
which can further lead to disorders of the circulatory, nervous and immune systems 
if not treated properly, however it can be prevented if it is detected at an 
early stage. Being able to find concrete data trends can help those who suffer 
from type 2 diabetes better manage the disease and prevent many high-risk 
individuals from developing type 2 diabetes by making lifestyle changes that 
improve these metrics.

To answer our research questions we examined data from [data.world.com](https://data.world/data-society/pima-indians-diabetes-database/workspace/file?filename=diabetes.csv). 
The data was originally collected by the National Institute of Diabetes and
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
researchers protect the safety, well-being, and privacy of the women involved?

# Conclusion / Summary Takeaways
In our project, we set out to find how different medical factors can be 
used to determine if someone will develop type 2 diabetes or not. Type 2 
diabetes occurs when an impairment in the body causes the pancreas to have 
difficulty producing insulin. We created three charts that showed how these 
health components impact whether or not a person has type 2 diabetes."),

The first chart we created was one that showed how insulin, glucose, 
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

The next chart we created is a histogram that shows the distribution of 
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
develop it.

The third chart we created was a scatterplot that displays the average blood 
pressure for people with type 2 diabetes and those without type 2 diabetes 
at each age between 21 and 81. For example, this graph shows that at age 43, 
people without type 2 diabetes had an average blood pressure of approximately
66 mmHg, but those with type 2 diabetes had an average blood pressure of 
pproximately 80 mmHg, which is a difference of 14 mmHg. Additionally, the
average blood pressure of people with type 2 diabetes aged 25 to 35 is 
approximately 76 mmHg, whereas the average blood pressure of people with
type 2 diabetes aged 70 to 80 is approximately 82. This shows that 
blood pressure and age can impact a person developing type 2 diabetes.
Specifically, the higher a person's blood pressure is and the older they are
in age, the more likely they are to have type 2 diabetes."),

The most important insight we learned from our analysis is that biomedical
metrics, age, and genetics are the main health factors that determine the 
likelihood of someone developing type 2 diabetes. This is important 
information for patients to know about so they can take the appropriate 
measures to maintain good health and prevent themselves from developing type
2 diabetes. It is also helpful for medical professionals, as they can focus
more closely on the aspects that contribute most significantly to type 2
diabetes diagnosis, rather than wasting time assessing other parts.
