# Khiva's use-cases

[![Gitter chat](https://badges.gitter.im/shapelets-io/Lobby.svg)](https://gitter.im/shapelets-io/khiva-use-cases?utm_source=share-link&utm_medium=link&utm_campaign=share-link/tree/interactive-use-cases)
[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/shapelets/khiva-use-cases/master?filepath=interactive-applications)

This repository contains some use-cases where the Khiva Library can be applied. 

## Introduction 

Khiva is an open-source library aimed at analysing time series and its key points are: 

* Features extraction.
* Time-series re-dimension.
* Distance comparison.
* Motifs detection.
* Discords detection.
* Similarity study.
* Statistics extraction.
* Time series normalization.

All these features are enhanced with an incredible performance due to the usage of accelerators, as the library can 
be executed on GPU or/and multicore CPUs.

The main library is developed in C++ and includes bindings for different programming languages.
The available languages bindings for using the library are:

* **[C++](https://github.com/shapelets/khiva)**
* **[Python](https://github.com/shapelets/khiva-python)**
* **[R](https://github.com/shapelets/khiva-r)**
* **[Matlab](https://github.com/shapelets/khiva-matlab)**
* **[Java](https://github.com/shapelets/khiva-java)**

## What is this repository for? 

This repository provides code, notebooks and presentations that supports and solve a full use-case. 

## What is the repository structure? 
In the root directory, there is one folder for each dataset, those folders contain the dataset itself and some use-cases for it. Besides that, we also have an interactive-applications folder to store interactive python notebooks.

By now, only an energy dataset is available:

* [Energy DataSet](https://github.com/shapelets/use-cases/tree/master/energy)

## Interactive Applications

This repository provides interactive applications to show how Khiva can be used. 

You can access to the executables in:

* [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/shapelets/khiva-use-cases/master?filepath=interactive-applications)

The applications are located in: 

* [Applications](https://github.com/shapelets/use-cases/tree/master/interactive-applications)

The available interactive applications are:

* [Feature extraction](https://github.com/shapelets/use-cases/tree/master/interactive-applications/features-extraction)
* [Resizing](https://github.com/shapelets/use-cases/tree/master/interactive-applications/resizing)
* [Clustering](https://github.com/shapelets/use-cases/tree/master/interactive-applications/clustering)
