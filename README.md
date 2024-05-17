# LMB-Clust - Nonsmooth Optimization based Incremental Clustering Software using LMBM (version 3.0 with Python interface)

LMB-Clust is a nonsmooth optimization (NSO) based clustering algorithm for solving the minimum sum-of-squares clustering (MSSC) problem in large data sets. The LMB-Clust -method consist of two different algorithms: an incremental algorithm is used to solve clustering problems globally and at each iteration of this algorithm the limited memory bundle method (LMBM) is used to solve both the clustering and the auxiliary clustering problems with different starting points. In addition to the k-partition problem, LMB-Clust solves also all intermediate l-partition problems where l=1,…,k-1 due to the incremental approach used.


## Files included
* lmbclust.py           
  - Main Python file.
* lmbmclust.f95         
  - Building plock between Python and clustering software.
* initlmbmclust.f95  
  - Parameters for clustering and LMBM. Includes modules:
    + initclust - Initialization of parameters for clustering.
    + initlmbm - Initialization of LMBM.
* lmbmclusteringmod.f95     
  - Subroutines for clustering software.
* lmbm.f95              
  - LMBM - limited memory bundle method.
* objfun.f95            
  - Computation of the cluster function and subgradients values.
* functionmod.f95            
  - Computation of the cluster function and subgradients values.
* subpro.f95            
  - subprograms for SLMB.
* parameters.f95        
  - Parameters. Inludes modules:
    + r_precision - Precision for reals,
    + param - Parameters,
    + exe_time - Execution time.

* Makefile              
  - makefile: builds a shared library to allow lmbmclust (Fortran95 code) to be called from Python program lmbclust. Uses f2py, Python3.7, and requires a Fortran compiler (gfortran) to be installed.


## Installation and usage

The source uses f2py and Python3.7, and requires a Fortran compiler (gfortran by default) to be installed. A pure Fortran95 version of the code is available at [https://napsu.karmitsa.fi/clustering/](https://napsu.karmitsa.fi/clustering/).


To use the code:

1) Select the data, names of output files, numbers of records and 
features, and the maximum number of clusters "nclust" in lmbclust.py file.
2) Run Makefile (by typing "make") to build a shared library that allows lmbmclust (Fortran95 code) to be called from Python.
3) Finally, just type "python3.7 lmbclust.py".

The algorithm returns a txt-file with clustering function values, Dunn and Davies-Bouldin validity indices and elapsed CPU-times up to nclust clusters.
In addition, separate txt-file with the final cluster centers with nclust clusters and the solutions to all intermediate l-clustering problems with l = 1,...,nclust-1 is returned.

## References:

* LMBM-Clust:
  - N. Karmitsa, A.M. Bagirov and S. Taheri, "[Clustering in Large Data Sets with the Limited Memory Bundle Method](https://www.sciencedirect.com/science/article/abs/pii/S0031320318302085)", Pattern Recognition, Vol. 83, pp. 245-259, 2018.
  - A. Bagirov, N. Karmitsa, S Taheri, "[Partitional Clustering via Nonsmooth Optimization](https://link.springer.com/book/10.1007/978-3-030-37826-4)", Springer, 2020.

* LMBM:
  - N. Haarala, K. Miettinen, M.M. Mäkelä, "[Globally Convergent Limited Memory Bundle Method for Large-Scale Nonsmooth Optimization](https://link.springer.com/article/10.1007/s10107-006-0728-2)", Mathematical Programming, Vol. 109, No. 1, pp. 181-205, 2007.
  - M. Haarala, K. Miettinen, M.M. Mäkelä, "[New Limited Memory Bundle Method for Large-Scale Nonsmooth Optimization](https://www.tandfonline.com/doi/abs/10.1080/10556780410001689225)", Optimization Methods and Software, Vol. 19, No. 6, pp. 673-692, 2004.

* Nonsmooth optimization:
  - A. Bagirov, N. Karmitsa, M.M. Mäkelä, "[Introduction to nonsmooth optimization: theory, practice and software](https://link.springer.com/book/10.1007/978-3-319-08114-4)", Springer, 2014.

## Acknowledgements
The work was financially supported by the Research Council of Finland projects (Project No. #289500, #345804, and #345805).


   
