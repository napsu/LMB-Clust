#*************************************************************************
#*                                                                       *
#*     Makefile for Python combined nonsmooth clustering software        *
#*     with LMBM (version 3.0, last modified 14.05.2024).                *
#*                                                                       *
#*************************************************************************
# 
# Build a shared library to allow lmbmclust (Fortran95 code) to be
# called from Python program lmbclust. Uses f2py, Python3.7, and requires 
# a Fortran compiler (here gfortran) to be installed.
#
# After running this makefile, run the program by typing 
#   python3.7 lmbclust.py
#FF = gfortran -O2 -ffast-math
EXT_SUFFIX := $(zsh python3-config --extension-suffix)
FF = gfortran -O2
PF = python3.7 -m numpy.f2py

all:	lmbclust$(EXT_SUFFIX)
#
# ---- Compile Fortran files --------------------------- 
parameters.o: parameters.f95
	$(FF) -c parameters.f95

initlmbmclust.o: r_precision.mod initlmbmclust.f95
	$(FF) -c initlmbmclust.f95

functionmod.o: r_precision.mod param.mod initclust.mod functionmod.f95
	$(FF) -c functionmod.f95

lmbmclustmod.o: r_precision.mod param.mod initclust.mod lmbmclustmod.f95
	$(FF) -c lmbmclustmod.f95

objfun.o: r_precision.mod functionmod.mod objfun.f95
	$(FF) -c objfun.f95

subpro.o: r_precision.mod param.mod subpro.f95
	$(FF) -c subpro.f95

lmbm.o: r_precision.mod param.mod initclust.mod initlmbm.mod exe_time.mod obj_fun.mod subpro.mod lmbm.f95
	$(FF) -c lmbm.f95

# ---- Create Signature ------------------
lmbclust.pyf: parameters.o initlmbmclust.o functionmod.o lmbmclustmod.o objfun.o subpro.o lmbm.o lmbmclust.f95
	$(PF) --overwrite-signature parameters.f95 initlmbmclust.f95 functionmod.f95 lmbmclustmod.f95 objfun.f95 subpro.f95 lmbm.f95 lmbmclust.f95 -m lmbclust -h lmbclust.pyf

# ---- Compile and Link --------------------------- 
lmbclust$(EXT_SUFFIX): parameters.o initlmbmclust.o functionmod.o lmbmclustmod.o objfun.o subpro.o lmbm.o lmbmclust.f95 lmbclust.pyf
	$(PF) -c $(FLAGS) lmbclust.pyf parameters.f95 initlmbmclust.f95 functionmod.f95 lmbmclustmod.f95 objfun.f95 subpro.f95 lmbm.f95 lmbmclust.f95

# ---- Clean -----------------------------
clean:	
	rm -rf *.o *.mod *.so *.pyf __pycache__
	echo Clean done	