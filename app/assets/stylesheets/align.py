#!/usr/bin/env python
# coding=utf-8

from aeneas.exacttiming import TimeValue
from aeneas.executetask import ExecuteTask
from aeneas.language import Language
from aeneas.syncmap import SyncMapFormat
from aeneas.task import Task
from aeneas.task import TaskConfiguration
from aeneas.textfile import TextFileFormat
from aeneas.runtimeconfiguration import RuntimeConfiguration
from aeneas.dtw import DTWAlgorithm
from aeneas.synthesizer import Synthesizer
import aeneas.globalconstants as gc
import os
import json
import csv
from pydub import AudioSegment


dir_path = os.path.dirname(os.path.realpath(__file__))
json_path = u"{}/Thriller.json".format(dir_path)
# create Task object
config = TaskConfiguration()
config[gc.PPN_TASK_LANGUAGE] = Language.ENG
config[gc.PPN_TASK_IS_TEXT_FILE_FORMAT] = TextFileFormat.PLAIN
config[gc.PPN_TASK_OS_FILE_FORMAT] = SyncMapFormat.JSON
task = Task()
task.configuration = config
task.audio_file_path_absolute = u"{}/Thriller.wav".format(dir_path)
task.text_file_path_absolute = u"{}/Thriller.lab".format(dir_path)
task.sync_map_file_path_absolute = json_path
task.os_task_file_levels=3

# create Logger which logs and tees
# logger = Logger(tee=True)

rconf = RuntimeConfiguration()
# rconf.set_granularity(u"3")
# rconf.set_tts(u"3")
# rconf[RuntimeConfiguration.MFCC_WINDOW_LENGTH] = TimeValue(u"0.04")
# rconf[RuntimeConfiguration.MFCC_WINDOW_SHIFT] = TimeValue(u"0.01")
# rconf[RuntimeConfiguration.ABA_NONSPEECH_TOLERANCE] = TimeValue(u"0.080")
# rconf[RuntimeConfiguration.VAD_LOG_ENERGY_THRESHOLD] = TimeValue(u"0.699")
# rconf[RuntimeConfiguration.DTW_ALGORITHM] = DTWAlgorithm.EXACT
# rconf[RuntimeConfiguration.TTS] = Synthesizer.FESTIVAL


# process Task

#  logger=logger
ExecuteTask(task, rconf=rconf).execute()



# print produced sync map
task.output_sync_map_file()

from pprint import pprint
with open('values4.csv', 'w') as csvfile:
    writer = csv.writer(csvfile, delimiter=',',
                            quotechar='"', quoting=csv.QUOTE_MINIMAL)

    waveFile = AudioSegment.from_wav(task.audio_file_path_absolute)

    with open(json_path) as data_file:
        data = json.load(data_file)
        paralines = data['fragments']
        val = 10
        for paraline in paralines:
            writer.writerow(["SENTENCE",paraline['lines'][0],paraline['begin'],paraline['end'],val])
            begin = int(float(paraline['begin']) * 1000)
            end = int(float(paraline['end']) * 1000)
            cut = waveFile[begin:end]
            cut.export("Thriller_s{}.wav".format(val), format="wav")
            val+= 1
        # paralines = data['fragments'][0]['children']
        # for paraline in paralines:
        #     for word in paraline['children']:
        #         writer.writerow([word['lines'][0], word['lines'][0], word['begin'],word['end']])

# pprint(data)
