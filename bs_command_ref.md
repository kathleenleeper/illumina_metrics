# Pull indexing QC by run ID
This is now moved into `get_indexing_by_run_id.sh`, and takes the $RUNID as the first argument
## up to date:
```
$ sh get_indexing_by_run_id.sh $RUNID
```

To run the script iteratively over a list of run ids from the past [x] time period (similar to how one would list runs in order to downlaod fastq files):
```
$ bs list runs --newer-than=50d --terse > runlist.txt       
$ while read run; echo $run && do sh get_indexing_by_run_id.sh $run; done < runlist.txt
```
Deprecated:

```
$ RUNID={RUNID}; eval $(bs config load default) &&
    curl --fail -Ss $BASESPACE_API_SERVER/v2/runs/$RUNID/laneindexsummaries -H x-access-token:$BASESPACE_ACCESS_TOKEN |
    jq -r ".Items[] | .IndexingCounts[] | [ .Id, .BioSample.BioSampleName, .Library.Name, .Index1,  .Index2, .FractionMapped ] | @tsv"
```


# relevant run fields

| SequencingStats.PercentGtQ30R1                | 94.6426                                                                                |
| SequencingStats.PercentPf                     | 0.837818                                                                               |


# to download a json file with run stats (hacky lbr)
```
$ RUNID={RUNID}; bs download run -i $RUNID -o runStats --extension=fastq.gz 
```
For list of run IDS:
```
$ while read run; do bs download run -i $run -o $run --extension=fastq.gz; done < 210831_runList.txt  
```
