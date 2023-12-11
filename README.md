# Admissible-Control-Reconstruction
## Publication
## Abstract
## dependencies
(1) helperOC: https://github.com/HJReachability/helperOC
(2) ToolboxLS: https://www.cs.ubc.ca/~mitchell/ToolboxLS/
## File Structure
```bash
Admissible-Control-Reconstruction
│
├──Dynamical systems
│  ├──@DubinsFullCar                    ## Full-dimensional system Dubins Car: 3D
│  ├──@sys1                             ## Subsystem 1 using decomposition method: 2D
│  └──@sys2                             ## Subsystem 2 using decomposition method: 2D
└──scripts
   └──new_compare.m                     ## Main script
      └──decomposition.m                ## Script to compute the result based on decomposition: subBRS and subsystems' ACSs
      │  └──HJIPDE_admis_solve.m        ## HJIPDE solver implemented with ACS computation
      └──fullsysDubins.m                ## Script to generate direct computation from full-dimensional system for comparison
      ├──combine.m                      ## Combine subsystems' ACS into full-dimensional ACS
      ├──eval_u.m                       ## Find u corresponding with its state (modify from helperOC)
      ├──StateWAdms.m                   ## Updating states with ACS
      └──jaccard.m                      ## Generate Jaccard Index, False Include and False Exclude
      ├──visSetIm_trans.m               ## Visualization code for set (modify from helperOC)
      └──visfuncIm_chong.m              ## Visualization code for value function (modify from helperOC)
```
