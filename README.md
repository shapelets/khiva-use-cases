# Khiva's use-cases

[![Gitter chat](https://badges.gitter.im/shapelets-io/Lobby.svg)](https://gitter.im/shapelets-io/khiva-use-cases?utm_source=share-link&utm_medium=link&utm_campaign=share-link/tree/interactive-use-cases)
[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/shapelets/khiva-use-cases/master?filepath=notebooks)

## What is this repository for? 

This repository provides code, notebooks and presentations that supports and solve full use-cases applying Khiva library. 

## What is the repository structure? 
In the root directory, there is one folder, with data explorations, this folder contains explorations for datasets 
of different nature, like energy. Besides that, we also have a folder with python notebooks that show some interesting
use-cases like anomaly detection, clustering, motif discovery or feature-extraction.

## Khiva library 

**[Khiva](https://github.com/shapelets/khiva)** is an open-source library aimed at analysing time series and its key points are: 

* Features extraction.
* Time-series re-dimension.
* Distance comparison.
* Motifs detection.
* Discords detection.
* Similarity study.
* Statistics extraction.
* Time series normalization.

All these features are enhanced with an increased performance due to the usage of accelerators, as the library can 
be executed on GPU or/and multicore CPUs.

The main library is developed in C++ and includes bindings for different programming languages.
The available languages bindings for using the library are:

* **[C++](https://github.com/shapelets/khiva)**
* **[Python](https://github.com/shapelets/khiva-python)**
* **[R](https://github.com/shapelets/khiva-r)**
* **[Matlab](https://github.com/shapelets/khiva-matlab)**
* **[Java](https://github.com/shapelets/khiva-java)**
* **[Kotlin](https://github.com/shapelets/khiva-kotlin)**
* **[C#](https://github.com/shapelets/khiva-csharp)**


## Python notebooks

This repository provides interesting python notebooks to show how Khiva can be used. 

You can run these use-cases in the following link:

* [![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/shapelets/khiva-use-cases/master?filepath=notebooks)


## Tools 

The tools section provides auxiliary tools to interact with Khiva.

* [KPDT](https://github.com/shapelets/use-cases/tree/master/tools/khiva_patterns_discovery_tool.py)
