add_test_sources(equations_advection_diffusion
                 integration_1D_linear_adv_diff_mod.pf
                 #integration_2D_linear_advection_diffusion_mod.pf
                 )


add_test_target(equations_advection_diffusion reg_parallel ${equations_advection_diffusion_sources})

