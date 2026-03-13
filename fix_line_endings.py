import os

def convert_to_lf(filepath):
    with open(filepath, 'rb') as f:
        content = f.read()
    
    # Replace CRLF with LF
    new_content = content.replace(b'\r\n', b'\n')
    
    with open(filepath, 'wb') as f:
        f.write(new_content)
    print(f"Converted {filepath} to LF")

directories = ['code', 'scripts']
for d in directories:
    dir_path = os.path.join(os.getcwd(), d)
    if os.path.exists(dir_path):
        for filename in os.listdir(dir_path):
            if filename.endswith('.py') or filename.endswith('.sh'):
                convert_to_lf(os.path.join(dir_path, filename))
