#/bin/bash

bidsdir=/Shared/rblock_mr/rawdata                                                                                                

# this script is to convert all event timing from BIDS format to FSL's 3 columns format

#subj=(8006 8013 8016 8018 8019 8021 8022 8023 8024 8025 8028 8029 8030 8031 8034 8036 8041 8042 8043 8045 8046 8047 8048 8049 8050 8052 8054 8056 8058 8059 8060 8061 8062 8070)

subj=(8062)

for n in 0 ; do
for event in rest AL SI RE ; do

sh /Shared/rblock_mr/code/BIDSto3col-singlesub.sh -e ${event} $bidsdir/sub-${subj[$n]}/func/sub-${subj[$n]}_task-hippo_events.tsv $bidsdir/sub-${subj[$n]}/func/sub-${subj[$n]}_task-hippo_events-${event}


done
done


