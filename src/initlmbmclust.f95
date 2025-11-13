!*************************************************************************
!*                                                                       *
!*     Initialization of parameters for LMBM-Clust                       *
!*     (version 3.0,  with Python interface)                             *
!*                                                                       *
!*************************************************************************
!*
!*     Modules included:
!*
!*     initclust        ! Initialization of parameters for clustering.
!*     initlmbm         ! Initialization of LMBM -solver.
!*

MODULE initclust  ! Common parameters for clustering codes. No need to change anything

    USE r_precision, ONLY : prec  ! Precision for reals.
    IMPLICIT NONE
 
    INTEGER, SAVE :: &
        nclust, &      ! Maximum number of clusters.
        nft, &         ! Number of features.
        nrecord, &     ! Number of records.
        maxdim, &      ! Maximum number of variables in optimization.
        maxsize        ! Maximum number of candidate points of data set,
                       !   maxsize >> maxdim.

    ! Input real parameters
    REAL, SAVE :: &
        tlimit         ! Maximum CPU-time in seconds, from user.

    ! Allocatable tables
    REAL(KIND=prec), SAVE, DIMENSION(:), allocatable :: &
        xbest, &       ! Best solution obtained.
        dminim
    REAL(KIND=prec), SAVE, DIMENSION(:,:), allocatable :: &
        a, &           ! Data matrix, from input file.
        dcent          ! Distance (affinity) matrix for cluster centers
    INTEGER, SAVE, DIMENSION(:,:), allocatable :: &
        nk
    INTEGER, SAVE, DIMENSION(:), allocatable :: &
        lcand, &
        list1, &       ! list1(i) gives the cluster where point i belongs.
        nel            ! nel(i) = number of records in cluster i.
       
    ! Other Real parameters.
    REAL(KIND=prec), SAVE :: & !
        tnorm          ! The total number of norms computed.

    ! Other integer parameters. 
    INTEGER, SAVE :: & !
        m1, &                       ! Maximum number of initial solutions.
        ng1, &                      ! Number of canditate points
        ng2, &                      ! Number of canditate points
        nc, &                       ! Current number of clusters, loops from 1 to nclust
        ns, &                       ! Switch for auxiliary and real clustering problem.
        m, &                        ! Number of variables in optimization:
                                    !   m = nft    if ns = 1,
                                    !   m = nft*nc if ns = 2.
        ncand                       ! Number of canditate points.              !


CONTAINS


    SUBROUTINE init_clustpar()   ! User supplied subroutine for further initialization of parameters (when needed).
                                 ! May be left empty.
        IMPLICIT NONE

    END SUBROUTINE init_clustpar

    SUBROUTINE def_clustpar()    ! Default values for parameters. Change values here if needed.

        IMPLICIT NONE
        IF (nrecord <= 1000) THEN
            m1=500
            ng1=8
            ng2=9
        ELSE IF (nrecord <= 10000) THEN
            m1=500
            ng1=3
            ng2=6
        ELSE IF (nrecord <= 50000) THEN
            m1=500
            ng1=3
            ng2=4
        ELSE IF (nrecord <= 100000) THEN
            m1=300
            ng1=1
            ng2=2
        ELSE
            m1=200
            ng1=1
            ng2=2
        END IF


    END SUBROUTINE def_clustpar

END MODULE initclust


