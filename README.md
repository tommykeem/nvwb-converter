# nvwbConvert
bash utility to turn an arbitrary git repo into a workbench project.

## usage

- `./path_to_nvwbConvert <git_repo> <relative_path_to_project_repo>`
- takes two arguments: `<git_repo>` and `<relative_path_to_project_repo>`
- assumes `<git_repo>` is in working directory
- assumes `<relative_path_to_project_repo>` is an AI Workbench project

## what it does
- copies in `.project` folder and contents from Workbench Project to `<git_repo>`
- copies in environment config files from Workbench Project
- notes if it overwrites any files in `<git_repo>`
- updates meta.name and meta.image.man fields in `spec.yaml` to match `<git_repo>`
- commits changes to `<git_repo>` and adds detailed commit message.

## where it runs and requirements
- runs on ubuntu and should run on mac (not tested)
- editing `spec.yaml` file uses `yq` but will default to sed if not present.
  - sed doesn't seem to totally work.

## left to do
- 
