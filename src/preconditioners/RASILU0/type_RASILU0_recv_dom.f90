module type_RASILU0_recv_dom
#include <messenger.h>
    use mod_kinds,                  only: rk, ik
    use mod_chidg_mpi,              only: IRANK

    use type_mesh,                  only: mesh_t
    use type_blockmatrix,           only: blockmatrix_t
    use type_RASILU0_recv_dom_comm, only: RASILU0_recv_dom_comm_t
    implicit none





    !>  In the Restricted Additive Schwarz-type preconditioner, each local domain
    !!  needs to receive overlapping data from other processors. A single local domain
    !!  could potentially be receiving overlapping data from multiple different processors.
    !!  This data type stores the data being received by a single local block from all processors
    !!  that are sending overlapping data.
    !!
    !!  @author Nathan A. Wukie (AFRL)
    !!  @date   7/21/2016
    !!
    !!
    !-------------------------------------------------------------------------------------------
    type, public :: RASILU0_recv_dom_t

        type(RASILU0_recv_dom_comm_t), allocatable  :: comm(:)  ! One communication storage 
                                                                ! type for each processor 
                                                                ! sending overlapping data.

    contains

        procedure   :: init

    end type RASILU0_recv_dom_t
    !*******************************************************************************************






contains





    !>
    !!
    !!  @author Nathan A. Wukie (AFRL)
    !!  @date   7/21/2016
    !!
    !!
    !!
    !------------------------------------------------------------------------------------------
    subroutine init(self,mesh,a)
        class(RASILU0_recv_dom_t),  intent(inout)   :: self
        type(mesh_t),               intent(in)      :: mesh
        type(blockmatrix_t),        intent(in)      :: a

        integer(ik),    allocatable :: recv_procs(:)
        integer(ik)                 :: icomm, nrecv_procs, proc, ierr


        !
        ! Compute the number of processors we are receiving conforming neighbor data from. 
        ! NOT chimera
        ! 
        recv_procs  = mesh%get_recv_procs_local()
        nrecv_procs = size(recv_procs)


        allocate(self%comm(nrecv_procs), stat=ierr)
        if (ierr /= 0) call AllocationError


        !
        ! Call initialization for each container receiving data from a particular processor
        !
        do icomm = 1,nrecv_procs
            proc = recv_procs(icomm)
            call self%comm(icomm)%init(mesh,a,proc)
        end do !icomm


    end subroutine init
    !******************************************************************************************












end module type_RASILU0_recv_dom
