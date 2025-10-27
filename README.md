# CMPEN/EE 454 – Project 2: Camera Projection, Triangulation, and Epipolar Geometry  
**Fall 2025**

## Overview
This project provides a hands-on exploration of core computer vision concepts including the **pinhole camera model**, **triangulation**, and **epipolar geometry**.  
Using synchronized views from two calibrated cameras in a motion capture (mocap) lab, the objective is to understand how 3D scene points relate to 2D image projections and how to reconstruct 3D geometry from multiple views.

The dataset includes:
- Two corrected camera images (`im1corrected.jpg`, `im2corrected.jpg`)
- Two MATLAB camera parameter files (`Parameters_V1.mat`, `Parameters_V2.mat`)
- A set of 3D mocap points (`mocapPoints3D.mat`)

---

## Objectives
1. Interpret and apply **intrinsic** and **extrinsic** camera parameters.
2. Implement 3D→2D projection under the **pinhole camera model**.
3. Perform **3D triangulation** to recover scene geometry.
4. Derive and analyze the **Fundamental Matrix (F)** both analytically and via the **Eight-Point Algorithm**.
5. Quantitatively evaluate the accuracy of epipolar geometry using **Symmetric Epipolar Distance (SED)**.
6. Optionally, extend the project with **cropped view calibration** and **top-down floor-plane rendering**.

---

## Project Tasks

### **Task 3.1 – Understanding Camera Parameters**
- Inspect `Parameters_V1.mat` and `Parameters_V2.mat`.
- Identify internal (K) and external (R, t) parameters.
- Verify that the extrinsics form a valid camera matrix `P = K [R | -RC]`.
- Confirm the relationship between the rotation matrix, quaternion, and camera center.

### **Task 3.2 – Projecting 3D Mocap Points**
- Write a MATLAB function to project 3D mocap points into 2D pixel coordinates.
- Visualize the projections over each image to validate correctness.
- Points should align closely with visible body markers.

### **Task 3.3 – Triangulation of 3D Points**
- Using corresponding 2D points from both views, reconstruct 3D positions via triangulation.
- Compare reconstructed 3D points with the original mocap points.
- Compute **Mean Squared Error (MSE)** as a quantitative accuracy measure.

### **Task 3.4 – Scene Measurements via Triangulation**
Use manual correspondence selection to compute 3D measurements:
- Fit a plane to 3 points on the **floor** and confirm `Z ≈ 0`.
- Fit a plane to 3 points on the **striped wall** and report its equation.
- Measure:
  - Doorway height  
  - Subject’s height (top of head)  
  - 3D position of the camera mounted on the tall tripod  

### **Task 3.5 – Fundamental Matrix from Calibration**
- Derive the **Essential Matrix (E = R S)** from calibration parameters.
- Convert E to F using `F = K₂⁻ᵀ E K₁⁻¹`.
- Visualize epipolar lines using your derived F to verify correctness.

### **Task 3.6 – Fundamental Matrix via Eight-Point Algorithm**
- Implement or adapt the provided eight-point demo code.
- Select at least 8 well-distributed correspondences across the scene.
- Display epipolar lines for both views and record the computed F matrix.

### **Task 3.7 – Quantitative Evaluation (SED)**
- Compute **Symmetric Epipolar Distance (SED)** for both F matrices (from 3.5 and 3.6).
- Compare average SED values; the calibration-based F should yield smaller errors.
- Interpret how SED can guide outlier rejection in real applications.

---

## Extra Credit Options

### **Extra Credit 1 – Cropped Views (5 pts)**
- Crop the camera images and adjust K matrices for the cropped coordinate system.
- Re-compute and visualize an updated F matrix for the cropped images.

### **Extra Credit 2 – Top-Down Floor-Plane View (5 pts)**
- Modify `planewarpdemo` to generate a top-down (bird’s-eye) floor view.
- Automate mapping using known camera parameters.
- Discuss accuracy and potential applications (e.g., movement analysis).

**Contents:**
- MATLAB scripts and functions (`task3_1.m`, `task3_2.m`, etc.)
- PDF report describing methodology and results
- Any additional helper functions or visualization files

## Report Guidelines
Include a section for each task:
- Title each section (e.g., “Results for Task 3.1”).
- Describe your implementation, derivations, and results.
- Include images and visual evidence.
- Discuss challenges and insights.
- If extra credit is completed, add separate labeled sections.

At the end, describe each team member’s contribution

---

## Learning Outcomes
- Understand the geometric relationship between 3D world points and 2D image projections.
- Implement and verify triangulation and camera calibration principles.
- Compute and interpret the fundamental matrix and epipolar geometry.
- Gain practical MATLAB experience in multi-view geometry.
