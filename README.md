8# Admissible-Control-Reconstruction
## Publication
 Chong He*, Zheng Gong, Mo Chen, Sylvia Herbert, "Efficient and Guaranteed Hamilton-Jacobi Reachability via Self-Contained Subsystem Decomposition and Admissible Control Sets", in Control Systems Letters, IEEE, 2024 \
 Link: https://ieeexplore.ieee.org/document/10365682
## Abstract
Hamilton-Jacobi reachability analysis is a useful tool for generating reachable sets and corresponding optimal control policies, but its use in high-dimensional systems is hindered by the "curse of dimensionality." Self-contained subsystem decomposition is a proposed solution, but it can produce conservative or incorrect results due to the "leaking corner issue." This issue arises from the inexact decomposition of the target set and inconsistencies across the computed control policies for each coupled subsystem. In this paper, we define and resolve this issue by introducing the notion of an admissible control set that enforces consistent control actions across the coupled subsystems. Our method efficiently computes exact reachable sets and the corresponding optimal control policy for self-contained subsystems with a decomposable goal (or failure) set. We also provide conservative under-approximations for goal (or failure) sets with inexact decomposition. In this conservative case, a local update method in the full dimensional space can be applied to recover exact results. We validate our approach on a 3D system and demonstrate its scalability on a 6D system.
## Dependencies
(1) HelperOC: https://github.com/HJReachability/helperOC/ \
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
## Contact
Chong: chong_he@sfu.ca
