#!/usr/bin/env bash

# set up configurations
TAJO_HOME="/home/dk/tajo-0.12.0-SNAPSHOT"
HADOOP_HOME="/home/dk/hadoop-2.7.1"
DATABASE="tpch"
BASE_DIR=`pwd`
TIME_CMD="/usr/bin/time -f Time:%e"
NUM_OF_TRIALS=1
LOG_FILE="benchmark.log"
LOG_DIR="$BASE_DIR/logs"
TAJO_CMD="$TAJO_HOME/bin/tsql"

TPCH_QUERIES_ALL=( \
        "query_revised/q1.sql" \
        "query_revised/q2.sql" \
        "query_revised/q3.sql" \
        "query_revised/q4.sql" \
        "query_revised/q5.sql" \
        "query_revised/q6.sql" \
        "query_revised/q7.sql" \
        "query_revised/q8.sql" \
        "query_revised/q9.sql" \
        "query_revised/q10.sql" \
        "query_revised/q11.sql" \
        "query_revised/q12.sql" \
        "query_revised/q13.sql" \
        "query_revised/q14.sql" \
        "query_revised/q15.sql" \
        "query_revised/q16.sql" \
        "query_revised/q17.sql" \
        "query_revised/q18.sql" \
        "query_revised/q19.sql" \
        "query_revised/q20.sql" \
        "query_revised/q21.sql" \
        "query_revised/q22.sql" \
)

if [ -e "$LOG_FILE" ]; then
	timestamp=`date "+%F-%R" --reference=$LOG_FILE`
	backupFile="$LOG_FILE.$timestamp"
	mv $LOG_FILE $LOG_DIR/$backupFile
fi

echo ""
echo "***********************************************"
echo "*          TPC-H benchmark on Tajo            *"
echo "***********************************************"
echo "                                               " 
echo "Running Tajo from $TAJO_HOME" | tee -a $LOG_FILE
echo "Running Hadoop from $HADOOP_HOME" | tee -a $LOG_FILE
echo "See $LOG_FILE for more details of query errors."
echo ""

$TAJO_HOME/bin/stop-tajo.sh
sleep 3
trial=0
while [ $trial -lt $NUM_OF_TRIALS ]; do
	trial=`expr $trial + 1`
	echo "Executing Trial #$trial of $NUM_OF_TRIALS trial(s)..."

	for query in ${TPCH_QUERIES_ALL[@]}; do
	        echo ""
                $TAJO_HOME/bin/start-tajo.sh
                sleep 3
                echo "Running Tajo query: $query" | tee -a $LOG_FILE
                echo "\c $DATABASE" > $BASE_DIR/${query}_tmp; cat $BASE_DIR/$query >> $BASE_DIR/${query}_tmp
                $TIME_CMD $TAJO_CMD -f $BASE_DIR/${query}_tmp 2>&1 | tee -a $LOG_FILE | grep '^Time:'
                returncode=${PIPESTATUS[0]}
                if [ $returncode -ne 0 ]; then
                        echo "ABOVE QUERY FAILED:$returncode" | tee -a $LOG_FILE
                fi
                $TAJO_HOME/bin/stop-tajo.sh
                sleep 3
	done

done # TRIAL
echo "***********************************************"
echo ""
