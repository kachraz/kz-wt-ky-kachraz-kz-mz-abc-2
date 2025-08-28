
----

1. [Conda Commands which you use all the time](#conda-commands-which-you-use-all-the-time)
   1. [Creating a new env](#creating-a-new-env)
   2. [Create new env with specific version of panty](#create-new-env-with-specific-version-of-panty)
   3. [Activate Conda](#activate-conda)
   4. [List all conda env](#list-all-conda-env)
   5. [List all installed pkg in current env](#list-all-installed-pkg-in-current-env)
   6. [Install into conda](#install-into-conda)
   7. [Remove a pkg from conda](#remove-a-pkg-from-conda)
   8. [Update Conda](#update-conda)
   9. [Update all packages in current env](#update-all-packages-in-current-env)


----

# Conda Commands which you use all the time 


## Creating a new env 
```sh
conda create --name myenv
```

## Create new env with specific version of panty 
```sh 
conda create --name myenv python=3.8
```

## Activate Conda 
```sh 
conda activate <env>
```

## List all conda env
```sh 
conda env list
```
## List all installed pkg in current env
```sh 
conda list
```

## Install into conda 

```sh 
conda install panty_sniff
```

## Remove a pkg from conda 
```sh 
conda remove panty_sniff
```

## Update Conda 
```sh
conda update conda
```

## Update all packages in current env
```sh 
conda update --all
```
