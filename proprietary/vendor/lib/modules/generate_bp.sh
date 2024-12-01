#!/bin/bash

# Set the directory where the modules are located and output BP file path
modules_directory="/home/erik/crDroid/vendor/sony/pdx245/proprietary/vendor/lib/modules"
output_file_path="$modules_directory/Android.bp"

# Create or overwrite the output file with a header
echo "// Auto-generated Android.bp for kernel modules" > "$output_file_path"

# Loop through all .ko files in the directory
for module_path in "$modules_directory"/*.ko; do
    # Get the module name by stripping directory and extension
    module_name=$(basename "$module_path" .ko)

    # Append the module configuration to the BP file
    cat <<EOL >> "$output_file_path"
cc_prebuilt_library_shared {
    name: "$module_name",
    vendor_available: true,
    recovery_available: true,
    srcs: ["$(basename "$module_path")"],
    installable: true,
    relative_install_path: "lib/modules",
    compile_multilib: "both",
    stl: "none",
}

EOL

done

echo "Android.bp file generated at $output_file_path"
