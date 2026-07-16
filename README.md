# Design-a-High-Performance-32-Bit-x-32-Bit-Multiplier

This project focuses on the research, design, and comparative analysis of three distinct 32-bit x 32-bit multiplier architectures to evaluate trade-offs between area, speed, and power consumption. The designs are structured using 3 multiplication method such as “Baugh-Wooley Multiplier”, “Modified Wallace Tree Multiplier” and “Radix-4 Modified Booth Algorithm”. The results of these multipliers are compared and analysed to find out the fastest multiplier of all the three multipliers

---

## 🏗 Architectures Implemented
We explore three structural approaches to multiplication:

1.  **Baugh-Wooley Array Multiplier:** A classic, regular array structure. It is easy to design but features $O(N)$ delay, making it the slowest option. Ideal for educational baselines.
2.  **Modified Wallace Tree Multiplier:** Uses a parallel Carry-Save Adder (CSA) reduction tree. It achieves the fastest timing ($O(log N)$ delay) by sacrificing area (high LUT utilization). Best for High-Performance Computing (HPC).
3.  **Radix-4 Booth Multiplier:** Utilizes booth encoding to halve the partial products before reduction. This architecture provides the best **balance** between area, power, and speed.

---

## 📊 Performance Comparison Summary

Based on our synthesis and simulation result on Xilinx Vivado:

| Architecture | Area (Slice LUTs) | Worst Negative Slack (WNS) | Total Power |
| :--- | :---: | :---: | :---: |
| **Baugh-Wooley** | 1580 | -17.630 ns | 0.199 W |
| **Modified Wallace** | 1609 | **-2.767 ns** | 0.233 W |
| **Radix-4 Booth** | **882** | -3.476 ns | **0.149 W** |

### Key Takeaways:
*   **Fastest:** Modified Wallace Tree (Lowest WNS, optimized for throughput).
*   **Most Efficient:** Radix-4 Booth (Lowest LUT usage and lowest dynamic power).
*   **Baseline:** Baugh-Wooley (Simple structure but poor timing performance at 32-bit).
