import os
import sys

BUILD_WORKSPACE_DIRECTORY = "BUILD_WORKSPACE_DIRECTORY"

def execute(input_file):
    if not BUILD_WORKSPACE_DIRECTORY in os.environ:
        raise Exception(f"{BUILD_WORKSPACE_DIRECTORY} not defined")

    build_workspace_dir = os.environ[BUILD_WORKSPACE_DIRECTORY]
    with open(input_file, "r") as f:
        for line in f:
            filename = line.strip()
            full_path = os.path.join(build_workspace_dir, filename)
            print(f"Running clang-format for: {filename}")
            os.system(f"clang-format -style=file -i {full_path}")

if __name__ == "__main__":
    execute(sys.argv[1])
