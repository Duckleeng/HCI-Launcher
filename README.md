# HCI-Launcher

Launcher designed to work with the free version of [HCI MemTest](https://hcidesign.com/memtest/).

## Functionality

HCI MemTest is single threaded (aka. can only run on 1 logical core at a time). Instead of choosing a single core to run on and sticking to it, the test switches the core it runs on in set time intervals. While this behavior is fine when running only 1 instance of the test, it drastically slows down the test when running several instances at the same time. This is because certain cores get congested if several instances of the test decide to run on the same core at the same time. This behavior can be observed if you run several instances of the test. After some time it's obvious that certain instaces are running considerably slower than others (roughly 20% slower). This script aims to resolve this issue by letting you choose how many instances of the test to launch and which cores to assign them to.

## Usage

Config parameters:

- `$path` - specify the path of HCI memtest, by default it is assumed the test is located in the same directory as the script

- `$threads` - specify the number of instances (threads) of the test to run, ideally this should be your number of cores

- `$affinity` - specify which cores to assign the threads to, each thread is assigned to 1 core
    - e.g. to set the threads to run on the first 8 cores, use the following syntax:
        - `[int[]]$affinity = (0,1,2,3,4,5,6,7)`

    - if there are more threads than specified cores, the affinities will loop
        - e.g. launching 8 threads with an affinity of `0,1,2` will launch 8 instances with these affinities: `0,1,2,0,1,2,0,1`

    - if no affinity is set, the threads will be spread across all cores

Parameters can also be set when launching the script via command line arguments:<br>
`.\HCI-Launcher.ps1 -Path "memtest.exe" -Threads 8 -Affinity 0,1,2,3,4,5,6,7`

After all threads have launched, you will need to manually set the amount of memory for each thread, then start the test on each one

>[!Note]
>The maximum amount of memory that can be allocated to 1 thread is 3548MB