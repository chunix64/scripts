# @title 📥 X. Find files and download

# @markdown ## 🔍 Search File Types
# @markdown Enter the extensions you want to search for (separated by spaces).
# @markdown Example: `img tar zip`

# @markdown > ⚠️ In Kaggle, FileLink must be executed directly in a notebook cell.
# @markdown > If run through !python show_download_list.py, it will only print plain text instead of a clickable link.


import os
import sys
import ipywidgets as widgets
from IPython.display import FileLink, display

try:
    from google.colab import files
    from IPython.display import display
    IS_COLAB = True
except ImportError:
    IS_COLAB = False

IS_KAGGLE = os.path.exists("/kaggle/working")

# Parse arguments
if len(sys.argv) >= 3:
    TARGET_DIR = sys.argv[1]
    DOWNLOAD_EXT = " ".join(sys.argv[2:])
elif len(sys.argv) == 2:
    TARGET_DIR = sys.argv[1]
    DOWNLOAD_EXT = "img tar zip cpio lz4 txt"
else:
    print(f"Usage: {sys.argv[0]} TARGET_DIR [ext1 ext2 ...]")
    sys.exit(1)

TARGET_DIR = os.path.expanduser(TARGET_DIR)
download_ext = tuple("." + ext for ext in DOWNLOAD_EXT.split())

img_files = []
for root, _, filenames in os.walk(TARGET_DIR):
    for file in filenames:
        if file.endswith(download_ext):
            img_files.append(os.path.join(root, file))

if IS_KAGGLE:
    print("📥 Click to download: ")
    for f in img_files:
        display(FileLink(f))
elif IS_COLAB:
    from google.colab import files
    import ipywidgets as widgets
    from IPython.display import display

    msg = widgets.HTML("<div style='font-size:24px;'>📥 Click to download: </div><br>")
    display(msg)

    def on_click(b):
        print(f"You selected: {b.description}")
        files.download(b.description)

    for f in img_files:
        button = widgets.Button(description=f, layout=widgets.Layout(width="auto"))
        button.add_class("wrap-text")
        button.on_click(on_click)
        display(button)
else:
    print("📥 Click to download: ")
    for f in img_files:
        display(FileLink(f))
