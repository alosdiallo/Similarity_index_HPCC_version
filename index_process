#!/bin/sh
#$ -V
#$ -cwd

#$ -o $HOME/sge_jobs_output/sge_job.$JOB_ID.out -j y
#$ -S /bin/bash
#$ -m beas

#take workDir as input
IndexSet=${1}
IndexDataSet=`basename ${IndexSet}`
# get my job number
job_number=$SGE_TASK_ID
#setup necessary paths
jobDir=/dev/shm/jobid_$SGE_TASK_ID
export JOBOUTPUT=output_$SGE_TASK_ID

# Make the directory for the job ID you are running
if [ "$SGE_TASK_ID" = "$SGE_TASK_FIRST" ] ; then
     mkdir -p /dev/shm/jobid_$SGE_TASK_ID
fi


# get offsets
start=$SGE_TASK_FIRST
end=$SGE_TASK_LAST

#create scratch space
mkdir ${jobDir}

jobShell=${jobDir}/${IndexDataSet}.sh
	
#initialize result folders
resultData=${HOME}/nearline/${IndexDataSet}
resultDataNew=${HOME}/nearline/
#mkdir -p ${resultData}


# --- 

#copy input files to scratch
cp ${HOME}/${IndexSet} ${jobDir}/.
cp ${jobDir}/${IndexDataSet} ${resultDataNew}/results/

#check to see if copy was successful
if [ ! -f ${jobDir}/${IndexDataSet} ]
then
	echo "ERROR - could not find the file (${jobDir}/${IndexDataSet})\nexiting.\n";
	exit
fi 
     
# now do something new
#At this time we think the order is False negatives then False positives.
echo "perl /home/dialloa/bin/random.pl ${jobDir}/${IndexDataSet} 11 0" >> ${jobShell}
echo "perl /home/dialloa/bin/pearson_random.pl ${jobDir}/${IndexDataSet} ${jobDir}/result_random.txt" >> ${jobShell}
echo "perl /home/dialloa/bin/csi_matrix_new.pl ${jobDir}/pearson_0.txt ${jobDir}/pearson_1.txt" >> ${jobShell}
echo "perl /home/dialloa/bin/hyper_random.pl ${jobDir}/${IndexDataSet} ${jobDir}/result_random.txt" >> ${jobShell}
echo "perl /home/dialloa/bin/geo_random.pl ${jobDir}/${IndexDataSet} ${jobDir}/result_random.txt" >> ${jobShell}
echo "perl /home/dialloa/bin/Cosine_random.pl ${jobDir}/${IndexDataSet} ${jobDir}/result_random.txt" >> ${jobShell}
echo "perl /home/dialloa/bin/jaccard_random.pl ${jobDir}/${IndexDataSet} ${jobDir}/result_random.txt" >> ${jobShell}
echo "perl /home/dialloa/bin/mm_random.pl ${jobDir}/${IndexDataSet} ${jobDir}/result_random.txt" >> ${jobShell}

# sleep 60;
# echo "perl /home/dialloa/bin/cleaner.pl ${jobDir}/${IndexDataSet}" >> ${jobShell}


chmod 744 ${jobShell}
${jobShell}

