#!/bin/bash
RUNID=$1; eval $(bs config load default) &&
    curl --fail -Ss $BASESPACE_API_SERVER/v2/runs/$RUNID/laneindexsummaries -H x-access-token:$BASESPACE_ACCESS_TOKEN |
    jq -r ".Items[] | .IndexingCounts[] | [ .Id, .BioSample.BioSampleName, .Library.Name, .Index1,  .Index2, .FractionMapped ] | @tsv" >> $RUNID.tsv

