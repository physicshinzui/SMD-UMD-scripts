#!/bin/bash
set -Ceu
cat << EOS
Written by Shinji Iida 
Date: 5.7.2021 
This script automates a system preparation for Gromacs.
This is for umbrella sampling. 

    Usage:
        bash ${0} [PDB file]
EOS
inputPDBName=$1 
proteinName=${inputPDBName%.*}

gmx pdb2gmx -f ${inputPDBName} -o ${proteinName}_processed.gro -water tip3p

#---crucial for smd and us. box size must be arranged for a system of interest.
gmx editconf -f ${proteinName}_processed.gro \
             -o ${proteinName}_newbox.gro \
             -center 3.280 2.181 2.4775 \
             -box 6.560 4.362 12

gmx solvate -cp ${proteinName}_newbox.gro \
            -cs spc216.gro \
            -o ${proteinName}_solv.gro \
            -p topol.top

gmx grompp -f ions.mdp \
           -c ${proteinName}_solv.gro \
           -p topol.top \
           -o ions.tpr

echo "SOL" | gmx genion -s ions.tpr \
                        -o ${proteinName}_solv_ions.gro\
                        -p topol.top \
                        -pname NA -nname CL \
                        -neutral -conc 0.1

echo "Energy minimisation 1 ..."
gmx grompp -f templates/template_em1.mdp \
           -c ${proteinName}_solv_ions.gro \
           -r ${proteinName}_solv_ions.gro \
           -p topol.top \
           -o em1.tpr 
gmx mdrun -deffnm em1 #-ntmpi 1 -ntomp 6

echo "Energy minimisation 2 ..."
gmx grompp -f templates/template_em2.mdp \
           -c em1.gro \
           -p topol.top \
           -o em2.tpr 
gmx mdrun -deffnm em2 #-ntmpi 1 -ntomp 6

exit
