This folder contains code to

1. Get the timing of the events for fMRI analysis [`eventtiming.R`](https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/eventtiming.R)
    * 21/02/20: Turned those into functions: [`hippotiming_func.R`](https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/hippotiming_func.R) and [`sterntiming_func.R`](https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/sterntiming_func.R)
    * Run in R:
  
  ```
  source("/Path/to/file/hippotiming_func.R")
  source("/Path/to/file/sterntiming_func.R")
  hippotiming_func("subject_id")
  sterntiming_func("subject_id")
  ```
2. Analyze the behavioral performance [`behav.R`](https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/behav.R)
    * 21/02/20: Turned those into functions: [`hippo_func.R`](https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/hippo_func.R) and [`stern_func.R`](https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/stern_func.R)
    * Run in R:
  
  ```
  source("/Path/to/file/hippo_func.R")
  source("/Path/to/file/stern_func.R")
  hippo_func("subject_id")
  stern_func("subject_id") 
  ```

Two tasks:

* Sternberg
* Hippocampus

The pictures and task descriptions below are from [Jager et al., 2010](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2918244/)

# Sternberg task

<p align="center">
  <img src="https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/sternberg.png">
</p>


STERN assesses the WM system before and after practice (automatization). Subjects were instructed to memorize a set of five letters (memory set) and subsequently to respond to single letters (probes) by pressing a button if the probe was in the memory set (target). A novel (NT) and a practiced task (PT) were administered. In PT, a fixed memory set was used repeatedly, on which subjects were trained before scanning to induce automatization. In the NT, the composition of the memory set was changed after every epoch. An additional reaction time control task (CT) was in- cluded during which subjects made a button press when the symbol “< >” appeared. In the scanner, each task (CT, PT, and NT) was presented in six epochs (duration, xx seconds) of 10 stimuli each, as well as six rest periods of equal epoch duration.

# Hippocampus task

<p align="center">
  <img src="https://github.com/tientong98/BlockAnesthesia/blob/master/Behavioral%20Data/hippo.png">
</p>

PMT assesses (para)hippocampal-dependent AM and involves three tasks. First, an associative learning task (AL) is performed that requires subjects to establish a meaningful connection between two pictures and to memorize the combination. Next, single pictures have to be classified (SC), which serves as a control task; i.e., compared with AL it requires the same amount of perceptual processing and a motor response, but it lacks the associative learning component. Finally, the retrieval task (RE) asks subjects to recognize specific combinations previously presented during AL, and provides a performance measure. Each task was presented in three epochs (duration, 65 seconds) of eight stimuli each, as well as three rest periods of equal duration.
