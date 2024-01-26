#!/bin/csh

# Minimization
gmx grompp -f step6.0_minimization.mdp -o step6.0_minimization.tpr -c spheres.gro -r spheres.gro -p system.top -n index.ndx -maxwarn 1
gmx mdrun -v -deffnm step6.0_minimization

# step6.1
gmx grompp -f step6.1_minimization.mdp -o step6.1_minimization.tpr -c step6.0_minimization.gro -r spheres.gro -p system.top -n index.ndx -maxwarn 1
gmx mdrun -v -deffnm step6.1_minimization

# Equilibration
set cnt    = 2
set cntmax = 6

while ( ${cnt} <= ${cntmax} )
    @ pcnt = ${cnt} - 1
    if ($cnt == 2) then
        gmx grompp -f step6.${cnt}_equilibration.mdp -o step6.${cnt}_equilibration.tpr -c step6.${pcnt}_minimization.gro -r spheres.gro -p system.top -n index.ndx -maxwarn 1
    else
        gmx grompp -f step6.${cnt}_equilibration.mdp -o step6.${cnt}_equilibration.tpr -c step6.${pcnt}_equilibration.gro -r spheres.gro -p system.top -n index.ndx -maxwarn 1
    endif
    gmx mdrun -v -deffnm step6.${cnt}_equilibration
    @ cnt += 1
end

# Production
gmx grompp -f step7_production.mdp -o step7_production.tpr -c step6.6_equilibration.gro -p system.top -n index.ndx -maxwarn 1
gmx mdrun -v -deffnm step7_production
