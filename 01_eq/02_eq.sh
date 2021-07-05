#!/bin/bash
set -Ceu
cat << EOS
Author: Shinji Iida 3.6.2019 
This script submits MD runs.
    Usage:
        bash ${0} [run id] 
EOS
id=$1

bash check_mdpfiles.sh

read -p "Proceed? Enter"

echo "Making md inputs...(nvt.mdp and npt.mdp)"
cat templates/template_nvt.mdp | sed -e "s!#{RAND}!${RANDOM}!g" > nvt_eq_${id}.mdp
cp  templates/template_npt.mdp npt_eq_${id}.mdp

echo "NVT equilibration runs are running..."
gmx grompp -f nvt_eq_${id}.mdp \
           -c em2.gro \
           -r em2.gro \
           -p topol.top \
           -o nvt_eq_${id}.tpr
gmx mdrun -deffnm nvt_eq_${id} #-ntmpi 1 -ntomp 6

echo "NPT equilibration runs are running..."
gmx grompp -f npt_eq_${id}.mdp \
           -c nvt_eq_${id}.gro \
           -r nvt_eq_${id}.gro \
           -p topol.top  \
           -o npt_eq_${id}.tpr
gmx mdrun -deffnm npt_eq_${id} #-ntmpi 1 -ntomp 6
