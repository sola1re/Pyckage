# Pyckage

**Pyckage** is a simple Bash script that automates Python virtual environment setup — from installing Python (if missing) to creating the venv, installing basic packages, and activating it in one go.

---

## 🚀 Features

- Detects your package manager (APT, DNF, YUM, PACMAN, etc.)
- Installs Python 3 and `venv` if not present
- Creates a virtual environment
- Installs packages from:
  - `requirements.txt`
  - Predefined groups (`math`, `data`, `web`, etc.)
- Generates an easy activation script

---

## 🧰 Predefined Environments

| Type       | Packages                                      |
|------------|-----------------------------------------------|
| `math`     | numpy, scipy, sympy                           |
| `data`     | matplotlib, seaborn, plotly, pandas           |
| `web`      | flask, django                                 |
| `scraping` | requests, lxml, beautifulsoup4, selenium      |
| `scripting`| logging, schedule                             |
| `app`      | pygame, PyQt5                                 |

---

## ⚙️ Usage
With git installed, run :
```bash
git pull 
```

```bash
./pyckage.sh [options]
```

### Options

- `-n, --name NAME` – Set environment name (default: `.venv`)
- `-r, --requirements FILE` – Install from a `requirements.txt`
- `-e, --environment ENV` – Use a predefined group
- `-h, --help` – Show help

### Examples

```bash
./pyckage.sh -n my_math_env -e math
./pyckage.sh -r requirements.txt
```

---

## 🔧 Activate & Deactivate

```bash
source activate_<envname>.sh    # or manually with "source <envname>/bin/activate"
deactivate                      # when done
```