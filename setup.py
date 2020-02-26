
import os
from setuptools import setup

version=None
with open(os.path.join(rootdir, "etc", "ivpm.info"), "r") as fp:
    while True:
        l = fp.readline()
        if l == "":
            break
        if l.find("version=") != -1:
            version=l[l.find("=")+1:].strip()
            break

if version is None:
    raise Exception("Failed to find version in ivpm.info")

if "BUILD_NUM" in os.environ.keys():
    version += "." + os.environ["BUILD_NUM"]

setup(
  name = "generic_sram_bfms",
  version = version,
  packages=['generic_sram_bfms'],
  package_dir = {'' : 'src'},
  author = "Matthew Ballance",
  author_email = "matt.ballance@gmail.com",
  description = ("generic_sram_bfms provides bus functional models for the SRAM protocols"),
  license = "Apache 2.0",
  keywords = ["SystemVerilog", "Verilog", "RTL", "CocoTB"],
  url = "https://github.com/sv-bfms/generic_sram_bfms",
  setup_requires=[
    'setuptools_scm',
    'pybfms'
  ],
)

