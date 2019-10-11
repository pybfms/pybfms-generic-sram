
import os
from setuptools import setup

setup(
  name = "generic_sram_bfms",
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
  ],
)

