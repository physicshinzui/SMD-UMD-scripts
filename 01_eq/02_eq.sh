#!/bin/bash
set -Ceu
cat << EOS
Written by Shinji Iida 
Date: 5.7.2021
This script submits MD runs.
    Usage:
        bash ${0} [run id] 
EOS
id=$1

read -p "Proceed? Enter"

echo "NVT equilibration runs are running..."
cat templates/nvt_eq.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > nvt_eq_${id}.mdp
gmx grompp -f nvt_eq_${id}.mdp \
           -c em2.gro \
           -r em2.gro \
           -p topol.top \
           -o nvt_eq_${id}.tpr
gmx mdrun -deffnm nvt_eq_${id} #-ntmpi 1 -ntomp 6

echo "NPT equilibration runs are running..."
cp  templates/npt_eq.mdp npt_eq_${id}.mdp
gmx grompp -f npt_eq_${id}.mdp \
           -c nvt_eq_${id}.gro \
           -r nvt_eq_${id}.gro \
           -p topol.top  \
           -o npt_eq_${id}.tpr
gmx mdrun -deffnm npt_eq_${id} #-ntmpi 1 -ntomp 6
