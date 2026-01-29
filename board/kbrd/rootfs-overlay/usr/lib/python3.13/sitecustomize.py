import sys
from pathlib import Path

p = Path("/usr/lib/python3.13/site-packages")
if p.is_dir() and str(p) not in sys.path:
    sys.path.append(str(p))