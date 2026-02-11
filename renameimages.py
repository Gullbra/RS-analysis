import os
import shutil

# ============== SETTINGS ==============
SOURCE_FOLDER_NAME = "my_images"  # <-- Change this to your folder name
PREFIX = "stego"                  # <-- Change this to your desired prefix
# ======================================

# Get the directory where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Build paths
source_folder = os.path.join(script_dir, SOURCE_FOLDER_NAME)
output_folder = os.path.join(script_dir, "renamed images")

# Check if the source folder exists
if not os.path.exists(source_folder):
    print(f"❌ Source folder not found: {source_folder}")
    print(f"   Please create a folder named '{SOURCE_FOLDER_NAME}' next to this script.")
    exit()

# Create the output folder if it doesn't exist
if not os.path.exists(output_folder):
    os.makedirs(output_folder)
    print(f"📁 Created output folder: {output_folder}")

# Get all .png files from the source folder (sorted alphabetically for consistency)
png_files = sorted(
    [f for f in os.listdir(source_folder) if f.lower().endswith(".png")]
)

if not png_files:
    print(f"⚠️  No PNG files found in '{SOURCE_FOLDER_NAME}'.")
    exit()

print(f"Found {len(png_files)} PNG file(s). Renaming...\n")

# Copy and rename each file
for idx, filename in enumerate(png_files, start=1):
    src_path = os.path.join(source_folder, filename)
    new_name = f"{PREFIX}{idx}.png"
    dst_path = os.path.join(output_folder, new_name)

    shutil.copy2(src_path, dst_path)
    print(f"  {filename}  →  {new_name}")

print(f"\n✅ Done! {len(png_files)} image(s) saved to '{output_folder}'")