! :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
! :::::   Modified from amr_module.
! :::::   Allows for storage of amr parameters from adjoint run.
! :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

module amr_reload_module

    implicit none
       
    save

    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    ! :::::   data structure info.
    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    integer, parameter :: rsize = 5
    integer, parameter :: nsize = 19

    !  :::::::   integer part of node descriptor
    integer, parameter :: levelptr  = 1
    integer, parameter :: tempptr   = 2
    integer, parameter :: errptr    = 3
    integer, parameter :: nestlevel = 4
    integer, parameter :: cfluxptr  = 5
    integer, parameter :: ffluxptr  = 6
    integer, parameter :: store1    = 7
    integer, parameter :: store2    = 8
    integer, parameter :: ndilo     = 9
    integer, parameter :: ndihi     = 10
    integer, parameter :: ndjlo     = 11
    integer, parameter :: ndjhi     = 12
    integer, parameter :: storeaux  = 13
    integer, parameter :: storeflags  = 14
    integer, parameter :: numflags  = 15
    integer, parameter :: domflags_base  = 16
    integer, parameter :: domflags2  = 17
    integer, parameter :: bndListSt  = 18
    integer, parameter :: bndListNum = 19

    ! :::::::  real part of node descriptor
    integer, parameter :: cornxlo  = 1
    integer, parameter :: cornylo  = 2
    integer, parameter :: cornxhi  = 3
    integer, parameter :: cornyhi  = 4
    integer, parameter :: timemult = 5

    ! :::::::   for linking nodes
    integer, parameter :: nextfree = 2
    integer, parameter :: null = 0
    integer, parameter :: nil  = 0

    ! :::::::  for flagging points   
    real(kind=8), parameter :: goodpt = 0.0
    real(kind=8), parameter :: badpt  = 2.0
    real(kind=8), parameter :: badpro = 3.0

    real(kind=8), parameter :: NEEDS_TO_BE_SET = 10.e33
    real(kind=8), parameter :: rinfinity = 10.e32
    integer, parameter :: iinfinity = 999999999
    integer, parameter :: horizontal = 1
    integer, parameter :: vertical = 2
    integer, parameter :: maxgr = 15000
    integer, parameter :: maxlv = 10
    integer, parameter :: maxcl = 5000

    ! The max1d parameter should be changed if using OpenMP grid based 
    ! looping, usually set to max1d = 60
    integer, parameter :: max1d = 60 
    !integer, parameter :: max1d = 100 
    !integer, parameter :: max1d = 80 
    !integer, parameter :: max1d = 500 

    integer, parameter :: maxvar = 10
    integer, parameter :: maxaux = 20
    integer, parameter :: maxwave = 10


    real(kind=8) tolsp
    integer numcells(maxlv), &
            iorder,mxnest
       
    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\
    ! :::::   for space management of alloc array
    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    integer, parameter :: lfdim=5000
    integer memsize

    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    ! :::::  domain description variables
    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    logical xperdom, yperdom, spheredom
    real(kind=8) :: xupper, yupper, xlower, ylower
    integer :: nghost, mthbc(4)

    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    ! :::::  collect stats
    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    integer ::  tvoll(maxlv)
    integer :: timeRegridding, timeUpdating, timeValout
    integer :: timeFlglvl,timeGrdfit2,timeGrdfit3,timeGrdfitAll
    integer :: timeSetaux,timeFilval,timeBound,timeStepgrid,timeFilvalTot
    integer :: timeFlagger, timeBufnst

    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    ! :::::  method parameters
    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    character(len=10), allocatable :: auxtype(:)
    integer  method(7), mwaves, mcapa, dimensional_split
    integer, allocatable :: mthlim(:)
    real(kind=8) cfl,cflv1,cfl_level

    logical :: use_fwaves
    logical :: flag_richardson,flag_gradient
    integer :: verbosity_regrid

    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    ! ::::: Parameters and variables related to I/O and checkpointing
    ! ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    logical    printout,matlabout,ncarout

    ! variables for specifying output format
    integer :: output_style, nstop, nout, iout
    real(kind=8), allocatable :: tout(:)
    real(kind=8) :: t0, tfinal
    real(kind=8) :: tstart_thisrun  ! /= t0 in case of restart
    integer :: nq_components, naux_components, output_format
    integer, allocatable :: output_q_components(:)
    integer, allocatable :: output_aux_components(:)
    logical :: output_aux_onlyonce

    ! checkpointing:
    integer :: checkpt_style, nchkpt, checkpt_interval
    real(kind=8), allocatable :: tchk(:)

    integer, parameter :: parmunit = 12
    integer, parameter :: chkunit = 10
    integer, parameter :: inunit  = 5
    integer, parameter :: outunit = 66
    integer, parameter :: pltunit1 = 3
    integer, parameter :: rstunit = 9
    integer, parameter :: dbugunit = 11
    integer, parameter :: matunit = 70

    ! ::::  Debugging flags (verbose output)
    logical &
                dprint,     & !  domain flags output
                eprint,     & !  error estimation output
                edebug,     & !  even more error estimation output
                gprint,     & !  verbose grid generation (clustering,colating...)
                nprint,     & !  nestck reporting
                pprint,     & !  projec tagged pts.
                rprint,     & !  regridding -  summary of new grids
                sprint,     & !  space (memory) output
                tprint,     & !  tick (time stepping) reporting
                uprint        !  updating/upbnding reporting


    ! Restart file name:
    character(len=200) :: rstfile

end module amr_reload_module
