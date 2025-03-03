# NVIDIA Workbench Converter
This script demonstrates how to easily convert an arbitrary git repo into an NVIDIA AI Workbench compatible project. The converter creates necessary files and manages versions to ensure that it can be run in Workbench.

## Overwritten and Created Files
In order for a Github repo to be converted, specific files must be overwritten and/or added from a template repo. Running the script handles ***most*** necessary changes.

First, the environment config files are transferred from the template into the target repository. These files include:
  - `.project/configpacks`
  - `.project/spec.yaml`
  - `apt.txt`
  - `requirements.txt`
  - `preBuild.bash`
  - `postBuild.bash`
  - `variables.env`

***Note:*** Monitor script as it runs to verify if any files are overwritten in the target Git repository.

Next, the following changes are made to `.project/spec.yaml`: 
  - Updates the meta.name and meta.image fields.
  - Scans the new repository directory structure and updates the layout fields.
  - Resets mounts, secrets, and user-added applications to default values.

Finally, the script finds and updates the template repository `docker-compose.yaml` files to include `NVWB_TRIM_PREFIX` environment variable to all detected services.

## Running the Script via JupyterLab
Use the following steps to load and run the bash script using JupyterLab:

  1. Fork this Project to your own GitHub namespace and copy the link. **Rename this repository such that it contains only lowercase letters to avoid a build error**

    https://github.com/[your_namespace]/<project_name>

  2. Open NVIDIA AI Workbench. Select the location you'd like to work in and clone your project using the GitHub link.
  3. Open JupyterLab from AI Workbench in the top right corner of your project.
  4. Navigate to the `code` directory and look for the file ``nvwb_converter.bash``
  5. At the top of the page, click "+" and select Terminal to open a new Terminal within JupyterLab.
  6. Run the following command:
  
    bash nvwb_converter.bash
  7. When prompted, enter the GitHub URL for the TARGET repository.

  ***Note:*** The TARGET repository refers to the GitHub project that you want to be converted into an NVIDIA Workbench project. Ensure that you have write access to this repository to ensure changes can be pushed upstream.

  8. When prompted, enter the GitHub URL for an **existing** AI Workbench Project to be used as the TEMPLATE.

  ***Note:*** Consider the base build/image of the existing AI Workbench Project when converting your project. Use the most relevant build (Python Basic, Pytorch, etc.) in order to avoid errors down the line.

  9. Allow script to run to completion.

## Running the Script via CLI
Use the following steps to load and run the bash script using the Command Line only:

  1. Fork this Project to your own GitHub namespace and copy the link. **Rename this repository such that it contains only lowercase letters to avoid a build error**

    https://github.com/[your_namespace]/<project_name>

  2. Open a shell (WSL on Windows, Terimanl on Mac/Ubuntu) and activate the Context you want to clone your project in.
    
    nvwb list contexts

    nvwb activate <desired_context>

  3. Clone this project onto the desired machine:

    nvwb clone project <your_project_link>

  4. Open the Project using the following commands:

    nvwb list projects

    nvwb open <project_name>

  5. Once within your project, navigate to the code directory and run the script.

    cd code
    bash nvwb_converter.bash
  6. When prompted, enter the GitHub URL for the TARGET repository.

***Note:*** The TARGET repository refers to the GitHub project that you want to be converted into an NVIDIA Workbench project. Ensure that you have write access to this repository to ensure changes can be pushed upstream.

  7. When prompted, enter the GitHub URL for an **existing** AI Workbench Project to be used as the TEMPLATE.
  
  ***Note:*** Consider the base build/image of the existing AI Workbench Project when converting your project. Use the most relevant build (Python Basic, Pytorch, etc.) in order to avoid errors down the line.

  8. Allow script to run to completion.

## Script Results and Final Steps
Once the script has finished running, move into your newly created directory to push changes back upstream.

***Note:*** The new changes created by the script will be created within the nvwb-converter repository. **These new changes are nested within the repository** and can be pushed upstream as intended.

Then, clone your project from AI Workbench using the target GitHub URL. Additional configurations may include:
  - Project secrets and API keys
  - Project-specific environment variables
  - Custom project mounts
  - Custom applications
  - Changes to the docker-compose file