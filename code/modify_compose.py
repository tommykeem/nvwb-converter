import yaml
import sys
import os

def update_env(file_path):
    new_env_list = ["NVWB_TRIM_PREFIX=true"]
    new_env_map = {"NVWB_TRIM_PREFIX": "true"}
    
    # Read the YAML file
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    
    # Update the meta.name entry
    print(f"Updating {file_path} with new env: {new_env_list}")
    for service, details in data.get("services", {}).items():
        if "environment" in details:
            if isinstance(details["environment"], list):
                # yaml uses LIST syntax 
                details["environment"].extend(new_env_list.copy())
            else:
                # yaml uses MAP syntax
                details["environment"].update(new_env_map.copy())
        else:
            details["environment"] = new_env_list.copy()
    
    # Write the updated YAML back to the file
    with open(file_path, 'w') as file:
        yaml.dump(data, file, default_flow_style=False)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python modify_compose.py <compose_file.yaml>")
        sys.exit(1)
    
    compose_file = sys.argv[1]
    
    print("")
    print(f"Updating {compose_file}: Initializing...")
    update_env(compose_file)
    print(f"Updating {compose_file}: Complete!")
    print("")