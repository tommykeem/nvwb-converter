import yaml
import sys

def update_name(file_path, new_name, new_project):
    # Read the YAML file
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
        print(data)
    
    # Update the meta.name entry
    if 'meta' in data:
        data['meta']['name'] = new_name
        data['meta']['image'] = new_project
    else:
        data['meta'] = {'name': new_name, 'image': new_project}
    
    # Write the updated YAML back to the file
    with open(file_path, 'w') as file:
        yaml.dump(data, file, default_flow_style=False)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python modify_spec.py <spec_file.yaml> <new_name>")
        sys.exit(1)
    
    spec_file = sys.argv[1]
    new_name = sys.argv[2]
    new_project = "project-" + new_name
    
    update_name(spec_file, new_name, new_project)
    print(f"Updated {spec_file} with new name: {new_name}")