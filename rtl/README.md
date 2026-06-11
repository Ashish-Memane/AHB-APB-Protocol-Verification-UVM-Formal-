# Design Under Test (DUT) Socket

This Verification IP is designed to plug-and-play with any standard AMBA AHB-to-APB Bridge. 

To run simulations, place your RTL design files in this folder and ensure your top-level module matches the port mapping defined in `tb/top.sv`. 

**Requirements:**
* DUT must support AHB v2.0 protocol features.
* DUT must include `Hburst` and `Hsize` ports to handle the dynamic array generation from the `ahb_agent`.
