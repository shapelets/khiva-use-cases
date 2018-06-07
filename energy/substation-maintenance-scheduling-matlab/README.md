# Substation maintenance scheduling

## Summary
In this use case, we analyse electric consumption rates from 100 sites in different industries to identify time spots when
to perform electrical substation maintenance without service disruption.  

The data does not contain substation information, so we are assuming a total of 5 substations. The location of these
substations is determined based on the proximity in latitude and longitude of the sites under study. The substations are
assumed to be located in the centroid of the result of a K-means clustering of the sites.

In a second step the electric consumption of the sites belonging to the same cluster is aggregated. Based on this 
aggregated consumption per substation, the max peak power consumption is randomly established by multiplying the maximum
power consumption during the year, with a random percentage between 5% and 35%.

The suitable maintenance spots are determined using the aggregated electric consumption, the peak power consumption and a
user specified threshold of the percentage of the substation that needs to be shut down while being repaired. A suitable
maintenance spot is the one where the average consumption is lower than the max peak consumption multiplied by the mentioned
user-defined percentage.

Having the suitable maintenance time slots for each of the substations, a further filtering step is applied. In this
filtering, the user specifies the required maintenance time, which will be determined by the work to be applied to the
substation.

A decision tree classification ensemble is applied to explain when to operate the substations without compromising the
service. This is done using the maintenance slots of the required time and a decomposition of the date into:

* Day
* Hour
* Minute
* Week of the month
* Month
* Is Weekend? Boolean value denoting whether the maintenance slot occurs in a weekend or not.

In this use case, the KHIVA library has been used to; reduce the input data, plot the consumption over time of the 
sites per industry, observe that they behave similarly, even though the magnitude of the series might differ. In addition,
a few extra usages of the library are included in the scripts contained in this folder (such as hierarchical clustering
based on the Euclidean distance and calculating the best n discords between sites of the same industry).

## Data
The raw data corresponds to the [EnerNOC Open Data dataset](https://open-enernoc-data.s3.amazonaws.com/anon/index.html).

The pre-processed data with the time series for the different sites synchronised in time is contained in the 
`preprocessed-data/preprocessed-timeseries.mat` file.

The `preprocessed-data` folder should be at the same hierarchy level as the `SubstationMaintenance.mlx` MATLAB live script.
