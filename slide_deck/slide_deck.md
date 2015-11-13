Is There Just No Pleasing Some People?
========================================================
author: Brian Frickert
date: 11/4/2015

Coursera Data Science Specialization Captone -- Yelp! dataset

Primary Question
========================================================

Within the *Yelp! dataset*:

Are there people who are incapable of enjoying businesses in even the most **pleasuring** business categories? And are there people who will love businesses in even the most **under-pleasuring** categories?


Methods
========================================================

Leveraging user feedback to identify what separates these two types of people?

- Statistical Inference to find feedback differences between **the miserables** and **the joyous**.
- Natural Language Processing to find which categories appear most in the **pleasuring* and **under-pleasuring** categories.
- Linear Regression to find whether people with less positive *Yelp!* peer feedback like everything less than those who receive lots of positive feedback.


Feedback Visualizations
========================================================

![plot of chunk unnamed-chunk-2](graphs.png) 
***
- red drop line: **the joyous**
- blue: **the miserables**
- green: total population

Under-Pleasuring Categories
========================================================

```
  joy misery diff   pct.diff    names
1  64    213 -149 -0.5379061  restaur
2  18    100  -82 -0.6949153      bar
3  11     68  -57 -0.7215190 nightlif
4  13     62  -49 -0.6533333 american
5   5     44  -39 -0.7959184   tradit
6  13     44  -31 -0.5438596    store
```

People With More Feedback Enjoy Restaurants Less!
========================================================

![plot of chunk unnamed-chunk-2](model.png) 
