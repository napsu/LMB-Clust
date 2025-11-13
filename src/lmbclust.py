'''
Main program for

LMB-Clust  - Nonsmooth Optimization based Incremental Clustering 
             Software using LMBM (version 3.0 with Python interface)                  *
                                                                       
The LMB-Clust software is covered by the MIT license.

First, select the data, names of output files, numbers of records and 
features, and the maximum number of clusters below. Then, run Makefile 
(by typing "make") to build a shared library that allows lmbmclust 
(Fortran95 code) to be called from Python program lmbclust. The source uses 
f2py, Python3.7, and requires a Fortran  compiler (gfortran by default) 
to be installed. Finally, just type "python3.7 lmbclust.py". 


References:

    for LMBM-Clust:

        N. Karmitsa, A.M. Bagirov and S. Taheri, "Clustering in Large Data Sets with the Limited 
        Memory Bundle Method", Pattern Recognition, Vol. 83, pp. 245-259, 2018.

        A.M. Bagirov, N. Karmitsa, S. Taheri, "Partional Clustering via Nonsmooth Optimization: 
        Clustering via Optimization." Springer, 2020.

    for LMBM:
        N. Haarala, K. Miettinen, M.M. Mäkelä, "Globally Convergent Limited Memory Bundle Method  
        for Large-Scale Nonsmooth Optimization", Mathematical Programming, Vol. 109, No. 1,       
        pp. 181-205, 2007. DOI 10.1007/s10107-006-0728-2.

        M. Haarala, K. Miettinen, M.M. Mäkelä, "New Limited Memory Bundle Method for Large-Scale 
        Nonsmooth Optimization", Optimization Methods and Software, Vol. 19, No. 6, pp. 673-692, 2004. 
        DOI 10.1080/10556780410001689225.

    for NSO and clustering:
        A. Bagirov, N. Karmitsa, M.M. Mäkelä, "Introduction to nonsmooth optimization: theory, 
        practice and software", Springer, 2014.

        A.M. Bagirov, N. Karmitsa, S. Taheri, "Partional Clustering via Nonsmooth Optimization: 
        Clustering via Optimization." Springer, 2020.


    Acknowledgements:

    The work was financially supported by the Research Council of Finland projects 
    (Project No. 289500, 345804, and 345805).

'''
import numpy as np
import lmbclust    # fortran program

# Select the data (if needed modify lmbmclust.f95 to read the data)
infile = '../data/Skin_NonSkin.txt'
    
# Define names for output files
outfile0 = 'centers.txt'       # Result file with cluster centers.
outfile1 = 'indices.txt'       # Result file with function values and validity indices.
    
# Select the maximum number of clusters
nclust = 25
    
# Give the number of records in data
nrec = 245057
    
# Give the number of features in data
nfea = 3
    
# Select the maximum CPU time (in sec)
tlimit = 72000.0 


# Setting parameters for fortran
lmbclust.initclust.nclust = nclust
lmbclust.initclust.nrecord = nrec
lmbclust.initclust.nft = nfea
lmbclust.initclust.tlimit = tlimit

# Call the clustering program (Fortran)
lmbclust.fmodule.lmbmclust(infile,outfile0,outfile1)
print('End of LMB-Clust.')

                

