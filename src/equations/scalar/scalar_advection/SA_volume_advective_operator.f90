module SA_volume_advective_operator
#include <messenger.h>
    use mod_kinds,              only: rk,ik
    use mod_constants,          only: ZERO,ONE,TWO,HALF

    use type_operator,          only: operator_t
    use type_chidg_worker,      only: chidg_worker_t
    use type_properties,        only: properties_t
    use DNAD_D
    implicit none


    !>
    !!
    !!  @author Nathan A. Wukie
    !!
    !!
    !!
    !!
    !-------------------------------------------------------------------------
    type, extends(operator_t), public :: SA_volume_advective_operator_t


    contains
    
        procedure   :: init
        procedure   :: compute

    end type SA_volume_advective_operator_t
    !*************************************************************************

contains



    !>
    !!
    !!  @author Nathan A. Wukie (AFRL)
    !!  @date   8/29/2016
    !!
    !--------------------------------------------------------------------------------
    subroutine init(self)
        class(SA_volume_advective_operator_t),   intent(inout)  :: self

        ! Set operator name
        call self%set_name("Scalar Advection Volume Operator")

        ! Set operator type
        call self%set_operator_type("Volume Advective Operator")

        ! Set operator equations
        call self%add_primary_field("u")

    end subroutine init
    !********************************************************************************












    !>
    !!
    !!  @author Nathan A. Wukie
    !!
    !!
    !!
    !!
    !------------------------------------------------------------------------------------
    subroutine compute(self,worker,prop)
        class(SA_volume_advective_operator_t),  intent(inout)   :: self
        type(chidg_worker_t),               intent(inout)   :: worker
        class(properties_t),                intent(inout)   :: prop


        integer(ik)             :: iu

        type(AD_D), allocatable, dimension(:)   ::  &
            u, flux_x, flux_y, flux_z, cx, cy, cz



        !
        ! Get variable index from equation set
        !
        iu = prop%get_primary_field_index('u')


        !
        ! Interpolate solution to quadrature nodes
        !
        u  = worker%get_primary_field_element('u','value')


        !
        ! Get model coefficients
        !
        cx = worker%get_model_field_element('Scalar X-Advection Velocity', 'value')
        cy = worker%get_model_field_element('Scalar Y-Advection Velocity', 'value')
        cz = worker%get_model_field_element('Scalar Z-Advection Velocity', 'value')


        !
        ! Compute volume flux at quadrature nodes
        !
        flux_x = cx * u 
        flux_y = cy * u
        flux_z = cz * u


        !
        ! Integrate volume flux
        !
        call worker%integrate_volume('u',flux_x,flux_y,flux_z)



    end subroutine compute
    !****************************************************************************************************






end module SA_volume_advective_operator
