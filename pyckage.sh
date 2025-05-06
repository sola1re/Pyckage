#!/bin/bash

######################################################
####### Script to automate python installation #######
################# Made by sola1re ####################
######################################################

# Define color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Functions for displaying colored messages
print_message() { echo -e "${2}${1}${NC}"; }
print_header() { echo -e "\n${PURPLE}==== ${1} ====${NC}"; }
print_success() { echo -e "${GREEN}✓ ${1}${NC}"; }
print_error() { echo -e "${RED}✗ ${1}${NC}"; }
print_info() { echo -e "${CYAN}ℹ ${1}${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ ${1}${NC}"; }
print_cmd() { echo -e "${BLUE}$ ${1}${NC}"; }

# Show help message
show_help() {
    echo -e "${CYAN}Python Virtual Environment Setup Script${NC}"
    echo
    echo -e "Usage: $0 [options]"
    echo
    echo -e "Options:"
    echo -e "  -h, --help                Show this help message"
    echo -e "  -n, --name NAME           Set virtual environment name (default: .venv)"
    echo -e "  -r, --requirements FILE   Install packages from requirements file"
    echo -e "  -e, --environment ENV     Install predefined package group (e.g., math, data, web, etc.) defined below"
    echo
    echo -e "Environment Options:"
    echo -e "  math       → numpy scipy sympy"
    echo -e "  data       → matplotlib seaborn plotly pandas"
    echo -e "  web        → flask django"
    echo -e "  scraping   → requests lxml beautifulsoup4 selenium"
    echo -e "  scripting  → logging schedule"
    echo -e "  app        → pygame PyQt5"
    echo
    echo -e "Examples:"
    echo -e "  $0 -n myenv -e math"
    echo -e "  $0 -r requirements.txt"
    echo
}

# Default values
VENV_NAME=".venv"
REQ_FILE=""
ENV_TYPE=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            show_help
            exit 0
            ;;
        -n|--name)
            VENV_NAME="$2"
            shift 2
            ;;
        -r|--requirements)
            REQ_FILE="$2"
            shift 2
            ;;
        -e|--environment)
            ENV_TYPE="$2"
            shift 2
            ;;
        *)
            if [[ ! "$1" =~ ^- ]]; then
                VENV_NAME="$1"
                shift
            else
                print_error "Unknown option: $1"
                show_help
                exit 1
            fi
            ;;
    esac
done

print_header "Python Environment Setup"

# Install Python if missing
install_python() {
    print_info "Installing Python 3..."
    
    if command -v apt &> /dev/null; then
        print_info "Debian/Ubuntu-based system detected, using apt..."
        sudo apt update && sudo apt install -y python3 python3-pip python3-venv
    elif command -v dnf &> /dev/null; then
        print_info "Fedora-based system detected, using dnf..."
        sudo dnf install -y python3 python3-pip
    elif command -v yum &> /dev/null; then
        print_info "CentOS/RHEL-based system detected, using yum..."
        sudo yum install -y python3 python3-pip
    elif command -v pacman &> /dev/null; then
        print_info "Arch Linux-based system detected, using pacman..."
        sudo pacman -S --noconfirm python python-pip
    elif command -v brew &> /dev/null; then
        print_info "macOS detected, using Homebrew..."
        brew install python
    elif command -v pkg &> /dev/null; then
        print_info "FreeBSD detected, using pkg..."
        sudo pkg install -y python3 py38-pip
    elif command -v apk &> /dev/null; then
        print_info "Alpine Linux detected, using apk..."
        sudo apk add python3 py3-pip
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        print_warning "Windows system detected."
        print_info "Please download and install the Python exe from : https://www.python.org/downloads/windows/"
        exit 1
    else
        print_error "Unable to detect package manager automatically."
        print_info "Please install Python 3 manually and try again."
        exit 1
    fi
    
    # Check if installed successfully
    if command -v python3 &> /dev/null; then
        print_success "Python 3 has been successfully installed."
    else
        print_error "Python 3 installation failed."
        exit 1
    fi
}

PYTHON_CMD="python3"

# Check for Python3
if ! command -v python3 &> /dev/null; then
    print_warning "Python 3 is not installed on this system."
    install_python
else
    python_version=$(python3 --version)
    print_success "Python is already installed: ${python_version}"
fi

