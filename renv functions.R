# utils -------------------------------------------------------------------


# Folder within which packeges are looked for

.libPaths()

# Managing packages 

install.packages()

installed.packages()

remove.packages()

update.packages()

packageStatus()


# renv --------------------------------------------------------------------


# Initialize a new project-local environment with a private R library

renv::init()

# Save the satet of the project library to the lockfile

renv::snapshot()

# Restore the R library exactly as specified in the lockfile

renv::restore()

# Report differences between the project's lockfile and the current state of the project's library (if any)

renv::status()

# Use the version control system to find prior versions of the renv.lock file that have been used in your project

renv::history()

# Find R packages used within a project

renv::dependencies()

# Revert the lockfile to its contents at a prior commit

renv::revert(commit = )

# Deactivate/Activate renv in a project (removes the renv auto-loader from the project .Rprofile). If your want yo remove renv from the project first deactivate renv and then delete the project's renv folder and renv.lock lockfile as desired.

renv::deactivate()
renv::activate()

# Managing packages with the package cache

renv::install()

renv::remove()

renv::update()
