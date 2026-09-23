conda update -n base -c defaults conda
conda install -n base conda-libmamba-solver
conda config --set solver libmamba
conda clean --all
