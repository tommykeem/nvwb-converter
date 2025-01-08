# nvwbConvert
A bash script to turn an arbitrary git repo into an NVIDIA AI Workbench project.

## usage
- open Jupyterlab from AI Workbench
- navigate to ``code/nvwb_converter.bash``
- open a terminal in Jupyterlab (Click "+", then select Terminal)
- run ``bash nvwb_converter.bash``
- when prompted, enter the Github URL for the repo you would like to convert to an AI Workbench project
  - tip: ensure you have write access to ensure changes can be pushed upstream, eg. create a fork if necessary
- when prompted, enter the Github URL for an **existing** AI Workbench project you would like to use as a template
- let the script run to completion

## what it does
- copies in `.project` folder and contents from Workbench Project to `<git_repo>`
- copies in environment config files from Workbench Project
  - `.project/configpacks`
  - `.project/spec.yaml`
  - `apt.txt`
  - `requirements.txt`
  - `preBuild.bash`
  - `postBuild.bash`
  - `variables.env`
- notes if it overwrites any files in `<git_repo>`
- updates `spec.yaml` transferred from the template repo
  - updates the meta.name and meta.image fields
  - reads the new repo directory structure and updates the layout fields
  - resets mounts, secrets, and user-added applications to defaults
- finds and updates and `docker-compose.yaml` files transferred from the template repo
  - Adds the `NVWB_TRIM_PREFIX` environment variable to all detected services
- commits changes to `<git_repo>` and adds detailed commit message.

## next steps
- once converted, push the committed changes of your target repo to upstream
- in AI Workbench, clone the project using the target Github URL with these newly pushed updates
- once built, you can now make necessary project-specific adjustments
  - configure any project secrets and API keys
  - configure project-specific environment variables
  - create custom project mounts
  - add any custom applications
  - update the docker-compose file
