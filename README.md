# SFTEEG-Tool: A Spatial-Frequency-Temporal EEG Analysis Tool for Motor Imagery Brain-Computer Interfaces v1.0
This work develops a Spatial-Frequency-Temporal EEG Analysis Tool (SFTEEG-Tool), **a MATLAB-based user-friendly toolbox designed for accurate, flexible, and interpretable EEG decoding in MI paradigms**. It enables configurable temporal, frequency, and spatial segmentation, integrates CSP and div-CSP feature extraction methods, and supports multiple linear classifiers including SVM, ridge regression, and lasso regression. 


<img width="1000" height="700" alt="image" src="https://github.com/user-attachments/assets/93e0435c-fac7-44db-8433-240858aa02f2" />

<img width="600" height="300" alt="image" src="https://github.com/user-attachments/assets/71b124f2-d583-45fd-a9a3-2826fffb71b4" />

<img width="600" height="300" alt="image" src="https://github.com/user-attachments/assets/5441d75c-f029-4596-b87e-4810f67da9bc" />

<img width="600" height="300" alt="image" src="https://github.com/user-attachments/assets/88c0cb22-6ff8-4652-8987-d310a92f78a0" />

# Citation
Please cite the tool using this website repository and the manuscript:

+ G. Liu, R. Zhang, L. Tian and W. Zhou, "Fine-Grained Spatial-Frequency-Time Framework for Motor Imagery Brain–Computer Interface," in IEEE Journal of Biomedical and Health Informatics, vol. 29, no. 6, pp. 4121-4133, June 2025, doi: 10.1109/JBHI.2025.3536212.
 
+ R. Zhang, G. Liu, Y. Wang, "SFTEEG-Tool: A Spatial-Frequency-Temporal EEG Analysis Tool for Motor Imagery Brain-Computer Interfaces" (Under submission to JoVE)

# Operating Environments
System:
+ Windows 7 and later
Software:
+ MATLAB R2024a and later releases
+ Signal Processing Toolbox
+ Parallel Computing Toolbox (optional, if you want to execute the training procedure in parallel, you must install this toolbox).

# Usage
**1.Quick Start (Executable Version)**

If you only wish to use the application directly, please download the packaged app from the Usage folder:
FGMI-Tool.mlappinstall.

(a) Open MATLAB → navigate to Home → Add-Ons → Install App → Select File, and choose SFTEEG-Tool_v1.0.mlappinstall.
    Alternatively, you may double-click the file to install it automatically.

(b) After installation, open MATLAB → go to the APPS tab → locate and click SFTEEG-Tool to launch the interface.
    The app provides a complete workflow for MI-EEG decoding, including:

+ Data loading and preprocessing 

+ Time–frequency–spatial segmentation  

+ Feature extraction (CSP/div-CSP)

+ Classification (SVM, ridge, lasso)   

+ Visualization of decoding results and scalp topography

 When hardware resources allow, enable the Parallel option to accelerate computation.

 All processed results and generated figures will be automatically saved in the working directory.


**2. Code Access (For Developers and Researchers)**

If you are interested in debugging, customizing, or exploring the implementation details, please download the contents from the Code folder.
This folder contains:

+ The main MATLAB App Designer source files (.mlapp)

+ Supporting MATLAB functions (.m)

You can open App_v1.mlapp directly in MATLAB App Designer for further development, parameter tuning, or function extension.

+ **For detailed information about the interface, please refer to the paper “SFTEEG-Tool: A Spatial-Frequency-Temporal EEG Analysis Tool for Motor Imagery Brain-Computer Interfaces.”**

+ **For detailed information about the decoding algorithms, please refer to the paper “Fine-Grained Spatial–Frequency–Time Framework for Motor Imagery Brain–Computer Interface.”**

+ **The reference data for testing are provided in the Example_data folder, which users can download and use for evaluation.**

# Corresponding Author
If there is any technical issue, please contact the corresponding author Rui Zhang: 202320399@mail.sdu.edu.cn