MODULE initlmbm  ! Initialization of parameters for LMBM. Change values here if needed.

    USE r_precision, ONLY : prec   ! Precision for reals.
    USE param, ONLY : zero, one    ! Parameters.
    USE initclust, ONLY : maxdim   ! Maximum dimension of x.

    IMPLICIT NONE

    ! Parameters
    INTEGER, PARAMETER :: &
        na      = 2, &             ! Maximum bundle dimension, na >= 2.
        mcu     = 15, &            ! Maximum number of stored corrections, mcu >=1.
        mcinit  = 7, &             ! Initial maximum number of stored corrections, mcu >= mcinit >= 3.
                                   ! If mcinit <= 0, the default value mcinit = 3 will be used.
                                   ! However, the value mcinit = 7 is recommented.
        inma    = 3, &             ! Selection of line search method:
                                   !   inma = 0, Armijo line search,
                                   !   inma = 1, nonmonotone Armijo line search.
                                   !   inma = 2, weak Wolfe line search.
                                   !   inma = 3, nonmonotone  weak Wolfe line search.
        mnma    = 10, &            ! Maximum number of function values used in nonmonotone line search.
        maxnin  = 20               ! Maximum number of interpolations, maxnin >= 0.
                                   ! The value maxnin = 2-20 is recommented with inma=0,
                                   ! maxnin >= 20 with inma=1 and 3, and maxnin =200 with inma=2.
                                   ! For example:
                                   !   inma = 0, maxin = 20.
                                   !   inma = 1, mnma = 20, maxin = 30.
                                   !   inma = 2, maxnin = 200.
                                   !   inma = 3, mnma=10, maxnin = 20.


    ! Real parameters (if parameter value <= 0.0 the default value of the parameter will be used).
    REAL(KIND=prec), SAVE :: &
        tolb    = zero, &         ! Tolerance for the function value (default = -large).
        tolf    = zero, &         ! Tolerance for change of function values (default = 1.0E-8).
        tolf2   = -10.0_prec, &   ! Second tolerance for change of function values.
                                  !   - If tolf2 < 0 the the parameter and the corresponding termination
                                  !   criterion will be ignored (recommended with inma=1,3).
                                  !   - If tolf2 = 0 the default value 1.0E+4 will be used.
        tolg    = 1.0E-5_prec, &  ! Tolerance for the termination criterion (default = 1.0E-5).
        tolg2   = 1.0E-3_prec, &  ! Tolerance for the second termination criterion (default = 1.0E-3).
        eta     = 1.0E-4_prec, &  ! Distance measure parameter, eta > 0.
                                  !   - If eta < 0  the default value 0.0001 will be used.
        epsl    = 0.24E+00, &     ! Line search parameter, 0 < epsl < 0.25 (default = 0.24).
        xmax    = 1000.0_prec     ! Maximum stepsize, 1 < XMAX (default = 1000).

    ! Integer parameters (if value <= 0 the default value of the parameter will be used).
    INTEGER, SAVE :: &
        n,  &      ! Number of variables.
        mit     = 500, &          ! Maximun number of iterations. 500
        mfe     = 500, &          ! Maximun number of function evaluations. 500
        mtesf   =      0, &       ! Maximum number of iterations with changes of
                                  ! function values smaller than tolf (default = 10).
        iprint  =      0, &       ! Printout specification:
                                  !    -1  - No printout.
                                  !     0  - Only the error messages.
                                  !     1  - The final values of the objective function
                                  !          (default used if iprint < -1).
                                  !     2  - The final values of the objective function and the
                                  !          most serious warning messages.
                                  !     3  - The whole final solution.
                                  !     4  - At each iteration values of the objective function.
                                  !     5  - At each iteration the whole solution
        iscale  =     0           ! Selection of the scaling with LMBM:
                                  !     0  - Scaling at every iteration with STU/UTU (default).
                                  !     1  - Scaling at every iteration with STS/STU.
                                  !     2  - Interval scaling with STU/UTU.
                                  !     3  - Interval scaling with STS/STU.
                                  !     4  - Preliminary scaling with STU/UTU.
                                  !     5  - Preliminary scaling with STS/STU.
                                  !     6  - No scaling.


    REAL(KIND=prec), SAVE, DIMENSION(:), allocatable :: x ! Vector of variables


CONTAINS

    SUBROUTINE defaults()  ! Default values for parameters.

        USE param, ONLY: small, large, zero, one, half
        IMPLICIT NONE

        IF (iprint < -1) iprint  = 1               ! Printout specification.
        IF (mit   <= 0) mit      = 500             ! Maximum number of iterations.
        IF (mfe   <= 0) mfe      = n*mit           ! Maximum number of function evaluations.
        IF (tolf  <= zero) tolf  = 1.0E-08_prec    ! Tolerance for change of function values.
        IF (tolf2 == zero) tolf2 = 1.0E+04_prec    ! Second tolerance for change of function values.
        IF (tolb  == zero) tolb  = -large + small  ! Tolerance for the function value.
        IF (tolg  <= zero) tolg2  = 1.0E-05_prec   ! Tolerance for the termination criterion.
        IF (tolg2  <= zero) tolg  = 1.0E-03_prec   ! Tolerance for the second termination criterion.
        IF (xmax  <= zero) xmax  = 1.5_prec        ! Maximum stepsize.
        IF (eta   <  zero) eta   = half            ! Distance measure parameter
        IF (epsl  <= zero) epsl  = 1.0E-04_prec    ! Line search parameter,
        IF (mtesf <= 0) mtesf    = 10              ! Maximum number of iterations with changes
                                                   ! of function values smaller than tolf.
        IF (iscale > 6 .OR. iscale < 0) iscale = 0 ! Selection of the scaling.


    END SUBROUTINE defaults

    SUBROUTINE init_lmbmpar()  ! User supplied subroutine for further initialization of parameters
                               ! (when needed) for LMBM. May be left empty.

        USE initclust, ONLY : ns,nc
        IMPLICIT NONE

        ! For big data sets use larger values
        tolg =1.0E+00
        tolg2 = 1.0E+3
        IF (ns == 2) THEN
            tolg = 1.0E+3
            IF(nc == 5) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 10) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 15) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 20) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 25) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 30) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 35) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 40) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 45) THEN
                tolg = 1.0E-3
            ELSE IF(nc == 50) THEN
                tolg = 1.0E-3
            END IF
        END IF


    ! For small data sets
        !    tolg2 = 1.0E-1
        !    IF(ns == 1) tolg = 1.0E-5
        !    IF(ns == 2) tolg = 1.0E-4

    END SUBROUTINE init_lmbmpar

END MODULE initlmbm
