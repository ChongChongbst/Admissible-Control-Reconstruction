## Admissible-Control-Reconstruction
# File Structure
Admissible-Control-Reconstruction
│
├──Dynamical systems
│  ├──@DubinsFullCar                    ## Full-dimensional system Dubins Car: 3D
│  ├──@sys1                             ## Subsystem 1 using decomposition method: 2D
│  └──@sys2                             ## Subsystem 2 using decomposition method: 2D
└──scripts
   ├──new_compare.m                     ## main script
   │  ├──decomposition.m                ## script to compute the result based on decomposition: subBRS and subsystems' ACSs
   │  └──fullsysDubins.m                ## script to generate direct computation from full-dimensional system for comparison
   │
   ├──HJIPDE_admis_solve.m              ## HJIPDE solver implemented with ACS computation
   ├──StateWAdms.m                      ## 
   ├──combine.m 
