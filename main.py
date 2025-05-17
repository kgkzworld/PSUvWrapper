import os

# Get the directory where the script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Create the path for the new file
file_path = os.path.join(script_dir, "helloword.txt")

# Create an empty file
with open(file_path, 'w') as f:
    pass  # This creates an empty file

print("Hello, World!")