# Check for venv module
install_venv() {
    print_info "Installing venv module..."
    
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y python3-venv
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y python3-venv
    elif command -v yum &> /dev/null; then
        sudo yum install -y python3-venv
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm python-virtualenv
    elif command -v brew &> /dev/null; then
        brew install python
    elif command -v pip3 &> /dev/null; then
        pip3 install virtualenv
    else
        print_error "Unable to install venv module automatically."
        print_info "Please install the venv module manually and try again."
        exit 1
    fi
}

if ! $PYTHON_CMD -m venv --help &> /dev/null; then
    print_warning "Python venv module is not available."
    install_venv
    
    # Check if installation succeeded
    if ! $PYTHON_CMD -m venv --help &> /dev/null; then
        print_error "Failed to install venv module."
        exit 1
    else
        print_success "Venv module installed successfully."
    fi
else
    print_success "Venv module already available."
fi

# Create virtual environment
CURRENT_DIR=$(pwd)
VENV_PATH="${CURRENT_DIR}/${VENV_NAME}"

print_header "Creating Virtual Environment"
print_info "Location: ${VENV_PATH}"

if [ ! -d "$VENV_PATH" ]; then
    $PYTHON_CMD -m venv "$VENV_PATH"
    if [ $? -ne 0 ]; then
        print_error "Failed to create virtual environment."
        exit 1
    fi
    print_success "Virtual environment created."
else
    print_warning "Virtual environment already exists at ${VENV_PATH}"
fi

# Generate activation script
ACTIVATE_SCRIPT="${CURRENT_DIR}/activate_${VENV_NAME}.sh"

cat > "$ACTIVATE_SCRIPT" << EOF
#!/bin/bash
# This file is auto-generated

# Warn if not sourced
if [[ "\${BASH_SOURCE[0]}" == "\$0" ]]; then
  echo "⚠ Please 'source' this script instead of executing it:"
  echo "   source activate_${VENV_NAME}.sh"
  exit 1
fi

source "${VENV_PATH}/bin/activate"
EOF

chmod +x "$ACTIVATE_SCRIPT"

# Install predefined package group
if [[ -n "$ENV_TYPE" ]]; then
    print_header "Installing Environment Packages"
    source "${VENV_PATH}/bin/activate"
    pip install -U pip

    case "$ENV_TYPE" in
        math)
            PACKAGES="numpy scipy sympy"
            ;;
        data)
            PACKAGES="matplotlib seaborn plotly pandas"
            ;;
        web)
            PACKAGES="flask django"
            ;;
        scraping)
            PACKAGES="requests lxml beautifulsoup4 selenium"
            ;;
        scripting)
            PACKAGES="logging schedule"
            ;;
        app)
            PACKAGES="pygame PyQt5"
            ;;
        *)
            print_error "Unknown environment type: $ENV_TYPE"
            deactivate
            exit 1
            ;;
    esac

    print_info "Installing packages: $PACKAGES"
    pip install $PACKAGES
    if [ $? -eq 0 ]; then
        print_success "Packages for '${ENV_TYPE}' installed."
    else
        print_error "Failed to install one or more packages."
    fi

    deactivate
fi

# Install requirements if specified
if [[ -n "$REQ_FILE" ]]; then
    if [ -f "$REQ_FILE" ]; then
        print_header "Installing Requirements"
        print_info "Installing packages from ${REQ_FILE}..."
        
        # Install the requirements in the python env
        source "${VENV_PATH}/bin/activate"
        pip install -U pip
        pip install -r "$REQ_FILE"
        
        if [ $? -ne 0 ]; then
            print_error "Failed to install some requirements."
            deactivate
        else
            print_success "All requirements installed successfully."
            deactivate
        fi
    else
        print_error "Requirements file '${REQ_FILE}' not found."
    fi
fi

print_header "Installation Complete"
print_success "Virtual environment is ready!"

print_info "To activate the virtual environment, run:"
print_cmd "source activate_${VENV_NAME}.sh" #############################
print_info "Or manually with:"
print_cmd "source ${VENV_NAME}/bin/activate"
print_info "To deactivate the virtual environment when finished, simply run:"
print_cmd "deactivate"

print_info "Once activated, you can install packages with pip:"
print_cmd "pip install <package-name>"

if [[ -z "$REQ_FILE" ]]; then
    print_info "To install dependencies from a requirements file:"
    print_cmd "pip install -r requirements.txt"
fi