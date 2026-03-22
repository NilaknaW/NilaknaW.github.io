# From Curiosity to Silicon: My First Analog IC Design

November 11, 2025

Ever since I was a child, I’ve been fascinated by how computers are made, staring at motherboards and wondering how these tiny circuits could accomplish so much. Years later, that curiosity became reality. Along with my teammate Pravindu, I completed my first analog IC design, a simple amplifier, yet a major milestone in our undergraduate journey.


![500 alt text](https://raw.githubusercontent.com/NilaknaW/NilaknaW.github.io/main/assets/assets/markdown/opamp/gds.png)

## From Breadboards to Silicon

After a couple of good analog projects on breadboards and PCBs, I had always wanted to try IC designing. Around this time, I was also exploring digital design through FPGA-based RTL designs and had built a few projects, including a UART, a Floating Point ALU, and a Matrix Multiplier, all available on my GitHub. However, analog design beyond LTSpice and breadboards felt out of reach, especially with paid commercial tools.

This was far from the truth; while following a course on ASIC design, I learned about open-source PDK tools and how to use them. From setting up the environment to designing the simplest inverter, it was quite challenging at first. Nevertheless, the open-source toolkit, IHP Open Source IC (OSIC) tools, provided the capability for the complete design flow. I used Xschem for schematic design and simulation, and KLayout and Magic for layout design.

## The project: a low-power operational amplifier

Our goal was to design a low-power single-ended operational amplifier. I focused primarily on layout design, while Pravindu led schematic design and simulations, performing comprehensive AC/DC analyses, corner analyses, and Monte Carlo simulations, each confirming the robustness of the proposed design in meeting the target specifications.

![500 alt text](https://raw.githubusercontent.com/NilaknaW/NilaknaW.github.io/main/assets/assets/markdown/opamp/schematic.png)

Starting the layout was exciting but also overwhelming. With no prior experience and almost no references, the blank canvas in KLayout offered no obvious place to begin. I then decided to take a modular approach, which in the end helped us massively with debugging. I first developed a floor plan, optimizing for matching requirements while balancing area and power constraints. Here, I focused on common centroid layouts for matching transistor pairs, dummy devices to preserve uniformity in fabrication, and careful routing to minimize mismatches and parasitic effects. One by one, I built each module, and Pravindu verified it with parasitic-aware simulations. This allowed us to debug any errors in the layout and optimize for the expected outcome immediately, without affecting other sections of the design.

#### Final Performance Summary

| Parameter           | Achieved        | Target              | Status |
|--------------------|----------------|---------------------|--------|
| DC Gain            | 71.373 dB      | ≥ 60 dB             | Pass   |
| GBW                | 10.004 MHz     | ≥ 1 MHz             | Pass   |
| Phase Margin       | 82.275°        | > 60°               | Pass   |
| Quiescent Current  | 109 μA         | < 100 μA            | Fail   |
| Slew Rate          | 1.2 V/μs       | > 1 V/μs            | Pass   |
| Input Offset       | 0.0265 mV      | < 3 mV              | Pass   |
| Disable Current    | 194.5 pA       | < 2 nA              | Pass   |
| Width              | 88.275 μm      | 140 μm              | Pass   |
| Height             | 75.775 μm      | 80 μm               | Pass   |
| Area               | 6689.038 μm²   | < 11200 μm²         | Pass   |

Each device was designed to comply with DRC and LVS checks. Since there were thousands of design rules in the SKY130 documentation, it was impossible to learn every rule beforehand and then do the design. However, the 500+ DRC violations in the initial attempts and their fixes helped me understand new rules and avoid them later. All the intervening rules with metal layers and several vias needed such precision that even adjusting 0.01 microns in the design made the difference between pass and fail. Nevertheless, I enjoyed every part of the design, which felt like constructing a highway complex for all the electrons to move around. The best part was seeing zero violations in DRC and LVS in the end. One by one, each MOS was completed, and all devices were integrated to make a final design of the op-amp.

![500 alt text](https://raw.githubusercontent.com/NilaknaW/NilaknaW.github.io/main/assets/assets/markdown/opamp/layout.png)

After a few rounds of debugging and rechecking, we finalized our design and obtained clear DRC and LVS results. We conducted CACE corner analysis and post-layout simulations using extracted parasitics to verify the design. It achieved nearly all target specifications, performing as expected after the layout design, validating the schematic-level expectations.

## Tapeout and Next Steps

Later, we submitted our design to the IEEE CASS–CEDA Student Analog Design Contest (Sri Lanka) and presented at the Critical Design Review (CDR), where we gained important feedback on areas to improve in our design. Our design received Second Place, along with a tapeout opportunity via TinyTapeout. I am grateful for the support and guidance from Dr Nilan and Mr Kithmin, and to SkillSurf and the IEEE CASS–CEDA Joint Chapter for their initiative and for introducing Sri Lanka’s student community to open-source silicon design.

![500 alt text](https://raw.githubusercontent.com/NilaknaW/NilaknaW.github.io/main/assets/assets/images/achievements/opampwin.jpg)

We are now looking ahead to June 2026, when we will receive the fabricated chip, the silicon result of months of design, verification, and teamwork. I’ll share updates once we test the silicon and evaluate its real-world performance.

You can explore the complete project here:

Github repository: https://github.com/NilaknaW/sky130_op_amp

Tapeout submission: https://tinytapeout.com/chips/ttsky25b/tt_um_se_opamps

## For those interested in Analog IC Design

I’ll add a few important links for anyone who would like to explore this domain of analog IC design. Open-source tools offer an accessible and cost-effective pathway into IC design and even fabrication. Tiny Tapeout is an amazing initiative where the open-source community comes together to fabricate each other’s silicon chips at a reasonable expense, which helps the academic community grow and explore this domain.

IIC osic tools: https://github.com/iic-jku/IIC-OSIC-TOOLS

TinyTapeout: https://tinytapeout.com/ 

That wraps up my journey of completing my first analog IC design. I’ve always believed there’s something truly magical about analog electronics, and I love being part of it!

Happy designing!