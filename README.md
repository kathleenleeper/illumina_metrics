---
author: kathleen leeper
title: sequencing run distribution QC
---

# Getting data

## 1 - Planned distribution of libraries

Pull expected run distribution (from google spreadsheet)  -- on a per run basis.
These files record the planned # of reads + balance between each library.

## 2 - Pull indexing distribution by run ID (command line)

Pull the indexing information for a given run -- sampleID + % of reads per sample.

You can manually retrieve this data from the basespace page. But you can also do it cleanly via CLI.

These scripts require an authenticated Basespace CLI install -- see [documents here](https://developer.basespace.illumina.com/docs/content/documentation/cli/cli-overview).

You can run this through a shell script - `get_indexing_by_run_id.sh`. It takes the `$RUNID` as the first argument. `$RUNID` can be programmatically retrieved or taken from the Basespace URL.

### Indexing for a single run
```
$ sh get_indexing_by_run_id.sh $RUNID
```
### Indexing of multiple runs

To run the script iteratively over a list of run ids from the past [x] time period (similar to how one would list runs in order to downlaod fastq files):

```
$ bs list runs --newer-than=50d --terse > runlist.txt       
$ while read run; do echo $run && sh get_indexing_by_run_id.sh $run; done < runlist.txt
```

#### Deprecated
This is now packaged in `get_indexing_by_run_id.sh`.

```
$ RUNID={RUNID}; eval $(bs config load default) &&
   curl --fail -Ss $BASESPACE_API_SERVER/v2/runs/$RUNID/laneindexsummaries -H x-access-token:$BASESPACE_ACCESS_TOKEN |
   jq -r ".Items[] | .IndexingCounts[] | [ .Id, .BioSample.BioSampleName, .Library.Name, .Index1,  .Index2, .FractionMapped ] | @tsv"

```
## 3 - Pull metrics

[WIP]

To download a JSON file with run metrics for a given `$RUNID`.

```
$ RUNID={RUNID}; bs download run -i $RUNID -o runStats --extension=fastq.gz
```
To download JSONs from a list of run IDS (`runlist.txt`)
```
$ while read run; do bs download run -i $run -o $run --extension=fastq.gz; done < runList.txt  
```

# pulling all metrics to reset numebrs
```
$ bs list runs --terse > runs/allruns.txt  
$ while read run; do bs download run -i $run -o $run --extension=fastq.gz; done < runs/allruns.txt
```
Move json files to one
