# Khiva's use-cases

[![Gitter chat](https://badges.gitter.im/shapelets-io/Lobby.svg)](https://gitter.im/shapelets-io/khiva-use-cases?utm_source=share-link&utm_medium=link&utm_campaign=share-link/tree/interactive-use-cases)
[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/shapelets/khiva-use-cases/master?filepath=interactive-applications)

This repository contains some Use Cases where the Khiva Library can be applied. 

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
be executed in GPU or/and multicore CPUs.

The main library is developed in C++ and includes bindings for different programming languages.
The available languages for using the library are:

* **C++**
* **Python**
* **R**
* **Matlab**
* **Java**

## What is this repository for? 

This repository provides code, notebooks and presentations that supports and solve a full use case. 

## What is the repository structure? 
In the root directory there are different folders focused on a topic and inside these folders there are directories showing a case study. 

Each topic has its own datasets. By now, only an energy dataset is available:

* [Energy DataSet](https://github.com/shapelets/use-cases/tree/master/energy)

## Interactive Applications

This repository provides interactive applications in order to show how and for what Khiva can be used. 

You can access to the executables in:

* [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/shapelets/khiva-use-cases/master?filepath=interactive-applications)

The applications are located in: 

* [Applications](https://github.com/shapelets/use-cases/tree/master/interactive-applications)

The available applications are:

* [Feature extraction](https://github.com/shapelets/use-cases/tree/master/interactive-applications/features-extraction)