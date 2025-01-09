#!/bin/bash

# Set directories
FIRMWARE_DIR="/home/erik/a15"
OUTPUT_FILE="/home/erik/crDroid/vendor/sony/pdx245/proprietary-files.txt"
TEMP_FILE="/tmp/prop_files_temp.txt"

# Create header
cat > "${OUTPUT_FILE}" << EOL
# Proprietary files for pdx245 - from XQ-EC72_Customized HK_69.1.A.2.78

EOL

# Function to check if a file is device-specific
is_device_specific() {
    local file="$1"
    if [[ $file =~ pdx245 ]] || \
       [[ $file =~ sony ]] || \
       [[ $file =~ somc ]] || \
       [[ $file =~ /sensors/ ]] || \
       [[ $file =~ /semc/ ]] || \
       [[ $file =~ /acdbdata/ ]] || \
       [[ $file =~ Sharp_4K ]] || \
       [[ $file =~ /camera/ ]]; then
        return 0
    fi
    return 1
}

# Function to process and format a section
process_section() {
    local section_name="$1"
    local find_pattern="$2"
    local filter_type="$3"  # 'device' or 'all'
    
    echo "# ${section_name}"
    
    if [ "$filter_type" = "device" ]; then
        find . -type f $find_pattern | while read -r file; do
            if is_device_specific "$file"; then
                echo "$file" | sed 's|^./|vendor/|'
            fi
        done | sort
    else
        find . -type f $find_pattern | sed 's|^./|vendor/|' | sort
    fi
    
    echo ""
}

# Process vendor_a directory first
echo "Processing vendor_a directory..."
cd "${FIRMWARE_DIR}/vendor_a" || exit 1

{
    # SELinux policies
    echo "# SELinux"
    find . -type f -path "*/selinux/*" | sed 's|^./|vendor/|' | sort
    echo ""

    # ACDB files
    process_section "ACDB" "-path '*/acdbdata/*'" "device"
    
    # Camera files
    process_section "Camera configs" "-path '*/camera/*.xml' -o -path '*/camera/*.txt'" "device"
    process_section "Camera - firmware" "-path '*/firmware/CAMERA*'" "device"
    process_section "Camera - libraries" "-path '*/camera/*.so'" "device"
    
    # Sensors
    process_section "Sensors" "-path '*/sensors/*'" "device"
    
    # Display
    process_section "Display calibration" "-path '*/display/*' -o -name '*Sharp_4K*.xml'" "device"
    
    # Sony specific
    echo "# Sony specific"
    find . -type f | while read -r file; do
        if is_device_specific "$file" && \
           [[ ! $file =~ /camera/ ]] && \
           [[ ! $file =~ /sensors/ ]] && \
           [[ ! $file =~ /acdbdata/ ]] && \
           [[ ! $file =~ /display/ ]]; then
            echo "$file" | sed 's|^./|vendor/|'
        fi
    done | sort
    echo ""
    
} > "${TEMP_FILE}"

# Now process odm_a directory if it exists
if [ -d "${FIRMWARE_DIR}/odm_a" ]; then
    echo "Processing odm_a directory..."
    cd "${FIRMWARE_DIR}/odm_a" || exit 1
    {
        echo "# ODM files"
        find . -type f | while read -r file; do
            if is_device_specific "$file"; then
                echo "$file" | sed 's|^./|odm/|'
            fi
        done | sort
        echo ""
    } >> "${TEMP_FILE}"
fi

# Remove duplicate entries while preserving sections
awk '!seen[$0]++ || /^#/' "${TEMP_FILE}" >> "${OUTPUT_FILE}"

# Clean up
rm -f "${TEMP_FILE}"

# Count entries
total_files=$(grep -v '^#' "${OUTPUT_FILE}" | grep -v '^$' | wc -l)
echo "Generated proprietary-files.txt at ${OUTPUT_FILE}"
echo "Total files listed: ${total_files}"