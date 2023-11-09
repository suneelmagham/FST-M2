-- Load data from HDFS
episode4 = LOAD 'hdfs:///user/mounika/projectActivity/episodeIV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);
episode5 = LOAD 'hdfs:///user/mounika/projectActivity/episodeV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);
episode6 = LOAD 'hdfs:///user/mounika/projectActivity/episodeVI_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);

-- Filter out the first 2 lines from each file
ranked4 = RANK episode4;
dialogues4 = FILTER ranked4 BY (rank_episode4 > 2);
ranked5 = RANK episode5;
dialogues5 = FILTER ranked5 BY (rank_episode5 > 2);
ranked6 = RANK episode6;
dialogues6 = FILTER ranked6 BY (rank_episode6 > 2);

-- Merge the three inputs
inputData = UNION dialogues4, dialogues5, dialogues6;

-- Group by name
groupByName = GROUP inputData BY name;

-- Count the number of lines by each character
names = FOREACH groupByName GENERATE $0 as name, COUNT($1) as no_of_lines;
namesOrdered = ORDER names BY no_of_lines DESC;

-- Remove the outputs folder
rmf hdfs:///user/mounika/projectActivityOutput;

-- Store result in HDFS
STORE namesOrdered INTO 'hdfs:///user/mounika/projectActivityOutput' USING PigStorage('\t');