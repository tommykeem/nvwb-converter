import yaml
import sys
import os

def update_name(file_path, new_name, new_project):
    # Read the YAML file
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    
    # Update the meta.name entry
    print(f"Updating {file_path} with new name: {new_name}")
    if 'meta' in data:
        data['meta']['name'] = new_name
        data['meta']['image'] = new_project
    else:
        data['meta'] = {'name': new_name, 'image': new_project}
    
    # Write the updated YAML back to the file
    with open(file_path, 'w') as file:
        yaml.dump(data, file, default_flow_style=False)

def find_subdirectories(directory):
    subdirectories = [d for d in os.listdir(directory) if os.path.isdir(os.path.join(directory, d)) and not d.startswith('.')]
    return subdirectories

def update_layout(file_path, new_name):
    subdirectories = find_subdirectories(new_name)
    layout_entries = []
    for d in subdirectories:
        layout_entries.append({'path': str(d) + "/", 'storage': 'git', 'type': 'code'})
    # Read the YAML file
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)

    print(f"Updating {file_path} with new layout: {subdirectories}")
    data['layout'] = layout_entries
    
    # Write the updated YAML back to the file
    with open(file_path, 'w') as file:
        yaml.dump(data, file, default_flow_style=False)

def clear_secrets(file_path):
    # Read the YAML file
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    
    print(f"Updating {file_path} with blank secrets: []")
    if 'execution' in data and 'secrets' in data['execution']:
        data['execution']['secrets'] = []
    
    # Write the updated YAML back to the file
    with open(file_path, 'w') as file:
        yaml.dump(data, file, default_flow_style=False)

def clear_apps(file_path):
    # Read the YAML file
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    
    print(f"Updating {file_path} with blank apps: []")
    if 'execution' in data and 'apps' in data['execution']:
        data['execution']['apps'] = []
    
    # Write the updated YAML back to the file
    with open(file_path, 'w') as file:
        yaml.dump(data, file, default_flow_style=False)

def clear_mounts(file_path):
    default_mount = [{'description': 'Project directory', 'options': 'rw', 'target': '/project/', 'type': 'project'}]
    # Read the YAML file
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
    
    # Update the meta.name entry
    print(f"Updating {file_path} with default mount: {default_mount}")
    if 'execution:' in data:
        data['execution:']['mounts'] = default_mount
    else:
        data['execution'] = {'mounts': default_mount}
    
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
    update_layout(spec_file, new_name)
    clear_secrets(spec_file)
    clear_mounts(spec_file)
    clear_apps(spec_file)
    print(f"Updating {spec_file}: Complete!")