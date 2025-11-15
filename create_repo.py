
import os
import re

def create_repo_from_markdown():
    try:
        with open('init.md', 'r', encoding='utf-8') as f:
            markdown_content = f.read()
    except FileNotFoundError:
        print("Error: init.md not found.")
        return

    root_dir = "nixos-hetzner-vps"
    if not os.path.exists(root_dir):
        os.makedirs(root_dir)
    
    # Use regex to find all file blocks at once
    # A file block starts with the header and contains a code block.
    # We look for the header to get the name, and then the first code block after it.
    
    # Find all filename headers
    file_headers = re.finditer(r'## 📄 \*\*(.+?)\*\*', markdown_content)
    
    # Get positions to split the document
    positions = [m.start() for m in file_headers]
    positions.append(len(markdown_content))

    for i in range(len(positions) - 1):
        start = positions[i]
        end = positions[i+1]
        
        section = markdown_content[start:end]
        
        # Extract filename from the header at the beginning of the section
        filename_match = re.search(r'## 📄 \*\*(.+?)\*\*', section)
        filepath = filename_match.group(1).strip()
        
        # Extract content from the first code block in the section
        code_match = re.search(r'```[a-zA-Z0-9-]*\n(.*?)\n```', section, re.DOTALL)
        if not code_match:
            code_match = re.search(r'```.*\n(.*?)\n```', section, re.DOTALL)
            
        if not code_match:
            print(f"Warning: Could not find code block for {filepath}")
            continue
            
        content = code_match.group(1)
        
        full_path = os.path.join(root_dir, filepath)
        dir_name = os.path.dirname(full_path)
        
        try:
            if dir_name:
                os.makedirs(dir_name, exist_ok=True)
            with open(full_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Successfully created: {full_path}")
        except Exception as e:
            print(f"Error creating file {full_path}: {e}")

if __name__ == "__main__":
    create_repo_from_markdown()
